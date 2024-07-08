import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/change_password_repository.dart';

class ChangePasswordUsecase {
  ChangePasswordRepository changePasswordRepository;

  ChangePasswordUsecase(this.changePasswordRepository);

  Future<Either<Failure, void>> execute(String newPassword) async {
    return await changePasswordRepository.changePassword(newPassword);
  }
}
