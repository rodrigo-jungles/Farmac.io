import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../controller/medicineController.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String _pharmacyName = 'farmácia impopular';
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  XFile? _pickedImage;

  final MedicineController _medCtrl = Get.put(MedicineController());

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
      );
      if (image != null) setState(() => _pickedImage = image);
    } catch (e) {}
  }

  void _addProduct() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final desc = _descCtrl.text.trim();
    final product = {
      'name': name,
      'price': price,
      'description': desc,
      'image': _pickedImage?.path,
    };
    _medCtrl.addProduct(product);
    setState(() {
      _nameCtrl.clear();
      _priceCtrl.clear();
      _descCtrl.clear();
      _pickedImage = null;
    });
  }

  Widget _buildImagePreview() {
    if (_pickedImage == null) return const SizedBox.shrink();
    if (kIsWeb)
      return Image.network(_pickedImage!.path, height: 100, fit: BoxFit.cover);
    return Image.file(File(_pickedImage!.path), height: 100, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de produto - $_pharmacyName')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: _pharmacyName,
              decoration: const InputDecoration(labelText: 'Nome da farmácia'),
              onChanged: (v) => setState(
                () => _pharmacyName = v.trim().isEmpty
                    ? 'farmácia impopular'
                    : v.trim(),
              ),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nome do produto',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Informe o nome'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Informe o valor'
                        : null,
                  ),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Informe o valor'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Anexar imagem'),
                      ),
                      const SizedBox(width: 12),
                      _buildImagePreview(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addProduct,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Text('Adicionar produto'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Produtos cadastrados:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final prods = _medCtrl.products;
              if (prods.isEmpty)
                return const Text('Nenhum produto cadastrado ainda.');
              return Column(
                children: prods.reversed.map((p) {
                  final String? imgPath = p['image'] as String?;
                  Widget leading;
                  if (imgPath == null) {
                    leading = const Icon(Icons.shopping_bag);
                  } else if (kIsWeb) {
                    leading = Image.network(
                      imgPath,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    );
                  } else {
                    leading = Image.file(
                      File(imgPath),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    );
                  }
                  return Card(
                    child: ListTile(
                      leading: leading,
                      title: Text(p['name']),
                      subtitle: Text(
                        'R\$ ${(p['price'] as num).toDouble().toStringAsFixed(2)} • ${p['description'] ?? ''}',
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
