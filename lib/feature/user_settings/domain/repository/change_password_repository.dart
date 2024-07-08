import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';

abstract class ChangePasswordRepository {
  Future<Either<Failure, void>> changePassword(String newPassword);
}
