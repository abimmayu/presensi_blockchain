import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi_blockchain/core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, User?>> login(String email, String password);
  Future<Either<Failure, User?>> signUp(String email, String password);
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, DocumentSnapshot>> getDataUser({
    required String id,
    String collection = "User",
  });
}
