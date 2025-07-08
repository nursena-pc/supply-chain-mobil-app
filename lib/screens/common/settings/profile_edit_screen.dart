import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  DateTime? birthDate;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
  final user = FirebaseAuth.instance.currentUser; // 💡 Fonksiyon içinde alındı

  if (user != null) {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();
    if (data != null) {
      nameController.text = data['name'] ?? '';
      phoneController.text = data['phone'] ?? '';
      if (data['birthDate'] != null) {
        birthDate = (data['birthDate'] as Timestamp).toDate();
      }
      setState(() {});
    }
  }
}


  Future<void> _saveProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Lütfen tüm alanları doldurun"),
      ));
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'birthDate': Timestamp.fromDate(birthDate!),
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Bilgiler başarıyla güncellendi"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Bilgileri'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ad Soyad',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefon',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: birthDate ?? DateTime(2000),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
