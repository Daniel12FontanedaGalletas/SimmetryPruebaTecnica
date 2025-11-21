import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/features/auth/data/datasources/auth_datasource.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';

class FirebaseAuthDatasource implements AuthDatasource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDatasource(this._firebaseAuth);

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return Right(UserEntity(uid: user.uid));
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Error getting current user: $e"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      final user = userCredential.user;
      if (user != null) {
        print("✅ Anonymous sign-in successful. UID: ${user.uid}");
        return Right(UserEntity(uid: user.uid));
      }
      return Left(
          ServerFailure("Anonymous sign-in failed: User object is null."));
    } on FirebaseAuthException catch (e) {
      final errorMessage =
          "Firebase Auth Error: '${e.message}' (Code: ${e.code}).\n\n"
          "ACTION: If code is 'operation-not-allowed', you MUST enable Anonymous Sign-In in the Firebase console -> Authentication -> Sign-in method.";
      print("❌ ${errorMessage}");
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      final errorMessage = "An unexpected error occurred during sign-in: $e";
      print("❌ ${errorMessage}");
      return Left(ServerFailure(errorMessage));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Error signing out: $e"));
    }
  }
}
