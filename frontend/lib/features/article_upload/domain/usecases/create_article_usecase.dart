// create_article_usecase.dart
import 'package:dartz/dartz.dart';
import '../entities/article_entity.dart';
import '../repositories/article_repository.dart';

// TAREA 2.1: Implementación con MOCK DATA
class CreateArticleUseCase {
  final ArticleRepository repository;

  CreateArticleUseCase(this.repository);

  Future<Either<dynamic, ArticleEntity>> call(ArticleEntity article) async {
    // Aquí es donde se llamaría al repositorio real.
    // En Tarea 2.1 (Mock), el repositorio mock simula el éxito/fracaso.
    final result = await repository.createArticle(article);
    return result; 
  }
}