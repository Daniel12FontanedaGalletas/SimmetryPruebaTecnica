import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart';

class UploadArticleImageUseCase {
  final ArticleRepository repository;

  UploadArticleImageUseCase(this.repository);

  Future<Either<dynamic, String>> call(String imagePath) async {
    return await repository.uploadArticleImage(imagePath);
  }
}