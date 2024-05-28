import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository authRepositoryl;

  LogoutUsecase(this.authRepositoryl);

  Future<Either<Failure, void>> execute() async {
    return await authRepositoryl.logOut();
  }
}
