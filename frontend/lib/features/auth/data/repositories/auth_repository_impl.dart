import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:news_app_clean_architecture/features/auth/data/datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() {
    return datasource.getCurrentUser();
  }

  @override
  Future<Either<Failure, UserEntity>> signInAnonymously() {
    return datasource.signInAnonymously();
  }

  @override
  Future<Either<Failure, void>> signOut() {
    return datasource.signOut();
  }
}
