import 'package:dartz/dartz.dart';
import '../entities/article_entity.dart';
import '../repositories/article_repository.dart' as upload_repo;

class CreateArticleUseCase {
  final upload_repo.ArticleRepository repository;

  CreateArticleUseCase(this.repository);

  Future<Either<dynamic, ArticleEntity>> call(ArticleEntity article) async {
    final result = await repository.createArticle(article);
    return result;
  }
}
