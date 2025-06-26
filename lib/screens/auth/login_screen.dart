import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signInWithEmail() async {
    final user = await AuthService().signInWithEmail(
      
      emailController.text.trim(),
      passwordController.text.trim(),
      context
    );

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text("Giriş başarılı"))
);      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Giriş başarısız"))
);
    }
  }

  Future<void> _signInWithGoogle() async {
    final user = await AuthService().signInWithGoogle();

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Google ile giriş başarılı"))
);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Google ile giriş başarısız"))
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
              Image.asset('assets/images/login.png', height: 180),
              const SizedBox(height: 32),
              const Text(
                "Tedarik Mobil'e Giriş Yap",
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
              ElevatedButton(
                onPressed: _signInWithEmail,
                child: const Text("Giriş Yap"),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text("Hesabın yok mu? Kayıt ol"),
              ),
              const Divider(height: 40),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Image.asset('assets/icons/google.png', height: 24),
                  label: const Text("Google ile Giriş Yap"),
                  onPressed: _signInWithGoogle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
