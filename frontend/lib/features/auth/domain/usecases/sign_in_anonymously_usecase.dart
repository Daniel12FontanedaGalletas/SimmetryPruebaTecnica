import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repositories/auth_repository.dart';

class SignInAnonymouslyUseCase
    implements UseCase<Either<Failure, UserEntity>, void> {
  final AuthRepository repository;

  SignInAnonymouslyUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call({void params}) {
    return repository.signInAnonymously();
  }
}
