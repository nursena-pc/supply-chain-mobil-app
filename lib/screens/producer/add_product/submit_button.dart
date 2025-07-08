import 'package:flutter/material.dart';
import 'package:tedarik_final/services/ipfs_service.dart';
import 'package:tedarik_final/screens/producer/share_qr_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Firestore için eklendi

class SubmitButton extends StatelessWidget {
  final TextEditingController productIdController;
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController serialNumberController;
  final TextEditingController warrantyYearsController;
  final TextEditingController productionDateController;
  final TextEditingController locationController;
  final String status;

  const SubmitButton({
    super.key,
    required this.productIdController,
    required this.brandController,
    required this.modelController,
    required this.serialNumberController,
    required this.warrantyYearsController,
    required this.productionDateController,
    required this.locationController,
    required this.status,
  });

  Future<void> _handleSubmit(BuildContext context) async {
    final productId = productIdController.text.trim();
    final nowUtc = DateTime.now().toUtc().toIso8601String();
    final userUid = FirebaseAuth.instance.currentUser?.uid ?? "anon";

    final data = {
      "productId": productId,
      "owner": "0x...",
      "userUid": userUid,
      "status": status,
      "device": {
        "brand": brandController.text.trim(),
        "model": modelController.text.trim(),
        "serialNumber": serialNumberController.text.trim(),
        "manufactureDate": productionDateController.text.trim(),
        "warrantyYears": int.tryParse(warrantyYearsController.text.trim()) ?? 0,
      },
      "location": locationController.text.trim(),
      "timestamp": nowUtc,
      "timestamps": {
        status: nowUtc
      }
    };

    final cid = await IPFSService.uploadJSON(data);
    if (cid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("IPFS yükleme başarısız!")),
      );
      return;
    }

    final success = await IPFSService.updateProductOnChain(productId, cid, status);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Zincire yazma başarısız!")),
      );
      return;
    }

    // ✅ Firestore'a productHistory kaydı
    await FirebaseFirestore.instance.collection('productHistory').add({
      'userId': userUid,
      'productId': productId,
      'type': 'add',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // ✅ QR ekranına yönlendir
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ShareQRScreen(cid: cid)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleSubmit(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Text("Ürünü Kaydet", style: TextStyle(fontSize: 16)),
    );
  }
}
