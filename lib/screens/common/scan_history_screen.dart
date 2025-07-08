import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tedarik_final/screens/product/product_detail_screen.dart';
import 'package:tedarik_final/services/ipfs_service.dart';
import 'package:tedarik_final/services/scan_history_service.dart';
import 'package:tedarik_final/models/scan_history_item.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  String _selectedFilter = '1 Ay';
  final List<String> _filters = ['1 Ay', '3 Ay', '6 Ay'];

  Duration? get filterDuration {
    switch (_selectedFilter) {
      case '3 Ay':
        return const Duration(days: 90);
      case '6 Ay':
        return const Duration(days: 180);
      case '1 Ay':
        return const Duration(days: 30);
      case 'Tümü':
      default:
        return null;
    }
  }

  Future<void> _openProductDetail(String cid, BuildContext context) async {
    try {
      final content = await IPFSService.fetchIPFSContent(cid);

      if (content != null && content['type'] == 'json') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productData: content['data']),
          ),
        );
      } else {
        _showMessage(context, "📄 İçerik geçerli değil.");
      }
    } catch (e) {
      _showMessage(context, "❌ Detay yüklenemedi: $e");
    }
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Son Taramalarım"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Filtre: "),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: _filters.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedFilter = value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ScanHistoryItem>>(
              future: ScanHistoryService().getHistory(filterDuration: filterDuration),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("🔍 Bu filtreye ait tarama bulunamadı."));
                }

                final items = snapshot.data!;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final dateTime = item.scannedAt;

                    return ListTile(
                      leading: const Icon(Icons.qr_code),
                      title: Text(item.cid, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} - "
                        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}",
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _openProductDetail(item.cid, context),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
