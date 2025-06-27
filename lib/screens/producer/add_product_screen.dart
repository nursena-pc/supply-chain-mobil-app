import 'package:flutter/material.dart';
import 'package:tedarik_final/screens/producer/add_product/brand_model_input.dart';
import 'package:tedarik_final/screens/producer/add_product/location_selector.dart';
import 'package:tedarik_final/screens/producer/add_product/manufacture_date_picker.dart';
import 'package:tedarik_final/screens/producer/add_product/product_id_generator.dart';
import 'package:tedarik_final/screens/producer/add_product/production_date_input.dart';
import 'package:tedarik_final/screens/producer/add_product/status_dropdown.dart';
import 'package:tedarik_final/screens/producer/add_product/submit_button.dart';
import 'package:tedarik_final/screens/producer/add_product/serial_warranty_input.dart';
import 'package:tedarik_final/screens/producer/add_product/location_selector.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController manufactureDateController = TextEditingController();
  final TextEditingController warrantyYearsController = TextEditingController();
  final TextEditingController productionDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String status = 'Üretildi';
  String selectedLocation = '';
  DateTime? selectedProductionDate;

  @override
  void initState() {
    super.initState();
    productIdController.text = ProductIdGenerator.generate();

    selectedProductionDate = DateTime.now();
    productionDateController.text = selectedProductionDate!.toIso8601String().split('T').first;
  }

  @override
  void dispose() {
    productIdController.dispose();
    brandController.dispose();
    modelController.dispose();
    serialNumberController.dispose();
    manufactureDateController.dispose();
    warrantyYearsController.dispose();
    productionDateController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Ekle'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: productIdController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Ürün ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            BrandModelInput(
              brandController: brandController,
              modelController: modelController,
            ),
            const SizedBox(height: 12),

            SerialWarrantyInput(
              serialController: serialNumberController,
              warrantyController: warrantyYearsController,
            ),
            const SizedBox(height: 12),

            ManufactureDatePicker(controller: manufactureDateController),
            const SizedBox(height: 12),

            ProductionDateInput(
              selectedDate: selectedProductionDate,
              onDateSelected: (pickedDate) {
                setState(() {
                  selectedProductionDate = pickedDate;
                  productionDateController.text =
                      pickedDate.toIso8601String().split('T').first;
                });
              },
            ),
            const SizedBox(height: 12),

            StatusDropdown(
              value: status,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => status = newValue);
                }
              },
            ),
            const SizedBox(height: 12),

            LocationInput(
              location: selectedLocation,
              onChanged: (val) {
                setState(() {
                  selectedLocation = val ?? '';
                  locationController.text = selectedLocation;
                });
              },
            ),
            const SizedBox(height: 24),

            SubmitButton(
              productIdController: productIdController,
              brandController: brandController,
              modelController: modelController,
              serialNumberController: serialNumberController,
              manufactureDateController: manufactureDateController,
              warrantyYearsController: warrantyYearsController,
              productionDateController: productionDateController,
              locationController: locationController,
              status: status,
            ),
          ],
        ),
      ),
    );
  }
}
