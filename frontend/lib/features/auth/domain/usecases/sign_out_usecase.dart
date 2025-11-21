import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase implements UseCase<Either<Failure, void>, void> {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({void params}) {
    return repository.signOut();
  }
}
