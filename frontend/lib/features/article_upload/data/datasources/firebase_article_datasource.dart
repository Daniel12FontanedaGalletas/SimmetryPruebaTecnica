import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io'; 
import 'dart:typed_data';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:http/http.dart' as http; 

class FirebaseArticleDatasource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final String articlesCollection = 'articles';
  final String storageBucket = "symmetry-reporter-backend.firebasestorage.app"; 

  FirebaseArticleDatasource({required this.firestore, required this.storage});

  // --- SUBIDA DE IMÁGENES ---
  Future<String> uploadImage(String imagePath, String userId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final pathOnCloud = 'media/articles/$userId/$fileName';

    if (Platform.isWindows) {
      return _uploadImageRestWindows(imagePath, pathOnCloud);
    }

    try {
      final file = File(imagePath);
      final storageRef = storage.ref().child(pathOnCloud);
      Uint8List fileBytes = await file.readAsBytes();
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await storageRef.putData(fileBytes, metadata);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception("Error SDK Móvil: $e");
    }
  }

  Future<String> _uploadImageRestWindows(String imagePath, String pathOnCloud) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final encodedPath = Uri.encodeComponent(pathOnCloud);
      final url = Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/$storageBucket/o?name=$encodedPath'
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'image/jpeg'},
        body: bytes,
      );

      if (response.statusCode == 200) {
        return 'https://firebasestorage.googleapis.com/v0/b/$storageBucket/o/$encodedPath?alt=media';
      } else {
        throw Exception('Fallo REST Windows: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception("Error subida Windows REST: $e");
    }
  }

  // --- CRUD DE ARTÍCULOS ---
  
  Future<void> uploadArticle(ArticleEntity article) async {
    final articleMap = {
      'articleId': article.articleId,
      'title': article.title,
      'content': article.content,
      'authorName': article.authorName,
      'authorUID': article.authorUID,
      'category': article.category,
      'datePublished': article.datePublished.toUtc().toIso8601String(),
      'thumbnailURL': article.thumbnailURL,
      'isPublished': article.isPublished,
    };
    // Usamos set para crear o sobrescribir (Editar)
    await firestore.collection(articlesCollection).doc(article.articleId).set(articleMap);
  }

  // 💡 NUEVO: Método Borrar
  Future<void> deleteArticle(String articleId) async {
    await firestore.collection(articlesCollection).doc(articleId).delete();
  }

  Future<List<ArticleEntity>> getArticles() async {
    try {
      final snapshot = await firestore
          .collection(articlesCollection)
          //.orderBy('datePublished', descending: true) 
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        DateTime parsedDate;
        try {
          if (data['datePublished'] is Timestamp) {
            parsedDate = (data['datePublished'] as Timestamp).toDate();
          } else if (data['datePublished'] is String) {
            parsedDate = DateTime.parse(data['datePublished'] as String);
          } else {
            parsedDate = DateTime.now();
          }
        } catch (e) {
          parsedDate = DateTime.now();
        }

        return ArticleEntity(
          articleId: data['articleId'] ?? '',
          title: data['title'] ?? 'Sin título',
          content: data['content'] ?? '',
          authorName: data['authorName'] ?? '',
          authorUID: data['authorUID'] ?? '',
          category: data['category'] ?? '',
          datePublished: parsedDate,
          thumbnailURL: data['thumbnailURL'] ?? '',
          isPublished: data['isPublished'] ?? false,
        );
      }).toList();
    } catch (e) {
      throw Exception("Error obteniendo documentos: $e");
    }
  }
}