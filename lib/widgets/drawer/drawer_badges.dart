import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerBadges extends StatelessWidget {
  const DrawerBadges({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    final historyStream = FirebaseFirestore.instance
        .collection('productHistory')
        .where('userId', isEqualTo: user.uid)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: historyStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final docs = snapshot.data!.docs;
        int adds = 0;
        int updates = 0;

        for (final doc in docs) {
          final type = doc['type'];
          if (type == 'add') adds++;
          if (type == 'update') updates++;
        }

        final List<Map<String, dynamic>> badges = [];

        if (adds >= 1) {
          badges.add({
            'icon': Icons.emoji_events,
            'title': '🎖️ İlk Ürün!',
            'desc': 'İlk ürününü ekledin!',
          });
        }

        if (updates >= 10) {
          badges.add({
            'icon': Icons.flash_on,
            'title': '🏆 Blockchain Kahramanı',
            'desc': '10 ürünü başarıyla güncelledin.',
          });
        }

        if (adds >= 50) {
          badges.add({
            'icon': Icons.rocket_launch,
            'title': '🚀 Üretim Ustası',
            'desc': '50 ürün ekleyerek uzmanlaştın.',
          });
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return ExpansionTile(
          leading: Icon(Icons.verified_user, color: isDark ? Colors.amber : Colors.green),
          title: const Text("🔰 Güven Rozetleri"),
          children: [
            if (badges.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("Henüz rozetin yok. Devam et! 💪"),
              ),
            ...badges.map((badge) {
              return ListTile(
                leading: Icon(badge['icon'], color: Colors.orange),
                title: Text(badge['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(badge['desc']),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
