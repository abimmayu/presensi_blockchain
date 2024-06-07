import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/feature/login/data/data_source/login_data_source.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';
import 'package:web3dart/credentials.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthDataSource auth;
  SecureStorage storage = SecureStorage();

  AuthRepositoryImpl(this.auth);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final result = await auth.login(email, password);
      IdTokenResult tokenResult = await result!.getIdTokenResult(true);
      String refreshToken = tokenResult.token!;
      storage.writeData(
        key: "refresh_token",
        value: refreshToken,
      );
      return Right(result);
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

  @override
  Future<Either<Failure, DocumentSnapshot>> getDataUser({
    required String id,
    String collection = "User",
  }) async {
    try {
      final result = await auth.getDataUser(id: id);
      return Right(result);
    } catch (e) {
      return Left(
        LoginFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateDataUser(
      {required String id,
      String collection = "User",
      required Map<String, dynamic> data}) async {
    try {
      final result = await auth.updateDataUser(
        id: id,
        data: data,
      );
      return Right(result);
    } catch (e) {
      return Left(
        LoginFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Wallet>> createWallet(
      {required String password, String? address}) async {
    try {
      final result =
          await auth.createWallet(password: password, address: address);
      return Right(result);
    } catch (e) {
      return Left(
        LoginFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
