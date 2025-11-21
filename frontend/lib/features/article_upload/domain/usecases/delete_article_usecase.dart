import 'package:dartz/dartz.dart';
import '../repositories/article_repository.dart' as upload_repo;

class DeleteArticleUseCase {
  final upload_repo.ArticleRepository repository;

  DeleteArticleUseCase(this.repository);

  Future<Either<dynamic, void>> call(String articleId) async {
    return await repository.deleteArticle(articleId);
  }
}
