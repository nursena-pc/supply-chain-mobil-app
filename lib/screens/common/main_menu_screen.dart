import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tedarik_final/services/ipfs_service.dart';
import 'package:tedarik_final/widgets/product_verification_dialog.dart';
import 'package:tedarik_final/screens/producer/update_product_screen.dart';
import 'package:tedarik_final/screens/producer/add_product_screen.dart';
import 'package:tedarik_final/screens/analytics/analytics_screen.dart';
import 'package:tedarik_final/widgets/drawer/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> verifyProductIdAndNavigate(BuildContext context, String productId) async {
    final result = await IPFSService.getProductById(productId);
    if (result != null) {
      final productJson = Map<String, dynamic>.from(result);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UpdateProductScreen(ipfsContent: productJson, productId: productId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Ürün bulunamadı veya IPFS erişim hatası.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.green[800];
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.grey[850] : Colors.green[100];

    final List<Map<String, dynamic>> menuItems = [
      {
        'label': 'Ürün Ekle',
        'icon': Icons.add_box,
        'action': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
        },
      },
      {
        'label': 'Ürün Güncelle',
        'icon': Icons.edit,
        'action': () async {
          final productId = await showProductVerificationDialog(context);
          if (productId != null && productId.isNotEmpty) {
            await verifyProductIdAndNavigate(context, productId);
          }
        },
      },
      {
        'label': 'QR Tara',
        'icon': Icons.qr_code_scanner,
        'route': '/qrScanner',
      },
      {
        'label': 'Son İşlemler',
        'icon': Icons.history,
        'route': '/history',
      },
      {
        'label': 'Analiz',
        'icon': Icons.bar_chart,
        'action': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
          );
        },
      },
      {
        'label': 'Ayarlar',
        'icon': Icons.settings,
        'route': '/settings',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Menü"),
        backgroundColor: Colors.green,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () async {
                if (item.containsKey('action')) {
                  await item['action']();
                } else if (item['route'] != null) {
                  Navigator.pushNamed(context, item['route']);
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: cardColor,
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], size: 48, color: iconColor),
                    const SizedBox(height: 10),
                    Text(
                      item['label'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
