import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'product_contract_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tedarik_final/services/product_contract_service.dart';

class IPFSService {
  static final String _gatewayUrl = 'https://gateway.pinata.cloud/ipfs';

  static Future<Map<String, dynamic>?> getProductById(String productId) async {
  try {
    final result = await ProductContractService.getProduct(productId);
    print(">> getProduct result = $result");
    print(">> result.runtimeType = ${result.runtimeType}");


    if (result == null || result.isEmpty) {
      print("Zincirden veri alınamadı.");
      return null;
    }

    final cid = result['ipfsHash'] as String?;
    print("DEBUG: CID from contract for $productId = '$cid'");


    if (cid == null || cid.isEmpty) {
      print("CID boş veya null.");
      return null;
    }


    final rawCid = cid.replaceFirst("ipfs://", "").trim();

    final gateways = [
      'https://gateway.pinata.cloud/ipfs',
      'https://w3s.link/ipfs',
      'https://ipfs.io/ipfs'
    ];

    for (final gateway in gateways) {
      final url = '$gateway/$rawCid';
      print("Deniyor: $url");
      final response = await http.get(Uri.parse(url));
      print("Gateway $gateway status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));

        Map<String, dynamic> flatten(Map data) {
          while (data.containsKey('data') && data['data'] is Map) {
            data = Map<String, dynamic>.from(data['data']);
          }
          return Map<String, dynamic>.from(data);
        }

        final cleanData = flatten(decoded);
        return {'cid': rawCid, 'data': cleanData};
      }
    }
  } catch (e) {
    print("getProductById error: $e");
  }
  return null;
}

  static Future<String?> uploadJSON(Map<String, dynamic> data) async {
  try {
    final apiKey = dotenv.env['PINATA_API_KEY'] ?? '';
    final apiSecret = dotenv.env['PINATA_API_SECRET'] ?? '';

    // ✅ Eğer "owner" alanı eksikse aktif cüzdan adresiyle doldur
    if (!data.containsKey("owner") || data["owner"] == "0x...") {
      final address = await ProductContractService.getActiveWalletAddress();
      data["owner"] = address;
    }

    final url = Uri.parse('https://api.pinata.cloud/pinning/pinJSONToIPFS');

    final encodedBody = jsonEncode({
      'pinataMetadata': {'name': 'product_metadata'},
      'pinataContent': data,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'pinata_api_key': apiKey,
        'pinata_secret_api_key': apiSecret,
      },
      body: utf8.encode(encodedBody),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(utf8.decode(response.bodyBytes));
      return res['IpfsHash'];
    } else {
      print("❌ Pinata yükleme hatası: ${response.statusCode}, ${response.body}");
    }
  } catch (e) {
    print("❌ uploadJSON error: $e");
  }
  return null;
}

  static Future<bool> updateProductOnChain(String productId, String newCid, String status) async {
    try {
      final cidOnChain = await ProductContractService.getProduct(productId);

      if (cidOnChain == null || cidOnChain.isEmpty) {
        // Ürün daha önce eklenmemiş → createProduct çağır
        return await ProductContractService.addProduct(productId, newCid, status);
      } else {
        // Ürün var → updateProduct çağır
        return await ProductContractService.updateProduct(productId, newCid, status);
      }
    } catch (e) {
      print("updateProductOnChain error: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchIPFSContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          return {'type': 'json', 'data': jsonDecode(utf8.decode(response.bodyBytes))};
        }
      }
    } catch (e) {
      print("❌ IPFS Hatası: $e");
    }
    return null;
  }


  static Future<List<Map<String, dynamic>>> getProductsForCurrentUser() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return [];

  final allIds = await ProductContractService.getAllProductIds(); // zincirden tüm ürün ID'leri
  final userProducts = <Map<String, dynamic>>[];

  for (final id in allIds) {
    final product = await getProductById(id);
    if (product != null && product['data']['userUid'] == currentUser.uid) {
      userProducts.add(product['data']);
    }
  }

  return userProducts;
}

static Future<Map<String, dynamic>> getUserAnalytics() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return {"total": 0, "cityCounts": {}};

  final userProducts = await getProductsForCurrentUser();
  final Map<String, int> cityCounts = {};

  for (final product in userProducts) {
    final city = (product['location'] ?? '').toString().trim();
    if (city.isNotEmpty) {
      cityCounts[city] = (cityCounts[city] ?? 0) + 1;
    }
  }

  return {
    "total": userProducts.length,
    "cityCounts": cityCounts,
  };
}


}
