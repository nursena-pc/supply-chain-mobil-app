import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tedarik_final/services/ipfs_service.dart';
import 'package:tedarik_final/widgets/product_verification_dialog.dart';
import 'package:tedarik_final/screens/producer/update_product_screen.dart';
import 'package:tedarik_final/screens/producer/add_product_screen.dart';
import 'package:tedarik_final/screens/analytics/user_analytics_screen.dart';
import 'package:tedarik_final/screens/analytics/analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String email = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        email = user.email ?? '';
        role = doc.data()?['role'] ?? 'Bilinmiyor';
      });
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  Future<void> verifyProductIdAndNavigate(String productId) async {
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
            await verifyProductIdAndNavigate(productId);
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(role.toUpperCase()),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.green),
              ),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Çıkış Yap"),
              onTap: _signOut,
            ),
            ListTile(
              leading: const Icon(Icons.switch_account),
              title: const Text("Hesap Değiştir"),
              onTap: _signOut,
            ),
            const Divider(),
            const ListTile(
              title: Text("© 2025 Tedarik Mobil"),
              subtitle: Text("v1.0.0"),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/test-get'),
              child: const Text("🧪 GetProduct Test"),
            ),
            const SizedBox(height: 16),
            Expanded(
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
                      color: Colors.green[100],
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], size: 48, color: Colors.green[800]),
                          const SizedBox(height: 10),
                          Text(
                            item['label'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
