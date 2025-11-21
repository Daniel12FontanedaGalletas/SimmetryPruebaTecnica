import 'package:dartz/dartz.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';

abstract class AuthDatasource {
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, UserEntity>> signInAnonymously();
  Future<Either<Failure, void>> signOut();
}
