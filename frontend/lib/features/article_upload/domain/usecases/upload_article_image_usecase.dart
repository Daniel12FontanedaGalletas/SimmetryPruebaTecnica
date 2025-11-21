import 'package:dartz/dartz.dart';
import '../repositories/article_repository.dart' as upload_repo;

class UploadArticleImageUseCase {
  final upload_repo.ArticleRepository repository;

  UploadArticleImageUseCase(this.repository);

  // [MODIFICACIÓN] Se acepta el userId
  Future<Either<dynamic, String>> call(String imagePath, String userId) async {
    return await repository.uploadArticleImage(imagePath, userId);
  }
}
