import 'package:flutter/material.dart';

class LocationInput extends StatelessWidget {
  final String location;
  final ValueChanged<String?> onChanged;

  const LocationInput({
    super.key,
    required this.location,
    required this.onChanged,
  });

  static const List<String> iller = [
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
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: location);

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') return const Iterable<String>.empty();
        return iller.where((il) =>
            il.toLowerCase().startsWith(textEditingValue.text.toLowerCase()));
      },
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        textController.text = location;
        textController.selection =
            TextSelection.collapsed(offset: location.length);

        return TextField(
          controller: textController,
          focusNode: focusNode,
          onChanged: onChanged,
          decoration: const InputDecoration(
            labelText: 'Konum',
            border: OutlineInputBorder(),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final option = options.elementAt(index);
                return InkWell(
                  onTap: () => onSelected(option),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFFD0ECD4), // Açık yeşil
                    child: Text(option),
                  ),
                );
              },
            ),
          ),
        );
      },
      onSelected: onChanged,
    );
  }
}
