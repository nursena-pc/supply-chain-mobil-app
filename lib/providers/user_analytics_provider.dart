import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tedarik_final/services/analytics_service.dart';

class UserAnalyticsProvider with ChangeNotifier {
  bool isLoading = true;
  int totalProducts = 0;
  Map<String, int> cityDistribution = {};

  Future<void> loadUserAnalytics() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final data = await AnalyticsService.getUserAnalytics(user.uid);
      totalProducts = data['total'];
      cityDistribution = Map<String, int>.from(data['byCity']);
    } catch (e) {
      print("❌ loadUserAnalytics hatası: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
