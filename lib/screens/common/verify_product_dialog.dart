import 'package:flutter/material.dart';

Future<String?> showProductVerificationDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final textColor = isDark ? Colors.white : Colors.black;

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      title: Text(
        "Ürün Doğrulama",
        style: TextStyle(color: textColor),
      ),
      content: TextField(
        controller: controller,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: "Ürün ID (ör: PHONE-001)",
          labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isDark ? Colors.grey : Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isDark ? Colors.greenAccent : Colors.green),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("İptal", style: TextStyle(color: isDark ? Colors.grey[300] : Colors.black)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text("Doğrula"),
        ),
      ],
    ),
  );
}
