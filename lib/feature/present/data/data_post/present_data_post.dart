import 'dart:developer';

import 'package:presensi_blockchain/core/service/blockchain_service.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';

abstract class PresentDataPost {
  // Future<String> addPresentIn({
  //   required BigInt id,
  //   required BigInt day,
  //   required BigInt month,
  //   required BigInt year,
  //   String variety = "Masuk",
  // });
  // Future<String> addPresentOut({
  //   required BigInt id,
  //   required BigInt day,
  //   required BigInt month,
  //   required BigInt year,
  //   String variety = "Pulang",
  // });
  Future<String> postPresent({
    required BigInt idPresent,
    required BigInt idEmployee,
  });
  Future<String> sendBalance();
}

class PresentDataPostImpl implements PresentDataPost {
  final BlockchainService blockchainService = BlockchainService();

  //Make present in
  // @override
  // Future<String> addPresentIn({
  //   required BigInt id,
  //   required BigInt day,
  //   required BigInt month,
  //   required BigInt year,
  //   String variety = "Masuk",
  // }) async {
  //   final privateKey =
  //       await SecureStorage().readData(key: AppConstant.privateKey);
  //   log(
  //     privateKey.toString(),
  //   );
  //   final result = await blockchainService.postFunction(
  //     functionName: AppConstant.addPresent,
  //     param: [id, day, month, year, variety],
  //     privateKey: privateKey.toString(),
  //   );
  //   return result;
  // }

  //Make present out
  // @override
  // Future<String> addPresentOut({
  //   required BigInt id,
  //   required BigInt day,
  //   required BigInt month,
  //   required BigInt year,
  //   String variety = "Pulang",
  // }) async {
  //   final privateKey =
  //       await SecureStorage().readData(key: AppConstant.privateKey);
  //   final result = await blockchainService.postFunction(
  //     functionName: AppConstant.addPresent,
  //     param: [id, day, month, year, variety],
  //     privateKey: privateKey.toString(),
  //   );
  //   return result;
  // }

  //Input present data
  @override
  Future<String> postPresent({
    required BigInt idPresent,
    required BigInt idEmployee,
  }) async {
    final privateKey =
        await SecureStorage().readData(key: AppConstant.privateKey);
    final result = await blockchainService.postFunction(
      functionName: AppFunction.inputPresent,
      param: [idPresent, idEmployee],
      privateKey: privateKey.toString(),
    );
    return result;
  }

  @override
  Future<String> sendBalance() async {
    final result = await blockchainService.sendBalance();
    return result;
  }
}
