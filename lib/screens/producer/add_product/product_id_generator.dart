import 'dart:math';

class ProductIdGenerator {
  static String generate() {
    final now = DateTime.now();
    final random = Random();
    final randomDigits = random.nextInt(9000) + 1000; // 4 haneli sayı
    return 'PROD-${now.millisecondsSinceEpoch}-$randomDigits';
  }
}
