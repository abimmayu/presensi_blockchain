import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';

class LoginUsecases {
  final AuthRepository authRepository;

  LoginUsecases(this.authRepository);

  Future<Either<Failure, User?>> execute(String email, String password) async {
    return await authRepository.login(
      email,
      password,
    );
  }
}
