import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart';

class GetUploadedArticlesUseCase {
  final ArticleRepository repository;

  GetUploadedArticlesUseCase(this.repository);

  Future<Either<dynamic, List<ArticleEntity>>> call() async {
    return await repository.getUploadedArticles();
  }
}
