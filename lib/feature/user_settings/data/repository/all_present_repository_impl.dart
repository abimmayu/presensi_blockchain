import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/user_settings/data/datasource/all_present_data_source.dart';
import 'package:presensi_blockchain/feature/user_settings/data/datasource/holiday_data_source.dart';
import 'package:presensi_blockchain/feature/user_settings/data/models/all_present_models.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/all_present_repository.dart';

class AllPresentRepositoryImpl implements AllPresentRepository {
  AllPresentDataSource allPresentDataSource = AllPresentDataSourceImpl();
  HolidayDataSource holidayDataSource = HolidayDataSourceImpl();

  @override
  Future<Either<Failure, List<PresentResult>>> getAllPresent() async {
    try {
      final result = await allPresentDataSource.allPresentOnContract();
      return Right(result.result);
    } catch (e) {
      return Left(
        PresentFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DocumentSnapshot>> getHoliday(
    int year,
    int month,
  ) async {
    try {
      final result = await holidayDataSource.getHoliday(year, month);
      return Right(result);
    } catch (e) {
      return Left(
        PresentFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
