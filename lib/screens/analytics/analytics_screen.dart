import 'package:flutter/material.dart';
import 'package:tedarik_final/services/ipfs_service.dart';
import 'package:tedarik_final/models/city_data.dart';
import 'package:tedarik_final/screens/analytics/bar_chart_city_distribution.dart';
import 'package:tedarik_final/screens/analytics/pie_chart_brand_distribution.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _loading = true;
  int _total = 0;
  List<CityData> _cityData = [];
  Map<String, String> _cityStatusMap = {};
  Map<String, int> _brandCounts = {};

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final products = await IPFSService.getProductsForCurrentUser();

    final Map<String, List<String>> cityStatuses = {};
    final Map<String, int> cityCounts = {};
    final Map<String, int> brandCounts = {};

    for (final product in products) {
      final city = product['location'] ?? 'Bilinmiyor';
      final status = product['status'] ?? 'Durum Yok';
      final brand = product['device']?['brand'] ?? 'Markasız';

      cityCounts[city] = (cityCounts[city] ?? 0) + 1;

      cityStatuses.putIfAbsent(city, () => []);
      cityStatuses[city]!.add(status);

      brandCounts[brand] = (brandCounts[brand] ?? 0) + 1;
    }

      final List<CityData> cityDataList = cityCounts.entries.map((e) {
        final city = e.key;
        final count = e.value;
        final statuses = cityStatuses[city] ?? [];
        return CityData(city: city, count: count, statuses: statuses);
      }).toList();


    final Map<String, String> cityStatusSummary = {};
    cityStatuses.forEach((city, statuses) {
      final Map<String, int> counts = {};
      for (var s in statuses) {
        counts[s] = (counts[s] ?? 0) + 1;
      }
      final sorted = counts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      cityStatusSummary[city] = sorted.first.key;
    });

    setState(() {
      _total = products.length;
      _cityData = cityDataList;
      _cityStatusMap = cityStatusSummary;
      _brandCounts = brandCounts;
      _loading = false;
    });
  }

  String _buildStatusText(String city) {
    final status = _cityStatusMap[city] ?? 'Durum Bilinmiyor';
    final count = _cityData.firstWhere((e) => e.city == city).count;
    return "$count ürün $status".toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analiz")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Toplam Ürün: $_total",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  const Text("Şehir Bazlı Dağılım",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: BarChartCityDistribution(data: _cityData),
                  ),
                  const SizedBox(height: 20),
                  const Text("Detaylar",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._cityData.map((item) {
                    return ListTile(
                      leading: const Icon(Icons.location_city),
                      title: Text(item.city),
                      subtitle: Text(_buildStatusText(item.city)),
                      trailing: Text('${item.count} ürün'),
                    );
                  }).toList(),
                  if (_brandCounts.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text("Ürün Marka Dağılımı",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    PieChartBrandDistribution(brandCounts: _brandCounts),
                  ]
                ],
              ),
            ),
    );
  }
}
