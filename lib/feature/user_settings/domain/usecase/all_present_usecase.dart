import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/all_present_repository.dart';

class AllPresentUsecase {
  AllPresentRepository allPresentRepository;

  AllPresentUsecase(this.allPresentRepository);

  Future<Either<Failure, List<PresentResult>>> execute() async {
    final result = await allPresentRepository.getAllPresent();

    return result;
  }
}
