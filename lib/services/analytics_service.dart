import 'package:tedarik_final/services/product_contract_service.dart';

class AnalyticsService {
  /// Kullanıcının cüzdan adresine göre IPFS ürünlerini çeker
  /// ve şehir bazlı grup + toplam sayıyı verir
  static Future<Map<String, dynamic>> getUserAnalytics(String userAddress) async {
    final products = await ProductContractService.getProductsByUser(userAddress);

    final Map<String, int> cityCounts = {};
    for (final product in products) {
      final city = product['location'] ?? 'Bilinmeyen';
      cityCounts[city] = (cityCounts[city] ?? 0) + 1;
    }

    return {
      'total': products.length,
      'byCity': cityCounts,
    };
  }
}
