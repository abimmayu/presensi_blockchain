import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/core/service/secure_storage.dart';
import 'package:presensi_blockchain/feature/login/data/data_source/login_data_source.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthDataSource auth = AuthDataSourceImpl();
  SecureStorage storage = SecureStorage();

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
}
