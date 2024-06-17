import 'dart:developer';

import 'package:presensi_blockchain/core/service/dio.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/feature/user_settings/data/models/all_present_models.dart';

abstract class AllPresentDataSource {
  Future<AllPresentModels> allPresentOnContract();
}

class AllPresentDataSourceImpl implements AllPresentDataSource {
  String contractAddress = AppConstant.contractAddress;
  String apiEtherscanKey = 'G79WJNYSCCFB8ZRAC98KJWF61T9Q3DB8UW';
  String baseEtherscanUrl = 'https://api-sepolia.etherscan.io/api?';

  @override
  Future<AllPresentModels> allPresentOnContract() async {
    final result = await getIt(
      '${baseEtherscanUrl}module=account&action=txlist&address=$contractAddress&startblock=0&endblock=99999999&sort=asc&apikey=$apiEtherscanKey',
    );
    return AllPresentModels.fromJson(result.data);
  }
}
