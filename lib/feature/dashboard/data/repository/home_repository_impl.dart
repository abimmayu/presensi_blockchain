import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/dashboard/data/data_source/home_data_source.dart';
import 'package:presensi_blockchain/feature/dashboard/domain/repository/home_repository.dart';
import 'package:web3dart/json_rpc.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeDataSource homeDataSource = HomeDataSourceImpl();

  @override
  Future<Either<Failure, List>> getPresentInMonth(
    int id,
    int month,
    int year,
  ) async {
    try {
      final result = await homeDataSource.getPresentInMonth(id, month, year);
      return Right(result);
    } on SocketException catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } on TimeoutException catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } on RPCError catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } catch (e) {
      return Left(
        HomeFailure(message: "Unexpected Error: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List>> getPresentOutMonth(
    int id,
    int month,
    int year,
  ) async {
    try {
      final result = await homeDataSource.getPresentOutMonth(id, month, year);
      return Right(result);
    } on SocketException catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } on TimeoutException catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } on RPCError catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } catch (e) {
      return Left(
        HomeFailure(message: "Unexpected Error: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List>> getPresentInYear(
    int id,
    int year,
  ) async {
    try {
      final result = await homeDataSource.getPresentInYear(id, year);
      return Right(result);
    } on SocketException catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } on TimeoutException catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } on RPCError catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } catch (e) {
      return Left(
        HomeFailure(message: "Unexpected Error: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List>> getPresentOutYear(
    int id,
    int year,
  ) async {
    try {
      final result = await homeDataSource.getPresentOutYear(id, year);
      return Right(result);
    } on SocketException catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } on TimeoutException catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } on RPCError catch (e) {
      return Left(
        HomeFailure(message: e.message),
      );
    } catch (e) {
      return Left(
        HomeFailure(message: "Unexpected Error: $e"),
      );
    }
  }
}
