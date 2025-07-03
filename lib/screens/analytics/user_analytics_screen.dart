import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tedarik_final/services/ipfs_service.dart';

class UserAnalyticsScreen extends StatefulWidget {
  const UserAnalyticsScreen({super.key});

  @override
  State<UserAnalyticsScreen> createState() => _UserAnalyticsScreenState();
}

class _UserAnalyticsScreenState extends State<UserAnalyticsScreen> {
  bool _loading = true;
  int _total = 0;
  Map<String, int> _byCity = {};

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final analytics = await IPFSService.getUserAnalytics();
    setState(() {
      _total = analytics['total'] ?? 0;
      _byCity = Map<String, int>.from(analytics['byCity'] ?? {});
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityLabels = _byCity.keys.toList();
    final values = _byCity.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Analiz")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Toplam Ürün: $_total",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= 0 && index < cityLabels.length) {
                                  return Text(
                                    cityLabels[index],
                                    style: const TextStyle(fontSize: 10),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize: 30,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(cityLabels.length, (i) {
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: values[i].toDouble(),
                                color: Colors.green,
                                width: 16,
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
