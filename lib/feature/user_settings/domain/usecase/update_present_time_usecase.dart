import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_time.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/present_time_repository.dart';

class UpdatePresentTimeUsecase {
  PresentTimeRepository presentTimeRepository;

  UpdatePresentTimeUsecase(this.presentTimeRepository);

  Future<Either<Failure, void>> execute(
    PresentTime getIn,
    PresentTime getOut,
  ) async {
    return await presentTimeRepository.updatePresentTime(
      getIn,
      getOut,
    );
  }
}
