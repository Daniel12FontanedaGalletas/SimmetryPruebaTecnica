import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart';

class UploadImageUseCase {
  final IArticleRepository repository;

  UploadImageUseCase(this.repository);

  Future<Either<dynamic, String>> call(String imagePath, String userId) {
    return repository.uploadArticleImage(imagePath, userId);
  }
}
