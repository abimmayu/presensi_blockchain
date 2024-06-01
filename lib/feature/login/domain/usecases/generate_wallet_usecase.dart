import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';
import 'package:web3dart/credentials.dart';

class GenerateWalletUsecase {
  final AuthRepository walletRepository;

  GenerateWalletUsecase(this.walletRepository);

  Future<Either<Failure, Wallet>> execute(String password) async {
    return await walletRepository.createWallet(password);
  }
}
