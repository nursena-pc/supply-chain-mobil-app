import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gizlilik Politikası"),
        backgroundColor: Colors.green,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🔒 Gizlilik Politikası",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                "Son güncelleme: 3 Temmuz 2025",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text(
                "Uygulamamız, kullanıcı gizliliğine büyük önem vermektedir. Kişisel verileriniz sizin onayınız olmadan asla üçüncü taraflarla paylaşılmaz.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "📱 Toplanan Bilgiler",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "- Uygulama içindeki not, çizim ve medya verileri yalnızca cihazınızda veya sizin isteğinizle bulutta (Firebase) saklanır.\n"
                "- Giriş işlemleri sırasında yalnızca e-posta ve kimlik doğrulama verisi alınır.\n"
                "- Uygulama performansını iyileştirmek için anonim kullanım istatistikleri toplanabilir.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "🔐 Verilerin Kullanımı ve Paylaşımı",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "- Verileriniz sadece uygulama işlevlerini sağlamak amacıyla kullanılır.\n"
                "- Herhangi bir reklam, analiz veya pazarlama hizmetiyle paylaşılmaz.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "📁 Verilerin Saklanması ve Silinmesi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "- Veriler yalnızca sizin cihazınızda veya Firebase üzerinde saklanır.\n"
                "- Hesabınızı sildiğinizde tüm verileriniz geri alınamaz şekilde silinir.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "🧒 Çocukların Gizliliği",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "- Uygulama 13 yaş altı çocuklara yönelik değildir ve bu yaş grubundan kasıtlı veri toplanmaz.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "📨 İletişim",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Gizlilik politikamızla ilgili herhangi bir sorunuz varsa bizimle şu adresten iletişime geçebilirsiniz:\n"
                "📧 infotedarik@tedarikmobil.com",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              Center(
                child: Text(
                  "© 2025 TedarikMobilApp",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
