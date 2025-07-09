import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tedarik_final/screens/auth/login_screen.dart';
import 'package:tedarik_final/screens/common/settings/profile_edit_screen.dart';
import 'package:tedarik_final/screens/common/settings/password_reset_dialog.dart';
import 'package:tedarik_final/screens/common/settings/theme_toggle_tile.dart';
import 'package:tedarik_final/screens/common/settings/about_app_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _signOut(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFD1F5D3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Çıkış Yap",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          "Çıkış yapmak istediğinize emin misiniz?",
          style: TextStyle(fontSize: 16),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 8, right: 12),
        actions: [
          TextButton(
            child: const Text("İptal", style: TextStyle(color: Colors.deepPurple)),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout, size: 18),
            label: const Text("Çıkış Yap"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD8605E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sectionBackground = isDark ? Colors.green[900] : const Color(0xFFD1F5D3);
    final titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black,
    );
    final textStyle = TextStyle(
      color: isDark ? Colors.white : Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: sectionBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("👤 Kullanıcı Ayarları", style: titleStyle),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.person, color: textStyle.color),
            title: Text('Bilgilerimi Görüntüle / Güncelle', style: textStyle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
              );
            },
          ),
          const Divider(),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: sectionBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("🌙 Görünüm", style: titleStyle),
          ),
          const SizedBox(height: 8),
          const ThemeToggleTile(),
          const Divider(),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: sectionBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("🔐 Güvenlik", style: titleStyle),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.lock_reset, color: textStyle.color),
            title: Text('Şifre Değiştir', style: textStyle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PasswordChangeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: textStyle.color),
            title: Text('Çıkış Yap', style: textStyle),
            onTap: () => _signOut(context),
          ),
          const Divider(),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: sectionBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("❓ Yardım", style: titleStyle),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('Sıkça Sorulan Sorular'),
            onTap: () => Navigator.pushNamed(context, '/faq'),
          ),
          ListTile(
            leading: Icon(Icons.feedback, color: textStyle.color),
            title: Text('Geri Bildirim Gönder', style: textStyle),
            onTap: () => Navigator.pushNamed(context, '/feedback'),
          ),
          ListTile(
            leading: Icon(Icons.info, color: textStyle.color),
            title: Text('Gizlilik Politikası', style: textStyle),
            onTap: () => Navigator.pushNamed(context, '/privacy'),
          ),
          const Divider(),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: sectionBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("ℹ️ Uygulama Bilgisi", style: titleStyle),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.info_outline, color: textStyle.color),
            title: Text('Uygulama Hakkında', style: textStyle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutAppScreen()),
              );
            },
          ),

          const SizedBox(height: 16),
          Text(
            "© 2025 Tedarik Mobil",
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            "v1.0.0",
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
