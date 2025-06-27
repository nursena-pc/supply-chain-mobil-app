import 'package:flutter/material.dart';

class SerialWarrantyInput extends StatelessWidget {
  final TextEditingController serialController;
  final TextEditingController warrantyController;

  const SerialWarrantyInput({
    super.key,
    required this.serialController,
    required this.warrantyController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: serialController,
          decoration: const InputDecoration(
            labelText: 'Seri Numarası',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: warrantyController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Garanti Süresi (Yıl)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}