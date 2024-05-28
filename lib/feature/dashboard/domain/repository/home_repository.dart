import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';

abstract class HomeRepository {
  Future<Either<Failure, List>> getPresentInMonth(
    int id,
    int month,
    int year,
  );
  Future<Either<Failure, List>> getPresentOutMonth(
    int id,
    int month,
    int year,
  );
  Future<Either<Failure, List>> getPresentInYear(
    int id,
    int year,
  );
  Future<Either<Failure, List>> getPresentOutYear(
    int id,
    int year,
  );
}
