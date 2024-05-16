import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository authRepository;

  SignUpUsecase(this.authRepository);

  Future<Either<Failure, User?>> signUp(String email, String password) async {
    return await authRepository.signUp(
      email,
      password,
    );
  }
}
