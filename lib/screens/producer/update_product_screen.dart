import 'package:flutter/material.dart';
import 'package:tedarik_final/services/ipfs_service.dart';
import 'package:tedarik_final/screens/producer/share_qr_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProductScreen extends StatefulWidget {
  final Map<String, dynamic> ipfsContent;
  final String productId;

  const UpdateProductScreen({
    Key? key,
    required this.ipfsContent,
    required this.productId,
  }) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController statusController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  bool _isUpdating = false;
  String? _statusMessage;

  final List<String> durumlar = [
    'Üretildi',
    'Depoda',
    'Dağıtımda',
    'Teslim Edildi',
  ];

  final List<String> iller = [
    'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Aksaray', 'Amasya', 'Ankara',
    'Antalya', 'Ardahan', 'Artvin', 'Aydın', 'Balıkesir', 'Bartın', 'Batman',
    'Bayburt', 'Bilecik', 'Bingöl', 'Bitlis', 'Bolu', 'Burdur', 'Bursa',
    'Çanakkale', 'Çankırı', 'Çorum', 'Denizli', 'Diyarbakır', 'Düzce', 'Edirne',
    'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir', 'Gaziantep', 'Giresun',
    'Gümüşhane', 'Hakkari', 'Hatay', 'Iğdır', 'Isparta', 'İstanbul', 'İzmir',
    'Kahramanmaraş', 'Karabük', 'Karaman', 'Kars', 'Kastamonu', 'Kayseri',
    'Kırıkkale', 'Kırklareli', 'Kırşehir', 'Kilis', 'Kocaeli', 'Konya', 'Kütahya',
    'Malatya', 'Manisa', 'Mardin', 'Mersin', 'Muğla', 'Muş', 'Nevşehir',
    'Niğde', 'Ordu', 'Osmaniye', 'Rize', 'Sakarya', 'Samsun', 'Şanlıurfa',
    'Siirt', 'Sinop', 'Şırnak', 'Sivas', 'Tekirdağ', 'Tokat', 'Trabzon',
    'Tunceli', 'Uşak', 'Van', 'Yalova', 'Yozgat', 'Zonguldak'
  ];

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> flatten(Map data) {
      while (data.containsKey('data') && data['data'] is Map) {
        data = Map<String, dynamic>.from(data['data']);
      }
      return Map<String, dynamic>.from(data);
    }

    final flat = flatten(widget.ipfsContent);
    statusController.text = flat['status'] ?? '';
    locationController.text = flat['location'] ?? '';
  }

  Future<void> _updateProduct() async {
    setState(() {
      _isUpdating = true;
      _statusMessage = null;
    });

    final newStatus = statusController.text.trim();
    final newLocation = locationController.text.trim();
    final newTimestamp = DateTime.now().toUtc().toIso8601String();

    final latestFromChain = await IPFSService.getProductById(widget.productId);
    if (latestFromChain == null || latestFromChain['data'] == null) {
      setState(() {
        _statusMessage = '❌ Mevcut veriye erişilemedi.';
        _isUpdating = false;
      });
      return;
    }

    final previousData = Map<String, dynamic>.from(latestFromChain['data']);
    previousData['status'] = newStatus;
    previousData['location'] = newLocation;
    previousData['timestamp'] = newTimestamp;

    final Map<String, dynamic> timestamps = Map<String, dynamic>.from(previousData['timestamps'] ?? {});
    timestamps[newStatus] = newTimestamp;
    previousData['timestamps'] = timestamps;

    final newCid = await IPFSService.uploadJSON(previousData);

    if (newCid != null) {
    final success = await IPFSService.updateProductOnChain(
  widget.productId,
  'ipfs://$newCid',
  newStatus,
);

setState(() {
  _statusMessage = success
      ? '✅ Güncelleme başarılı. Yeni CID: $newCid'
      : '⚠️ CID yüklendi ama blockchain kaydı başarısız.';
});

if (success && mounted) {
  // ✅ Firestore'a update logu ekle
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await FirebaseFirestore.instance.collection('productHistory').add({
      'userId': currentUser.uid,
      'productId': widget.productId,
      'type': 'update',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => ShareQRScreen(cid: newCid),
    ),
  );
}

    } else {
      setState(() {
        _statusMessage = '❌ Güncelleme başarısız.';
      });
    }

    setState(() {
      _isUpdating = false;
    });
  }

  @override
  void dispose() {
    statusController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürün Güncelle"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "📦 Ürün ID: ${widget.productId}",
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: statusController.text.isNotEmpty ? statusController.text : null,
                items: durumlar.map((durum) {
                  return DropdownMenuItem<String>(
                    value: durum,
                    child: Text(durum),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    statusController.text = value ?? '';
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Durum",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') return const Iterable<String>.empty();
                  return iller.where((String il) {
                    return il.toLowerCase().startsWith(textEditingValue.text.toLowerCase());
                  });
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  controller.text = locationController.text;
                  controller.selection = TextSelection.collapsed(offset: controller.text.length);

                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (val) => locationController.text = val,
                    decoration: const InputDecoration(
                      labelText: "Konum",
                      border: OutlineInputBorder(),
                    ),
                  );
                },
                onSelected: (String selection) {
                  locationController.text = selection;
                },
              ),

              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: _isUpdating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save, color: Colors.white), // ✅ ikon da beyaz
                label: Text(
                  _isUpdating ? "Güncelleniyor..." : "Kaydet",
                  style: const TextStyle(color: Colors.white), // ✅ yazı beyaz
                ),
                onPressed: _isUpdating ? null : _updateProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),


              const SizedBox(height: 16),
              if (_statusMessage != null)
                Text(
                  _statusMessage!,
                  style: TextStyle(
                    color: _statusMessage!.startsWith("✅") ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
