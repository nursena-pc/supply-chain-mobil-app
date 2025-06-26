import 'package:flutter/material.dart';

Future<String?> showProductVerificationDialog(BuildContext context) async {
  String productId = '';
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ürün Doğrulama'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'Product ID giriniz'),
          onChanged: (value) => productId = value,
        ),
        actions: [
          TextButton(
            child: const Text('İptal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Doğrula'),
            onPressed: () => Navigator.pop(context, productId),
          ),
        ],
      );
    },
  );
}
