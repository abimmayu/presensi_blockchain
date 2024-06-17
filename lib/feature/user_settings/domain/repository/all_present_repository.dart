import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';

abstract class AllPresentRepository {
  Future<Either<Failure, List<PresentResult>>> getAllPresent();
  Future<Either<Failure, DocumentSnapshot>> getHoliday(int year, int month);
  // Future<Either<Failure, List>> getAllEmployeeOnPresent();
}
