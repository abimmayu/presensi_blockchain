import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/user_settings/data/models/present_time_model.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/present_time_repository.dart';

class GetPresentTimeUsecase {
  PresentTimeRepository presentTimeRepository;

  GetPresentTimeUsecase(this.presentTimeRepository);

  Future<Either<Failure, PresentTimeModel>> execute() async {
    return await presentTimeRepository.getPresentTime();
  }
}
