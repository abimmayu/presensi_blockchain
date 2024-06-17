import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/all_present_repository.dart';

class GetHolidayUsecase {
  final AllPresentRepository allPresentRepository;

  GetHolidayUsecase(this.allPresentRepository);

  Future<Either<Failure, DocumentSnapshot>> execute(int year, int month) async {
    return await allPresentRepository.getHoliday(year, month);
  }
}
