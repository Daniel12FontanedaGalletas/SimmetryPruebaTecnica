import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart';

class ArticleRepositoryMockImpl implements ArticleRepository {
  @override
  Future<Either<dynamic, ArticleEntity>> createArticle(
      ArticleEntity article) async {
    await Future.delayed(const Duration(seconds: 1));

    return Right(article);
  }

  @override
  Future<Either<dynamic, List<ArticleEntity>>> getUploadedArticles() async {
    return const Right([]);
  }

  @override
  Future<Either<dynamic, String>> uploadArticleImage(String imagePath) async {
    return const Right("http://mock-url/image.jpg");
  }

  @override
  Future<Either<dynamic, void>> deleteArticle(String articleId) async {
    return const Right(null);
  }
}
