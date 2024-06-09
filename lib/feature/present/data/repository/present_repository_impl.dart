import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/present/data/data_post/present_data_post.dart';
import 'package:presensi_blockchain/feature/present/domain/repository/present_repository.dart';

class PresentRepositoryImpl implements PresentRepository {
  PresentDataPost presentDataPost = PresentDataPostImpl();

  @override
  Future<Either<Failure, String>> addPresentIn({
    required BigInt id,
    required BigInt day,
    required BigInt month,
    required BigInt year,
  }) async {
    try {
      final result = await presentDataPost.addPresentIn(
        id: id,
        day: day,
        month: month,
        year: year,
      );
      return Right(result);
    } catch (e) {
      return Left(
        PresentFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> addPresentOut({
    required BigInt id,
    required BigInt day,
    required BigInt month,
    required BigInt year,
  }) async {
    try {
      final result = await presentDataPost.addPresentOut(
        id: id,
        day: day,
        month: month,
        year: year,
      );
      return Right(result);
    } catch (e) {
      return Left(
        PresentFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> postPresent({
    required BigInt idPresent,
    required BigInt idEmployee,
  }) async {
    try {
      final result = await presentDataPost.postPresent(
        idPresent: idPresent,
        idEmployee: idEmployee,
      );
      return Right(result);
    } catch (e) {
      log("Error nya: $e");
      return Left(
        PresentFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
