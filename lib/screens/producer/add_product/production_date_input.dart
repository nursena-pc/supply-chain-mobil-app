import 'package:flutter/material.dart';

class ProductionDateInput extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const ProductionDateInput({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = selectedDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7AC78A), // Başlık rengi, seçili tarih vs.
              onPrimary: Colors.white,     // Seçili tarih yazısı
              onSurface: Colors.black,     // Günlerin yazı rengi
            ),
            dialogBackgroundColor: Color(0xFFE9F7ED), // Takvim arka planı (açık yeşilimsi)
          ),
          child: child!,
        );
      },
    );

    if (picked != null) onDateSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = selectedDate != null
        ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
        : "Tarih seçin";

    return InkWell(
      onTap: () => _pickDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: "Üretim Tarihi",
          border: OutlineInputBorder(),
        ),
        child: Text(displayText),
      ),
    );
  }
}
