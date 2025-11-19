import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart';

class DeleteArticleUseCase {
  final ArticleRepository repository;

  DeleteArticleUseCase(this.repository);

  Future<Either<dynamic, void>> call(String articleId) async {
    return await repository.deleteArticle(articleId);
  }
}