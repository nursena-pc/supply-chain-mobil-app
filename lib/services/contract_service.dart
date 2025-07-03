import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class ContractService {
  late Web3Client _client;
  late DeployedContract _contract;

  final String rpcUrl = 'https://carrot.megaeth.com/rpc'; // 🥕 MegaEth Testnet
  final String privateKey = '0xfeeb9498264a29e2a068e44715c15353dbb833ec138aa039aa8859ed5696e707'; // Production’da güvenli saklanmalı!
  final String contractAddress = '0x516aa896560e95A998e0097F1aD450fb581EB174';

  late EthereumAddress _contractEthereumAddress;
  late Credentials _credentials;

  ContractService() {
    _client = Web3Client(rpcUrl, Client());
    _contractEthereumAddress = EthereumAddress.fromHex(contractAddress);
  }

  Future<void> init() async {
    // 1. ABI dosyasını oku
    String abiString = await rootBundle.loadString('assets/abis/ProductTracking.json');
    final abiJson = jsonDecode(abiString);

    // 2. Cüzdan bilgileri
    _credentials = EthPrivateKey.fromHex(privateKey);

    // 3. Akıllı kontrat nesnesi oluştur
    _contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(abiJson['abi']), 'ProductTracking'),
      _contractEthereumAddress,
    );
  }

  Future<void> addProduct(String productId, String cid) async {
    final function = _contract.function('addProduct');

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: function,
        parameters: [productId, cid],
      ),
      chainId: 6342, // MegaEth chain ID
    );
  }

  Future<List<dynamic>> getProduct(String productId) async {
    final function = _contract.function('getProduct');

    final result = await _client.call(
      contract: _contract,
      function: function,
      params: [productId],
    );

    return result;
  }
}
