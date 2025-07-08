import 'package:flutter/material.dart';
import 'package:tedarik_final/services/ipfs_service.dart';
import 'package:tedarik_final/screens/product/product_detail_screen.dart';

class ProductDetailScreenFromId extends StatelessWidget {
  final String productId;

  const ProductDetailScreenFromId({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return FutureBuilder(
      future: IPFSService.getProductById(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Detay")),
            body: Center(
              child: Text(
                "❌ Ürün bulunamadı",
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
          );
        }

        final productData = Map<String, dynamic>.from(snapshot.data as Map);

        return ProductDetailScreen(productData: productData);
      },
    );
  }
}
