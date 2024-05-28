import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:web3dart/web3dart.dart';

class BlockchainService {
  late Client client;
  late Web3Client web3Client;

  final String address = "0xbe6990B887F86cB992cE58F475BE0F1DB165b59C";

  final contractUrl =
      "https://sepolia.infura.io/v3/a555c4f5ab0a4baf89bcc0e4963c0b3c";

  initiateEthClient() {
    client = Client();
    web3Client = Web3Client(
      contractUrl,
      client,
    );
  }

  Future<DeployedContract> getContract() async {
    initiateEthClient();
    String abiFile = await rootBundle.loadString(
      "assets/contract/Presensi.json",
    );

    String contractAddress = AppConstant.contractAddress;

    final contract = DeployedContract(
      ContractAbi.fromJson(
        abiFile,
        AppConstant.contractName,
      ),
      EthereumAddress.fromHex(
        contractAddress,
      ),
    );

    return contract;
  }

  Future<List<dynamic>> callViewFunction({
    required String name,
    List<dynamic>? param,
  }) async {
    param ??= [];
    final contract = await getContract();
    final function = contract.function(name);
    final result = await web3Client.call(
      contract: contract,
      function: function,
      params: param,
    );

    return result;
  }

  Future<String> postFunction({
    required String functionName,
    required List param,
    required String privateKey,
  }) async {
    final credential = EthPrivateKey.fromHex(privateKey);
    final contract = await getContract();
    final function = contract.function(functionName);

    log(
      param.toString(),
    );

    final transaction = Transaction.callContract(
      contract: contract,
      function: function,
      parameters: param,
    );

    final result = web3Client.sendTransaction(
      credential,
      transaction,
      chainId: 11155111,
    );

    return result;
  }
}
