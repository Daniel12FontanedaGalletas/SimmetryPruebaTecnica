// article_repository_mock_impl.dart
import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart';

// Esta clase SIMULA la conexión real a Firebase.
class ArticleRepositoryMockImpl implements ArticleRepository {
  
  @override
  Future<Either<dynamic, ArticleEntity>> createArticle(ArticleEntity article) async {
    // Simular un retraso de red de 1 segundo.
    await Future.delayed(const Duration(seconds: 1)); 
    
    // Devolvemos Right (Éxito) con el mismo artículo simulado.
    return Right(article);
  }

  @override
  Future<Either<dynamic, List<ArticleEntity>>> getArticles() async {
    return const Right([]); 
  }

  @override
  Future<Either<dynamic, String>> uploadArticleImage(String imagePath) async {
    return const Right("http://mock-url/image.jpg"); 
  }
}