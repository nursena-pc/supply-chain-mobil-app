import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/scan_history_item.dart';

class ScanHistoryService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addToHistory(ScanHistoryItem item) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('scanHistory').add({
      'userId': user.uid,
      'productId': item.productId,
      'cid': item.cid,
      'scannedAt': item.scannedAt, // ✅ doğrudan DateTime gönderiyoruz
    });
  }

  /// 🔍 Tarihe göre filtrelenmiş veya tüm geçmişi döner
  Future<List<ScanHistoryItem>> getHistory({Duration? filterDuration}) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    Query query = _firestore
        .collection('scanHistory')
        .where('userId', isEqualTo: user.uid);

    if (filterDuration != null) {
      final startDate = DateTime.now().subtract(filterDuration);
      query = query.where('scannedAt', isGreaterThanOrEqualTo: startDate);
    }

    final snapshot = await query
        .orderBy('scannedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
  return ScanHistoryItem(
    productId: data['productId'] ?? '',
    cid: data['cid'] ?? '',
    scannedAt: (data['scannedAt'] as Timestamp).toDate(),
  );
}).toList();

  }
}
