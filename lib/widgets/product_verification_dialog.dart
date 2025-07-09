import 'package:flutter/material.dart';

Future<String?> showProductVerificationDialog(BuildContext context) async {
  String productId = '';
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFD1F5D3), // Açık yeşil arka plan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Ürün Doğrulama'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'Product ID giriniz'),
          onChanged: (value) => productId = value,
        ),
        actions: [
          TextButton(
            child: const Text(
              'İptal',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,         // ✅ Yeşil dolgu
              foregroundColor: Colors.black,         // ✅ Siyah yazı
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Doğrula',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pop(context, productId),
          ),
        ],
      );
    },
  );
}
