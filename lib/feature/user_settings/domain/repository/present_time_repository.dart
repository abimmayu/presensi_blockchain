import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/user_settings/data/models/present_time_model.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_time.dart';

abstract class PresentTimeRepository {
  Future<Either<Failure, PresentTimeModel>> getPresentTime();
  Future<Either<Failure, void>> updatePresentTime(
    PresentTime getIn,
    PresentTime getOut,
  );
}
