import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  Future<void> _sendFeedback() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "Anonim";

    await FirebaseFirestore.instance.collection('feedbacks').add({
      'text': text,
      'email': email,
      'timestamp': Timestamp.now(),
    });

    setState(() => _isSending = false);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Teşekkürler 💌"),
          content: const Text("Geri bildiriminiz başarıyla gönderildi."),
          actions: [
            TextButton(
              child: const Text("Tamam"),
              onPressed: () {
                Navigator.pop(context); // dialog
                Navigator.pop(context); // ekran
              },
            ),
          ],
        ),
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geri Bildirim Gönder"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Uygulama ile ilgili görüş, öneri veya hataları bize iletebilirsiniz.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Mesajınızı buraya yazın...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isSending ? null : _sendFeedback,
              icon: const Icon(Icons.send),
              label: const Text("Gönder"),
            )
          ],
        ),
      ),
    );
  }
}
