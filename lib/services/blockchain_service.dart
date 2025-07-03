import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class BlockchainService {
  final String rpcUrl = "https://carrot.megaeth.com/rpc";
  final String privateKey = "0xfeeb9498264a29e2a068e44715c15353dbb833ec138aa039aa8859ed5696e707";
  final String contractAddress = "0x516aa896560e95A998e0097F1aD450fb581EB174";

  late Web3Client _client;
  late EthPrivateKey _credentials;
  late DeployedContract _contract;

  BlockchainService() {
    _client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<void> init() async {
    String abi = await rootBundle.loadString("assets/abi/ProductTracking.json");
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "ProductTracking"),
      EthereumAddress.fromHex(contractAddress),
    );
    _contract = contract;
  }

  Future<String?> updateProduct(String productId, String newIpfsHash, String status) async {
    final function = _contract.function("updateProduct");

    try {
      final tx = await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: function,
          parameters: [productId, newIpfsHash, status],
        ),
        chainId: 6342, // MegaEth chain ID
      );
      return tx;
    } catch (e) {
      print("🚨 updateProduct hatası: $e");
      return null;
    }
  }
}
