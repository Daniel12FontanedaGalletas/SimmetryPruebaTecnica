import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart'
    as upload_repo;
import '../datasources/firebase_article_datasource.dart';

class ArticleRepositoryImpl implements upload_repo.ArticleRepository {
  final FirebaseArticleDatasource datasource;

  ArticleRepositoryImpl({required this.datasource});

  @override
  Future<Either<dynamic, ArticleEntity>> createArticle(
      ArticleEntity article) async {
    try {
      await datasource.uploadArticle(article);
      return Right(article);
    } on FirebaseException catch (e) {
      return Left('Error de Firestore: ${e.code} - ${e.message}');
    } catch (e) {
      return Left('Error desconocido al crear artículo: $e');
    }
  }

  @override
  Future<Either<dynamic, String>> uploadArticleImage(
      String imagePath, String userId) async {
    try {
      final url = await datasource.uploadImage(imagePath, userId);
      return Right(url);
    } catch (e) {
      return Left('Error al subir imagen: $e');
    }
  }

  @override
  Future<Either<dynamic, List<ArticleEntity>>> getUploadedArticles() async {
    try {
      final articles = await datasource.getArticles();
      return Right(articles);
    } catch (e) {
      return Left("Error descargando noticias: $e");
    }
  }

  @override
  Future<Either<dynamic, void>> deleteArticle(String articleId) async {
    try {
      await datasource.deleteArticle(articleId);
      return const Right(null);
    } catch (e) {
      return Left("Error al borrar: $e");
    }
  }
}
