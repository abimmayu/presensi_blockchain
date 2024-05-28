import 'package:presensi_blockchain/core/service/blockchain_service.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';

abstract class HomeDataSource {
  Future<List> getPresentInMonth(
    int id,
    int month,
    int year,
  );
  Future<List> getPresentOutMonth(
    int id,
    int month,
    int year,
  );
  Future<List> getPresentInYear(
    int id,
    int year,
  );
  Future<List> getPresentOutYear(
    int id,
    int year,
  );
}

class HomeDataSourceImpl implements HomeDataSource {
  BlockchainService blockchainService = BlockchainService();

  @override
  Future<List> getPresentInMonth(
    int id,
    int month,
    int year,
  ) async {
    final result = blockchainService.callViewFunction(
      name: AppConstant.getEmployeePresentInMonth,
      param: [
        id,
        month,
        year,
      ],
    );

    return result;
  }

  @override
  Future<List> getPresentOutMonth(
    int id,
    int month,
    int year,
  ) async {
    final result = blockchainService.callViewFunction(
      name: AppConstant.getEmployeePresentOutMonth,
      param: [
        id,
        month,
        year,
      ],
    );

    return result;
  }

  @override
  Future<List> getPresentInYear(
    int id,
    int year,
  ) async {
    final result = blockchainService.callViewFunction(
      name: AppConstant.getEmployeePresentInYear,
      param: [
        id,
        year,
      ],
    );

    return result;
  }

  @override
  Future<List> getPresentOutYear(
    int id,
    int year,
  ) async {
    final result = blockchainService.callViewFunction(
      name: AppConstant.getEmployeePresentOutYear,
      param: [
        id,
        year,
      ],
    );

    return result;
  }
}
