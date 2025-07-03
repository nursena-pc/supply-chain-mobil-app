import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartBrandDistribution extends StatelessWidget {
  final Map<String, int> brandCounts;

  const PieChartBrandDistribution({super.key, required this.brandCounts});

  @override
  Widget build(BuildContext context) {
    final total = brandCounts.values.fold<int>(0, (a, b) => a + b);
    final colors = [
      Colors.green.shade400,
      Colors.green.shade300,
      Colors.green.shade200,
      Colors.green.shade100,
    ];

    final List<PieChartSectionData> sections = [];
    int index = 0;

    brandCounts.forEach((brand, count) {
      final percentage = (count / total) * 100;
      sections.add(
        PieChartSectionData(
          color: colors[index % colors.length],
          value: count.toDouble(),
          title: '${percentage.toStringAsFixed(0)}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
          ),
        ),
      );
      index++;
    });

    return Column(
  children: [
    const SizedBox(height: 20),
    const Text("Ürün Marka Dağılımı",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    const SizedBox(height: 10),
    SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 0,
          sectionsSpace: 4,
        ),
      ),
    ),
    const SizedBox(height: 16),
    Wrap(
      spacing: 20,
      runSpacing: 10,
      children: brandCounts.keys.mapIndexed((i, brand) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: colors[i % colors.length],
            ),
            const SizedBox(width: 6),
            Text(brand, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    )
  ],
);

  }
}

extension MapIndexed<K, V> on Iterable<K> {
  Iterable<T> mapIndexed<T>(T Function(int index, K item) f) {
    int index = 0;
    return map((e) => f(index++, e));
  }
}
