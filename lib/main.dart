import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:tedarik_final/screens/common/scan_history_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/common/main_menu_screen.dart';
import 'screens/common/qr_scanner_screen.dart';
import 'screens/common/settings/settings_screen.dart';
import 'screens/common/settings/feedback_screen.dart';
import 'screens/common/settings/privacy_policy_screen.dart';
import 'screens/common/settings/theme_provider.dart';
import 'screens/product/product_detail_screen_from_id.dart';
import 'screens/common/settings/faq_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await initializeDateFormatting('tr_TR', null);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Tedarik Mobil',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/qrScanner': (context) => const QRScannerScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/history': (context) => const ScanHistoryScreen(),
        '/productDetail': (context) {
          final productId = ModalRoute.of(context)!.settings.arguments as String;
          return ProductDetailScreenFromId(productId: productId);
        },
        '/faq': (context) => const FAQScreen(),
        // Gerekirse daha fazla ekran buraya eklenebilir
      },
    );
  }
}
