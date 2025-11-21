import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart'
    as upload_repo;

class GetUploadedArticlesUseCase {
  final upload_repo.ArticleRepository repository;

  GetUploadedArticlesUseCase(this.repository);

  Future<Either<dynamic, List<ArticleEntity>>> call() async {
    return await repository.getUploadedArticles();
  }
}
