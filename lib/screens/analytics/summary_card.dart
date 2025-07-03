import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int total;

  const SummaryCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.inventory, size: 30),
            SizedBox(width: 16),
            Text(
              'Toplam Ürün Sayısı: $total',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
