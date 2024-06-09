import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';
import 'package:web3dart/credentials.dart';

class ImportWalletUsecase {
  final AuthRepository authRepository;

  ImportWalletUsecase(this.authRepository);

  Future<Either<Failure, Wallet>> execute({
    required String password,
    String? privateKey,
    List<TextEditingController>? mnemonicWords,
  }) async {
    return await authRepository.importWallet(
      password: password,
      privateKey: privateKey,
      mnemonicWords: mnemonicWords,
    );
  }
}
