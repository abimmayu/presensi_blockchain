import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';

abstract class PresentRepository {
  // Future<Either<Failure, String>> addPresentIn({
  //   required BigInt id,
  //   required BigInt day,
  //   required BigInt month,
  //   required BigInt year,
  // });
  // Future<Either<Failure, String>> addPresentOut({
  //   required BigInt id,
  //   required BigInt day,
  //   required BigInt month,
  //   required BigInt year,
  // });
  Future<Either<Failure, String>> postPresent({
    required BigInt idPresent,
    required BigInt idEmployee,
  });
}
