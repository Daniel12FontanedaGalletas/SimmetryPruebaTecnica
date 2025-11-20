import 'package:dartz/dartz.dart';
import '../repositories/article_repository.dart';

class UploadArticleImageUseCase {
  final ArticleRepository repository;

  UploadArticleImageUseCase(this.repository);

  Future<Either<dynamic, String>> call(String imagePath) async {
    return await repository.uploadArticleImage(imagePath);
  }
}
