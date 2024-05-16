import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
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
      "assets/contract/Mapping.json",
    );

    String contractAddress = "0x31f92b4e4BeC6077B397B6A0b9e6004CeE997f9f";

    final contract = DeployedContract(
      ContractAbi.fromJson(
        abiFile,
        "Mapping",
      ),
      EthereumAddress.fromHex(
        contractAddress,
      ),
    );

    return contract;
  }

  Future<List> callViewFunction({
    required String name,
    Map<String, dynamic>? param,
  }) async {
    final contract = await getContract();
    final function = contract.function(name);
    final result = await web3Client.call(
      contract: contract,
      function: function,
      params: [],
    );

    return result;
  }

  Future<String> addPresentIn({
    required String functionName,
    String? day,
    String? nip,
    String? fullName,
    String? locations,
    required String privateKey,
  }) async {
    List param = [];
    if (functionName == 'addPresentIn') {
      param = [day];
    } else if (functionName == 'inputPresent') {
      param = [
        nip,
        fullName,
        locations,
      ];
    }

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
