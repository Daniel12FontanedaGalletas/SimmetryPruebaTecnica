import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';

abstract class ArticleRepository {
  Future<Either<dynamic, ArticleEntity>> createArticle(ArticleEntity article);
  Future<Either<dynamic, String>> uploadArticleImage(String imagePath);
  Future<Either<dynamic, List<ArticleEntity>>> getUploadedArticles();
  // 💡 NUEVO
  Future<Either<dynamic, void>> deleteArticle(String articleId);
}