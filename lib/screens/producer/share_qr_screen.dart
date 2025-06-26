import 'dart:io';
import 'dart:ui' as ui; // <-- for ImageByteFormat
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // <-- for RenderRepaintBoundary
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


class ShareQRScreen extends StatelessWidget {
  final String cid;

  const ShareQRScreen({super.key, required this.cid});

  Future<File> _captureQR(GlobalKey globalKey) async {
  final boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/qr.png').writeAsBytes(buffer);
  return file;
}



  @override
  Widget build(BuildContext context) {
    final qrKey = GlobalKey();

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
                RepaintBoundary(
                  key: qrKey,
                  child: QrImageView(
                    data: "https://ipfs.io/ipfs/$cid",
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
                const SizedBox(height: 16),
                Text("CID: $cid", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final file = await _captureQR(qrKey);
                    await Share.shareXFiles([XFile(file.path)], text: 'IPFS CID: $cid');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text("📤 Paylaş"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final file = await _captureQR(qrKey);
                    await GallerySaver.saveImage(file.path);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("📁 Galeriye kaydedildi")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text("💾 Galeriye Kaydet"),
                ),
                const SizedBox(height: 12),
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
