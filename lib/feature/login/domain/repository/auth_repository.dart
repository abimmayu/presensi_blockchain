import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/login/domain/entities/user_data.dart';
import 'package:web3dart/credentials.dart';

abstract class AuthRepository {
  Future<Either<Failure, User?>> login(String email, String password);
  Future<Either<Failure, User?>> signUp(String email, String password);
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, UserData>> getDataUser({
    required String id,
    String collection = "User",
  });
  Future<Either<Failure, void>> addDataUser({
    required String id,
    String collection = "User",
    required Map<String, dynamic> data,
  });
  Future<Either<Failure, void>> updateDataUser({
    required String id,
    String collection = "User",
    required Map<String, dynamic> data,
  });
  Future<Either<Failure, Wallet>> createWallet({required String password});
  Future<Either<Failure, Wallet>> importWallet({
    required String password,
    String? privateKey,
    List<TextEditingController>? mnemonicWords,
  });
}
