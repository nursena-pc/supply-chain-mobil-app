import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tedarik_final/services/ipfs_service.dart';

class ProductContractService {
  static Web3Client? _client;
  static DeployedContract? _contract;
  static Credentials? _credentials;
  static bool _initialized = false;

  // Fonksiyonlar
  static ContractFunction? _createProduct;
  static ContractFunction? _getProduct;
  static ContractFunction? _updateProduct;
  static ContractFunction? _getAllProductIds;

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

    final address = await _credentials!.extractAddress();
    print("🎯 Aktif Private Key'e ait cüzdan adresi: $address");

    final abiString = await rootBundle.loadString("assets/abi/ProductTracking.json");

    _contract = DeployedContract(
      ContractAbi.fromJson(abiString, "ProductTracking"),
      EthereumAddress.fromHex(contractAddress),
    );

    _createProduct = _contract!.function("createProduct");
    _getProduct = _contract!.function("getProduct");
    _updateProduct = _contract!.function("updateProduct");
    _getAllProductIds = _contract!.function("getAllProductIds");

    _initialized = true;
  }

  /// Aktif wallet adresini al
  static Future<String> getActiveWalletAddress() async {
    await init();
    final address = await _credentials!.extractAddress();
    return address.hex;
  }

  /// Yeni ürün ekle (productId + IPFS CID)
  static Future<bool> addProduct(String productId, String cid, String status) async {
  try {
    await init();
    final tx = await _client!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _createProduct!, // artık 3 parametreli
        parameters: [productId, cid, status],
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


  /// Tek ürün getir
  static Future<Map<String, dynamic>?> getProduct(String productId) async {
    try {
      await init();
      final result = await _client!.call(
        contract: _contract!,
        function: _getProduct!,
        params: [productId],
      );

      final ipfsHash = result[0] as String;
      final owner = result[1] as EthereumAddress;
      final status = result[2] as String;

      // Eğer owner adresi sıfırsa, ürün yok demektir
      if (owner.hex == "0x0000000000000000000000000000000000000000") {
        print("🚫 Ürün zincirde kayıtlı değil.");
        return null;
      }

      return {
        'ipfsHash': ipfsHash,
        'owner': owner.hex,
        'status': status,
      };
    } catch (e) {
      print("❌ getProduct hatası: $e");
      return null;
    }
  }

  /// Ürün doğrula (CID boş değilse true)
  static Future<bool> verifyProductId(String productId) async {
    final product = await getProduct(productId);
    return product != null;
  }

  static void reset() {
    _initialized = false;
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

  /// Tüm ürün ID'lerini getir
  static Future<List<String>> getAllProductIds() async {
    try {
      await init();
      final result = await _client!.call(
        contract: _contract!,
        function: _getAllProductIds!,
        params: [],
      );
      return List<String>.from(result.first as List);
    } catch (e) {
      print("❌ getAllProductIds hatası: $e");
      return [];
    }
  }

  /// Kullanıcıya ait ürünleri getir (IPFS verileriyle)
  static Future<List<Map<String, dynamic>>> getProductsByUser(String userAddress) async {
    final lowercaseAddress = userAddress.toLowerCase();
    final List<Map<String, dynamic>> userProducts = [];

    try {
      await init();
      final ids = await getAllProductIds();

      for (final id in ids) {
        final result = await _client!.call(
          contract: _contract!,
          function: _getProduct!,
          params: [id],
        );

        final cid = result[0] as String;
        final owner = (result[1] as EthereumAddress).hex.toLowerCase();

        if (owner == lowercaseAddress && cid.isNotEmpty) {
          final url = "https://gateway.pinata.cloud/ipfs/${cid.replaceFirst("ipfs://", "").trim()}";
          final ipfsData = await IPFSService.fetchIPFSContent(url);

          if (ipfsData != null && ipfsData['data'] != null) {
            userProducts.add(ipfsData['data']);
          }
        }
      }
    } catch (e) {
      print("❌ getProductsByUser hatası: $e");
    }

    return userProducts;
  }
}
