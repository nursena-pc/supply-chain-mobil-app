import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tedarik_final/models/city_data.dart';

class BarChartTestScreen extends StatelessWidget {
  const BarChartTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      CityData(city: 'İstanbul', count: 5, statuses: ['Depoda', 'Teslim Edildi', 'Kargoda']),
      CityData(city: 'Ankara', count: 3, statuses: ['Teslim Edildi', 'İade']),
      CityData(city: 'İzmir', count: 2, statuses: ['Depoda']),
      CityData(city: 'Van', count: 1, statuses: ['Teslim Edildi']),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Test Bar Chart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              '📊 Örnek Grafik',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.4,
                child: BarChart(
                  BarChartData(
                    barGroups: data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final cityData = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: cityData.count.toDouble(),
                            color: Colors.green.shade600,
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < data.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 6,
                                child: Text(
                                  data[index].city,
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
                        sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              '📋 Durumlar (Statuses)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final cityData = data[index];
                  final statusText = cityData.statuses.join(', ');
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(cityData.city),
                    subtitle: Text(statusText),
                    trailing: Text('${cityData.count} ürün'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
