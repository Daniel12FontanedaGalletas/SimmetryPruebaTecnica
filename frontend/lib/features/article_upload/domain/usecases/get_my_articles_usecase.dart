import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart';

class GetMyArticlesUseCase {
  final IArticleRepository repository;

  GetMyArticlesUseCase(this.repository);

  Future<Either<dynamic, List<ArticleEntity>>> call(String userId) {
    return repository.getUploadedArticles(userId);
  }
}
