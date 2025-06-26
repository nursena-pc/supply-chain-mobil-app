import 'package:flutter/material.dart';

Future<String?> showProductVerificationDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Ürün Doğrulama"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: "Ürün ID (ör: PHONE-001)",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("İptal"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: const Text("Doğrula"),
        ),
      ],
    ),
  );
}
