  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:tedarik_final/services/auth_service.dart';
  class RegisterScreen extends StatefulWidget {
    const RegisterScreen({super.key});

    @override
    State<RegisterScreen> createState() => _RegisterScreenState();
  }

  class _RegisterScreenState extends State<RegisterScreen> {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();  
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<void> _registerUser() async {
    if (emailController.text.isEmpty || !emailController.text.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Geçerli bir e-mail girin"))
);

      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Şifreler eşleşmiyor"))
);

      return;
    }
    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Şifre en az 6 karakter olmalı"))
);

      return;
    }

    final authService = AuthService();
    final user = await authService.registerWithEmailAndSave(
      emailController.text.trim(),
      passwordController.text.trim(),
      context
    );

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kayıt başarılı"))
);

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kayıt başarısız"))
);

    }
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFEFF4F8),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                const Text(
                  "Yeni Hesap Oluştur",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Şifre (Tekrar)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: const Text("Kayıt Ol"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Zaten hesabın var mı? Giriş Yap"),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
