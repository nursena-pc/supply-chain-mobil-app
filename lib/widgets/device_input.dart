import 'package:flutter/material.dart';

class DeviceInput extends StatelessWidget {
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController serialNumberController;
  final TextEditingController manufactureDateController;
  final TextEditingController warrantyYearsController;

  const DeviceInput({
    super.key,
    required this.brandController,
    required this.modelController,
    required this.serialNumberController,
    required this.manufactureDateController,
    required this.warrantyYearsController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: brandController,
          decoration: const InputDecoration(
            labelText: 'Marka',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: modelController,
          decoration: const InputDecoration(
            labelText: 'Model',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: serialNumberController,
          decoration: const InputDecoration(
            labelText: 'Seri Numarası',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: manufactureDateController,
          readOnly: true,
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              manufactureDateController.text = pickedDate.toIso8601String().split('T').first;
            }
          },
          decoration: const InputDecoration(
            labelText: 'Üretim Tarihi',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: warrantyYearsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Garanti Süresi (yıl)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
