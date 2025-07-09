import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tedarik_final/services/auth_service.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  DateTime? birthDate;

  Future<void> _registerUser() async {
    if (emailController.text.isEmpty || !emailController.text.contains("@")) {
      _showSnackbar("Geçerli bir e-mail girin");
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _showSnackbar("Şifreler eşleşmiyor");
      return;
    }
    if (passwordController.text.length < 6) {
      _showSnackbar("Şifre en az 6 karakter olmalı");
      return;
    }
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        birthDate == null) {
      _showSnackbar("Tüm alanları doldurun");
      return;
    }

    final authService = AuthService();
    final user = await authService.registerWithEmailAndSave(
      emailController.text.trim(),
      passwordController.text.trim(),
      context,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      birthDate: birthDate!,
    );

    if (user != null) {
      _showSnackbar("Kayıt başarılı");
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      _showSnackbar("Kayıt başarısız");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ 1. Arka plan - geçişli yeşil tonlar
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Color.fromARGB(237, 29, 138, 38),
                  Color.fromARGB(214, 184, 236, 186),
                  Color.fromARGB(238, 3, 69, 9),
                  Color.fromARGB(124, 17, 231, 28),
                ],
              ),
            ),
          ),

          // ✅ 2. Cam etkisi kutu
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // bulanıklık
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.83), // cam parlaklığı
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Yeni Hesap Oluştur",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(nameController, 'Ad Soyad'),
                        const SizedBox(height: 16),

                        _buildTextField(phoneController, 'Telefon', inputType: TextInputType.phone),
                        const SizedBox(height: 16),

                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => birthDate = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "Doğum Tarihi",
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              birthDate == null
                                  ? "Tarih seçin"
                                  : DateFormat('dd.MM.yyyy').format(birthDate!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(emailController, 'E-mail'),
                        const SizedBox(height: 16),

                        _buildTextField(passwordController, 'Şifre', obscure: true),
                        const SizedBox(height: 16),

                        _buildTextField(confirmPasswordController, 'Şifre (Tekrar)', obscure: true),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: _registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text("Kayıt Ol"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Zaten hesabın var mı? Giriş Yap",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
