import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerUserInfo extends StatefulWidget {
  const DrawerUserInfo({super.key});

  @override
  State<DrawerUserInfo> createState() => _DrawerUserInfoState();
}

class _DrawerUserInfoState extends State<DrawerUserInfo> {
  String name = '';
  String email = '';
  int totalProducts = 0;
  int totalUpdates = 0;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final userData = doc.data() ?? {};

    final historySnap = await FirebaseFirestore.instance
        .collection('productHistory')
        .where('userId', isEqualTo: user.uid)
        .get();

    int addCount = 0;
    int updateCount = 0;
    for (var h in historySnap.docs) {
      final type = h.data()['type'];
      if (type == 'add') addCount++;
      if (type == 'update') updateCount++;
    }

    setState(() {
      name = userData['name'] ?? 'Kullanıcı';
      email = user.email ?? '';
      totalProducts = addCount;
      totalUpdates = updateCount;
    });
  }

  String getLevelLabel() {
    if (totalProducts >= 50) return 'Üretici III';
    if (totalProducts >= 20) return 'Üretici II';
    return 'Üretici I';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            name.toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
          accountEmail: Text(
            email,
            style: const TextStyle(color: Colors.white70),
          ),
          currentAccountPicture: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                backgroundColor: isDark ? Colors.grey[300] : Colors.white,
                child: Icon(Icons.person, color: isDark ? Colors.green[800] : Colors.green),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.star, size: 14, color: Colors.white),
              )
            ],
          ),
          decoration: BoxDecoration(color: Colors.green.shade700),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.military_tech, size: 18, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text(
                    getLevelLabel(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 18, color: Colors.brown),
                  const SizedBox(width: 4),
                  Text("$totalProducts"),
                  const SizedBox(width: 12),
                  const Icon(Icons.track_changes_outlined, size: 18, color: Colors.deepPurple),
                  const SizedBox(width: 4),
                  Text("$totalUpdates"),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
