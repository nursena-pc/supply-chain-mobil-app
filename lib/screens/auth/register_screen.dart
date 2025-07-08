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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Geçerli bir e-mail girin")),
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifreler eşleşmiyor")),
      );
      return;
    }
    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifre en az 6 karakter olmalı")),
      );
      return;
    }
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tüm alanları doldurun")),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarılı")),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarısız")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.black : const Color(0xFFEFF4F8);
    final borderColor = isDark ? Colors.grey : Colors.black26;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                "Yeni Hesap Oluştur",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 16),

              _buildTextField(nameController, 'Ad Soyad', textColor, borderColor),
              const SizedBox(height: 16),

              _buildTextField(phoneController, 'Telefon', textColor, borderColor, inputType: TextInputType.phone),
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
                  decoration: InputDecoration(
                    labelText: "Doğum Tarihi",
                    labelStyle: TextStyle(color: textColor),
                    border: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
                  ),
                  child: Text(
                    birthDate == null
                        ? "Tarih seçin"
                        : DateFormat('dd.MM.yyyy').format(birthDate!),
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildTextField(emailController, 'E-mail', textColor, borderColor),
              const SizedBox(height: 16),

              _buildTextField(passwordController, 'Şifre', textColor, borderColor, obscure: true),
              const SizedBox(height: 16),

              _buildTextField(confirmPasswordController, 'Şifre (Tekrar)', textColor, borderColor, obscure: true),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Kayıt Ol"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Zaten hesabın var mı? Giriş Yap",
                  style: TextStyle(color: isDark ? Colors.grey[300] : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, Color textColor, Color borderColor,
      {bool obscure = false, TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: inputType,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
