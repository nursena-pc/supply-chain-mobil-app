import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tedarik_final/services/ipfs_service.dart';
import 'package:tedarik_final/screens/product/product_detail_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isScanned = false;
  final MobileScannerController scannerController = MobileScannerController();

  /// IPFS bağlantısını normalize eder
  /// ipfs://Qm... → https://ipfs.io/ipfs/Qm...
  /// http linki ise olduğu gibi döner
  String? parseIpfsUrl(String raw) {
    if (raw.startsWith('ipfs://')) {
      final hash = raw.replaceFirst('ipfs://', '').trim();
      return 'https://ipfs.io/ipfs/$hash';
    } else if (raw.startsWith('http') && raw.contains('/ipfs/')) {
      return raw;
    }
    return null;
  }

  void _handleBarcode(Barcode barcode, MobileScannerArguments? args) async {
    if (isScanned) return;
    final scannedText = barcode.rawValue ?? '';
    if (scannedText.isEmpty) return;

    setState(() => isScanned = true);
    scannerController.stop();

    final parsedUrl = parseIpfsUrl(scannedText);
    if (parsedUrl == null) {
      _showMessage("⚠️ Geçerli bir IPFS bağlantısı değil.");
      return;
    }

    try {
      final content = await IPFSService.fetchIPFSContent(parsedUrl);

      if (content != null && content['type'] == 'json') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productData: content['data']),
          ),
        );
      } else {
        _showMessage("📄 QR IPFS bağlantısı içeriyor ama içerik geçersiz.");
      }
    } catch (e) {
      _showMessage("❌ QR işlenirken hata oluştu: $e");
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("QR Sonucu"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              scannerController.start();
              setState(() => isScanned = false);
            },
            child: const Text("Tamam"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📷 QR Kod Tara'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: scannerController,
              allowDuplicates: false,
              onDetect: _handleBarcode,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '📎 Lütfen QR kodu kameraya gösterin.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
