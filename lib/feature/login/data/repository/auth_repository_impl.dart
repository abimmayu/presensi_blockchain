import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/login/data/data_source/login_data_source.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthDataSource auth = AuthDataSourceImpl();

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final result = await auth.login(email, password);
      return Right(result!);
    } on FirebaseAuthException catch (e) {
      return Left(
        LoginFailure(message: e.message),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String email, String password) async {
    try {
      final result = await auth.signUp(email, password);
      return Right(result!);
    } on FirebaseAuthException catch (e) {
      return Left(
        LoginFailure(message: e.message),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      final result = await auth.signOut();
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(
        LoginFailure(message: e.message),
      );
    }
  }
}
