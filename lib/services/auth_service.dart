import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:flutter/material.dart'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcıyı modele çevir
  UserModel? _userFromFirebase(User? user, String? role) {
    if (user == null) return null;
    return UserModel(uid: user.uid, email: user.email!, role: role ?? "unknown");
  }

  // Email & Şifre ile Giriş
  Future<UserModel?> signInWithEmail(String email, String password, BuildContext context) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    if (user == null) return null;

    // Firestore'dan rol kontrolü
    DocumentReference userRef = _firestore.collection('users').doc(user.uid);
    DocumentSnapshot userDoc = await userRef.get();

    String? role;

    if (!userDoc.exists) {
      // Kullanıcı yoksa yeni kayıt et
      await userRef.set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'unknown',
      });
      role = 'unknown';
    } else {
      role = userDoc.get('role');
    }

    return _userFromFirebase(user, role);

  } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Giriş hatası"))
);
    print("Email giriş Firebase hatası: $e");
    return null;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Bilinmeyen hata"))
);
    print("Email giriş genel hata: $e");
    return null;
  }
}


  // Email & Şifre ile Kayıt
 Future<UserModel?> registerWithEmailAndSave(String email, String password, BuildContext context) async {
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı oluşturulamadı"))
);
      return null;
    }

    // Firestore kaydı
    await _firestore.collection('users').doc(user.uid).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'role': 'unknown',
    });

    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Firestore'a kayıt başarılı"))
);
    return UserModel(
      uid: user.uid,
      email: user.email ?? email,
      role: 'unknown',
    );

  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bu e-posta zaten kayıtlı"))
);
    } else if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Şifre çok zayıf"))
);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Firebase Auth hatası"))
);
    }
    print("registerWithEmailAndSave hatası: $e");
    return null;

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("BEklenmeyen hata oluştu"))
);
    print("registerWithEmailAndSave genel hata: $e");
    return null;
  }
}




  // Google ile Giriş
  Future<UserModel?> signInWithGoogle() async {
  try {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
      forceCodeForRefreshToken: true,
    );

    // Oturumu tamamen kopar, önbelleği temizle
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      debugPrint("🚫 Kullanıcı Google hesabı seçmedi.");
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential result = await _auth.signInWithCredential(credential);
    User? user = result.user;

    final docRef = _firestore.collection('users').doc(user!.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return _userFromFirebase(user, null);
  } catch (e) {
    debugPrint("Google giriş hatası: $e");
    return null;
  }
}


  // Kullanıcı çıkışı
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
