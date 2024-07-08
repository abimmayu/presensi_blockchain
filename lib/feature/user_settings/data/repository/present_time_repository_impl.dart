import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/core/service/firebase_firestore.dart';
import 'package:presensi_blockchain/feature/user_settings/data/models/present_time_model.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_time.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/present_time_repository.dart';

class PresentTimeRepositoryImpl implements PresentTimeRepository {
  FireStore fireStore = FireStore();

  @override
  Future<Either<Failure, PresentTimeModel>> getPresentTime() async {
    try {
      final resultIn = await fireStore.getData(
        doc: 'Masuk',
        collection: 'Waktu Presensi',
      );
      final getIn = resultIn.data();
      final resultOut = await fireStore.getData(
        doc: 'Pulang',
        collection: 'Waktu Presensi',
      );
      final getOut = resultOut.data();
      return Right(
        PresentTimeModel.fromJson(
          getIn as Map<String, dynamic>,
          getOut as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      return Left(
        PresentFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updatePresentTime(
    PresentTime getIn,
    PresentTime getOut,
  ) async {
    try {
      await fireStore.updateData(
        doc: 'Masuk',
        collection: "Waktu Presensi",
        data: getIn.toJson(),
      );
      await fireStore.updateData(
        doc: "Pulang",
        collection: "Waktu Presensi",
        data: getOut.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(
        PresentFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
