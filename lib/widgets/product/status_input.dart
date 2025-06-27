import 'package:flutter/material.dart';

class StatusInput extends StatelessWidget {
  final String status;
  final ValueChanged<String?> onChanged;

  const StatusInput({
    super.key,
    required this.status,
    required this.onChanged,
  });

  static const List<String> durumlar = [
    'Üretildi',
    'Depoda',
    'Dağıtımda',
    'Teslim Edildi',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: status.isNotEmpty ? status : null,
      decoration: const InputDecoration(
        labelText: 'Durum',
        border: OutlineInputBorder(),
      ),
      items: durumlar.map((durum) => DropdownMenuItem(
        value: durum,
        child: Text(durum),
      )).toList(),
      onChanged: onChanged,
    );
  }
}