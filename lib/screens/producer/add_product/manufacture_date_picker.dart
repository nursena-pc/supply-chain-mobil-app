import 'package:flutter/material.dart';

class ManufactureDatePicker extends StatelessWidget {
  final TextEditingController controller;

  const ManufactureDatePicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          controller.text = pickedDate.toIso8601String().split('T').first;
        }
      },
      decoration: const InputDecoration(
        labelText: 'Üretim Tarihi',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
    );
  }
}
