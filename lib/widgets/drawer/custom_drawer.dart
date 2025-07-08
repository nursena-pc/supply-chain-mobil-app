import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tedarik_final/widgets/drawer/drawer_user_info.dart';
import 'package:tedarik_final/screens/common/settings/settings_screen.dart';
import 'package:tedarik_final/widgets/drawer/drawer_badges.dart';
import 'package:tedarik_final/widgets/drawer/drawer_theme_background.dart';
import 'package:tedarik_final/screens/common/settings/theme_toggle_tile.dart'; // 🌙 Tema butonu

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

 @override
Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final textColor = isDark ? Colors.white : Colors.black;
  final subTextColor = isDark ? Colors.grey[300] : Colors.grey[800];
  final bgColor = isDark ? Colors.grey[900] : Colors.white;
  final headerBgColor = isDark ? Colors.green.shade700 : Colors.green.shade700;
  final infoBgColor = isDark ? Colors.grey[900] : Colors.white;
  final levelTextColor = isDark ? Colors.white : Colors.black;

  return Stack(
    children: [
      const DrawerThemeBackground(), // 🌌 Yıldızlı/Karlı arka plan

      Drawer(
        backgroundColor: bgColor,
        child: Column(
          children: [
            // 🍃 Üst kısım: StatusBar (Yeşil) + DrawerUserInfo (Beyaz/Koyu)
            Container(
              color: headerBgColor,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Container(
                color: infoBgColor,
                child: Column(
                  children: [
                    const DrawerUserInfo(),

                    
                  ],
                ),
              ),
            ),

            // 💫 Kaydırılabilir içerik
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const DrawerBadges(),
                    const Divider(),

                    // 🌗 Tema değiştir
                    const ThemeToggleTile(),
                    const Divider(),

                    // ⚙️ Ayarlara Git
                    ListTile(
                      leading: Icon(Icons.settings, color: textColor),
                      title: Text("Ayarlar", style: TextStyle(color: textColor)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),

                    // 🚪 Çıkış
                    ListTile(
                      leading: Icon(Icons.logout, color: textColor),
                      title: Text("Çıkış Yap", style: TextStyle(color: textColor)),
                      onTap: () => _signOut(context),
                    ),
                  ],
                ),
              ),
            ),

            // 📦 Alt bilgi
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                children: [
                  Text("© 2025 Tedarik Mobil", style: TextStyle(fontSize: 12, color: subTextColor)),
                  const SizedBox(height: 4),
                  Text("v1.0.0", style: TextStyle(fontSize: 12, color: subTextColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


}
