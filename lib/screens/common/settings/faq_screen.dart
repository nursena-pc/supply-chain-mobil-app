import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  final List<Map<String, String>> faqs = const [
    {
      "question": "Ürün nasıl eklenir?",
      "answer":
          "Ana menüden 'Ürün Ekle' butonuna tıklayarak ürün bilgilerini doldurup ekleyebilirsiniz."
    },
    {
      "question": "QR kod ne işe yarar?",
      "answer":
          "QR kodlar ürün detayına hızlı erişim sağlar. Tarayarak ürünü doğrulayabilirsiniz."
    },
    {
      "question": "Ürün güncelleme nasıl yapılır?",
      "answer":
          "Ürün detay sayfasında 'Güncelle' butonuna tıklayarak ilgili ürünün ProductID'sini girerek güncelleme ekranına geçebilir ve bilgileri düzenleyebilirsiniz."
    },
    {
      "question": "Şifremi nasıl değiştirebilirim?",
      "answer":
          "Ayarlar > Güvenlik bölümünden 'Şifre Değiştir' seçeneğini kullanarak sisteme giriş yaptığınız e-mail adresinize gelen sıfırlama linki ile şifrenizi değiştirebilirsiniz."
    },
    {
      "question": "Analiz ekranında hangi veriler gösteriliyor?",
      "answer":
          "Analiz ekranında sizin eklediğiniz ürünlerin şehir bazlı dağılımı, ürünlerin markalarına göre pasta grafik gösterimi ve detaylı ürün sayıları yer alır. Bu sayede hangi şehirde kaç ürününüz olduğunu ve ürünlerin son durumlarını görebilirsiniz."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Sıkça Sorulan Sorular"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: const Icon(Icons.help_outline, color: Colors.green),
              title: Text(
                faq["question"] ?? "",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 16),
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    faq["answer"] ?? "",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
