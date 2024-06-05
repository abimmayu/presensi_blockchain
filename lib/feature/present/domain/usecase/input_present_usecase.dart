import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/present/data/repository/present_repository_impl.dart';
import 'package:presensi_blockchain/feature/present/domain/repository/present_repository.dart';

class InputPresentUsecase {
  final PresentRepository presentRepository = PresentRepositoryImpl();

  Future<Either<Failure, String>> execute({
    required BigInt idPresent,
    required BigInt idEmployee,
  }) async {
    return await presentRepository.postPresent(
      idPresent: idPresent,
      idEmployee: idEmployee,
    );
  }
}
