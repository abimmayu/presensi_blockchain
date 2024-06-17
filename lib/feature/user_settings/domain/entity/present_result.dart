class PresentResult {
  final String blockNumber;
  final String timeStamp;
  final String hash;
  final String nonce;
  final String blockHash;
  final String transactionIndex;
  final String from;
  final String to;
  final String value;
  final String gas;
  final String gasPrice;
  final String isError;
  final String txreceiptStatus;
  final String input;
  final String contractAddress;
  final String cumulativeGasUsed;
  final String gasUsed;
  final String confirmations;
  final String methodId;
  final String functionName;

  PresentResult({
    required this.blockNumber,
    required this.timeStamp,
    required this.hash,
    required this.nonce,
    required this.blockHash,
    required this.transactionIndex,
    required this.from,
    required this.to,
    required this.value,
    required this.gas,
    required this.gasPrice,
    required this.isError,
    required this.txreceiptStatus,
    required this.input,
    required this.contractAddress,
    required this.cumulativeGasUsed,
    required this.gasUsed,
    required this.confirmations,
    required this.methodId,
    required this.functionName,
  });

  factory PresentResult.fromJson(Map<String, dynamic> json) {
    return PresentResult(
      blockNumber: json['blockNumber'],
      timeStamp: json['timeStamp'],
      hash: json['hash'],
      nonce: json['nonce'],
      blockHash: json['blockHash'],
      transactionIndex: json['transactionIndex'],
      from: json['from'],
      to: json['to'],
      value: json['value'],
      gas: json['gas'],
      gasPrice: json['gasPrice'],
      isError: json['isError'],
      txreceiptStatus: json['txreceipt_status'],
      input: json['input'],
      contractAddress: json['contractAddress'],
      cumulativeGasUsed: json['cumulativeGasUsed'],
      gasUsed: json['gasUsed'],
      confirmations: json['confirmations'],
      methodId: json['methodId'],
      functionName: json['functionName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blockNumber': blockNumber,
      'timeStamp': timeStamp,
      'hash': hash,
      'nonce': nonce,
      'blockHash': blockHash,
      'transactionIndex': transactionIndex,
      'from': from,
      'to': to,
      'value': value,
      'gas': gas,
      'gasPrice': gasPrice,
      'isError': isError,
      'txreceipt_status': txreceiptStatus,
      'input': input,
      'contractAddress': contractAddress,
      'cumulativeGasUsed': cumulativeGasUsed,
      'gasUsed': gasUsed,
      'confirmations': confirmations,
      'methodId': methodId,
      'functionName': functionName,
    };
  }
}
