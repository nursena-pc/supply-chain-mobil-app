import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tedarik_final/models/city_data.dart';

class BarChartCityDistribution extends StatelessWidget {
  final List<CityData> data;

  const BarChartCityDistribution({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final topData = data.take(4).toList();
    final maxY = (topData.map((e) => e.count).fold<int>(0, (a, b) => a > b ? a : b)) + 1;

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          maxY: maxY.toDouble(),
          barGroups: _buildBarGroups(topData),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < topData.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8,
                      child: Text(
                        topData[index].city,
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1, // her sayı tam sayı olarak gösterilir
                getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true, horizontalInterval: 1),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<CityData> topData) {
    final maxCount = topData.map((e) => e.count).fold<int>(0, (a, b) => a > b ? a : b);

    return topData.asMap().entries.map((entry) {
      final index = entry.key;
      final city = entry.value;

      final y = city.count.toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: y,
            width: 20,
            borderRadius: BorderRadius.circular(4),
            color: Colors.green.shade600,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: (maxCount + 1).toDouble(),
              color: Colors.green.shade100,
            ),
          ),
        ],
      );
    }).toList();
  }
}
