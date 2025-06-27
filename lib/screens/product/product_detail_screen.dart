import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 kopyalama için gerekli
import 'package:tedarik_final/screens/common/qr_scanner_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    final fullData = productData;
    final device = fullData['device'] ?? {};
    final status = fullData['status'] ?? '';
    final timestamp = fullData['timestamp']?.toString() ?? '';
    final timestamps = fullData['timestamps'] ?? {};
    final cid = productData['cid'] ?? ''; // 👈 CID varsa göster

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürün Takip Detayı"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildStepper(status, timestamps),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoTile("👤 Sahip", fullData['owner']),
                      _infoTile("📦 Durum", status),
                      const Divider(),
                      const Text("🛠️ Cihaz Bilgileri", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _infoTile("Marka", device['brand']),
                      _infoTile("Model", device['model']),
                      _infoTile("Seri No", device['serialNumber']),
                      _infoTile("Üretim Tarihi", device['manufactureDate']),
                      _infoTile("Garanti (yıl)", device['warrantyYears']?.toString()),
                      const Divider(),
                      _infoTile("📍 Konum", fullData['location']),
                      _infoTile("⏱️ Zaman", timestamp),

                      // ✅ CID gösterme ve kopyalama butonu
                      if (cid.toString().isNotEmpty) ...[
                        const Divider(),
                        const Text("📄 CID", style: TextStyle(fontWeight: FontWeight.w500)),
                        Row(
                          children: [
                            Expanded(child: Text(cid, style: const TextStyle(fontSize: 12))),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: cid.toString()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("CID panoya kopyalandı ✅")),
                                );
                              },
                            )
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const QRScannerScreen()),
                  );
                },
                icon: const Icon(Icons.qr_code),
                label: const Text("QR'ı Tekrar Tara"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 78, 163, 81),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text("Ana Menüye Dön"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),


    );
  }

  Widget _buildStepper(String status, Map<String, dynamic> timestamps) {
    final steps = [
      {'label': 'Üretildi', 'icon': Icons.factory},
      {'label': 'Depoda', 'icon': Icons.warehouse},
      {'label': 'Dağıtımda', 'icon': Icons.local_shipping},
      {'label': 'Teslim Edildi', 'icon': Icons.home},
    ];

    final currentIndex = steps.indexWhere((step) => step['label'] == status);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: steps.map((step) {
        final index = steps.indexOf(step);
        final isCompleted = index <= currentIndex;

        return Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isCompleted ? Colors.green : Colors.grey[300],
                child: Icon(
                  step['icon'] as IconData,
                  color: isCompleted ? Colors.white : Colors.black26,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                step['label'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: isCompleted ? Colors.green[800] : Colors.grey),
              ),
              Text(
                timestamps[step['label']]?.toString() ?? '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _infoTile(String label, dynamic value) {
    final displayValue = (value == null || value.toString().trim().isEmpty || value.toString() == 'null')
        ? "Belirtilmemiş"
        : value.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(flex: 5, child: Text(displayValue)),
        ],
      ),
    );
  }
}