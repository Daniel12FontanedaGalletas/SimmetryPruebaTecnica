import 'package:dartz/dartz.dart';
import '../repositories/article_repository.dart';

class DeleteArticleUseCase {
  final ArticleRepository repository;

  DeleteArticleUseCase(this.repository);

  Future<Either<dynamic, void>> call(String articleId) async {
    return await repository.deleteArticle(articleId);
  }
}
