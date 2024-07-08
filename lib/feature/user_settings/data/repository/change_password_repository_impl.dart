import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/user_settings/data/datapost/user_settings_datapost.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/change_password_repository.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  UserSettingsDataPost userSettingsDataPost = UserSettingsDataPostImpl();

  @override
  Future<Either<Failure, void>> changePassword(String newPassword) async {
    try {
      final result = await userSettingsDataPost.changePassword(newPassword);
      return Right(
        result,
      );
    } on FirebaseAuthException catch (e) {
      return Left(
        LoginFailure(message: e.message),
      );
    }
  }
}
