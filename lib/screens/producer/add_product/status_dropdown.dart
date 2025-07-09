import 'package:flutter/material.dart';

class StatusDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const StatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<String> statusList = [
    'Üretildi',
    'Depoda',
    'Dağıtımda',
    'Teslim Edildi'
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFFD1F5D3), // ✅ Menü arka planı
      decoration: const InputDecoration(
        labelText: 'Durum',
        border: OutlineInputBorder(),
      ),
      items: statusList.map((durum) {
        return DropdownMenuItem(
          value: durum,
          child: Text(durum),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
