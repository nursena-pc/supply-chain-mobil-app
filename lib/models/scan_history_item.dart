class ScanHistoryItem {
  final String productId;
  final String cid; // EKLENDİ
  final DateTime scannedAt;

  ScanHistoryItem({
    required this.productId,
    required this.cid,
    required this.scannedAt,
  });

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'cid': cid,
    'scannedAt': scannedAt,
  };
}
