import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'privacy_policy_screen.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  String version = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

 Future<void> _launchUrl(String urlString) async {
  final Uri url = Uri.parse(urlString);

  try {
    final canLaunchExternal = await canLaunchUrl(url);
    if (canLaunchExternal) {
      final success = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        debugPrint("Link açılamadı: $urlString");
      }
    } else {
      debugPrint("Link desteklenmiyor: $urlString");
    }
  } catch (e) {
    debugPrint("Link açma hatası: $e");
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uygulama Hakkında")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/icon.png', width: 72, height: 72),
                ),
                const SizedBox(height: 12),
                Text('Tedarik Mobil',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('Sürüm $version',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                const Text('© 2025 Tedarik Mobil. Tüm hakları saklıdır.',
                    style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Resmi Web Sitemiz"),
            onTap: () => _launchUrl("https://nursena-pc.github.io/tedarikmobil_web/"),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Gizlilik Politikası"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text("Lisanslar"),
            onTap: () => showLicensePage(
              context: context,
              applicationName: "Tedarik Mobil",
              applicationVersion: version,
            ),
          ),
        ],
      ),
    );
  }
}
