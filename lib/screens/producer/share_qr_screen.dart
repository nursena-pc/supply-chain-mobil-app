import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareQRScreen extends StatelessWidget {
  final String cid;

  const ShareQRScreen({super.key, required this.cid});

  Future<File> _captureQR(GlobalKey globalKey) async {
    await Future.delayed(const Duration(milliseconds: 100));
    await WidgetsBinding.instance.endOfFrame;

    final boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png');
    return await file.writeAsBytes(buffer);
  }

  @override
  Widget build(BuildContext context) {
    final qrKey = GlobalKey();
    final cidUrl = "https://ipfs.io/ipfs/$cid";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("QR Kod ve CID"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Ürün QR Kodu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // QR görüntüsü
                RepaintBoundary(
                  key: qrKey,
                  child: QrImageView(
                    data: cidUrl,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Tıklanabilir CID linki
                GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse(cidUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(
                    "CID: $cid",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 📤 Paylaş butonu (sadece link olarak gönderir)
                ElevatedButton.icon(
                  onPressed: () async {
                    await Share.share(cidUrl);
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Paylaş"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
                const SizedBox(height: 12),

                // 💾 Galeriye kaydet
                ElevatedButton.icon(
                  onPressed: () async {
                    final file = await _captureQR(qrKey);
                    final result = await GallerySaver.saveImage(file.path);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result == true
                            ? "📁 QR görseli galeriye kaydedildi"
                            : "❌ Kaydetme başarısız"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_alt),
                  label: const Text("Galeriye Kaydet"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
                const SizedBox(height: 12),

                // 🔙 Vazgeç butonu
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: const BorderSide(color: Colors.grey),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text("Vazgeç"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
