import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductContractService {
  static Web3Client? _client;
  static DeployedContract? _contract;
  static Credentials? _credentials;
  static bool _initialized = false;

  // Fonksiyonlar
  static ContractFunction? _createProduct;
  static ContractFunction? _getProduct;
  static ContractFunction? _updateProduct;

  /// Init (tek seferlik çalışır)
  static Future<void> init() async {
    if (_initialized) return;

    final rpcUrl = dotenv.env['MEGAETH_RPC'] ?? '';
    final contractAddress = dotenv.env['CONTRACT_ADDRESS'] ?? '';
    final privateKey = dotenv.env['PRIVATE_KEY'] ?? '';

    if (rpcUrl.isEmpty || contractAddress.isEmpty || privateKey.isEmpty) {
      throw Exception("❌ .env dosyasındaki RPC/CONTRACT/PRIVATE_KEY eksik.");
    }

    _client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);

    final abiString = await rootBundle.loadString("assets/abi/ProductTracking.json");
    final abiJson = jsonDecode(abiString);

    _contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(abiJson['abi']), "ProductTracking"),
      EthereumAddress.fromHex(contractAddress),
    );

    _createProduct = _contract!.function("createProduct");
    _getProduct = _contract!.function("getProduct");
    _updateProduct = _contract!.function("updateProduct");

    _initialized = true;
  }

  /// Yeni ürün ekle (productId + IPFS CID)
  static Future<bool> addProduct(String productId, String cid) async {
    try {
      await init();
      final tx = await _client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
          contract: _contract!,
          function: _createProduct!,
          parameters: [productId, cid],
          maxGas: 300000,
        ),
        chainId: 6342,
      );
      print("✅ Ürün eklendi TX: $tx");
      return true;
    } catch (e) {
      print("❌ addProduct hatası: $e");
      return false;
    }
  }

  /// CID getir (productId ile)
  static Future<String?> getProduct(String productId) async {
    try {
      await init();
      final result = await _client!.call(
        contract: _contract!,
        function: _getProduct!,
        params: [productId],
      );
      return result.first as String;
    } catch (e) {
      print("❌ getProduct hatası: $e");
      return null;
    }
  }

  /// Ürün doğrula (CID boş değilse true)
  static Future<bool> verifyProductId(String productId) async {
    final cid = await getProduct(productId);
    return cid != null && cid.isNotEmpty;
  }

  /// Ürünü güncelle (yeni CID ve durum bilgisiyle)
  static Future<bool> updateProduct(String productId, String newCid, String status) async {
    try {
      await init();
      final tx = await _client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
          contract: _contract!,
          function: _updateProduct!,
          parameters: [productId, newCid, status],
          maxGas: 300000,
        ),
        chainId: 6342,
      );
      print("✅ Update gönderildi TX: $tx");
      return true;
    } catch (e) {
      print("❌ updateProduct hatası: $e");
      return false;
    }
  }
}
