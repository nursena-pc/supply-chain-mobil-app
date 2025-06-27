import 'package:flutter/material.dart';

class BrandModelInput extends StatelessWidget {
  final TextEditingController brandController;
  final TextEditingController modelController;

  const BrandModelInput({
    super.key,
    required this.brandController,
    required this.modelController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: brandController,
          decoration: const InputDecoration(
            labelText: 'Marka Adı',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: modelController,
          decoration: const InputDecoration(
            labelText: 'Model Adı',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
