import 'package:presensi_blockchain/core/service/blockchain_service.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';

abstract class PresentDataPost {
  Future<String> postPresent({
    required BigInt idPresent,
    required BigInt idEmployee,
  });
  Future<String> sendBalance();
}

class PresentDataPostImpl implements PresentDataPost {
  final BlockchainService blockchainService = BlockchainService();

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
