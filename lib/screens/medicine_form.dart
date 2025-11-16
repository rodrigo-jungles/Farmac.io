import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../controller/medicineController.dart';

class MedicineForm extends StatefulWidget {
  const MedicineForm({super.key});

  @override
  State<MedicineForm> createState() => _MedicineFormState();
}

class _MedicineFormState extends State<MedicineForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String _pharmacyName = 'farmácia impopular';
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _mgCtrl = TextEditingController();
  final TextEditingController _otherSymptomCtrl = TextEditingController();

  bool _requiresPrescription = false;
  XFile? _pickedImage;

  final List<String> _symptoms = [
    'Dor de cabeça',
    'Náusea',
    'Enxaqueca',
    'Febre',
    'Tosse',
  ];
  final Set<String> _selectedSymptoms = {};

  final MedicineController _medCtrl = Get.find<MedicineController>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _mgCtrl.dispose();
    _otherSymptomCtrl.dispose();
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

  void _addMedicine() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final mg = _mgCtrl.text.trim();
    final indications = <String>[];
    indications.addAll(_selectedSymptoms);
    final other = _otherSymptomCtrl.text.trim();
    if (other.isNotEmpty) indications.add(other);

    final med = {
      'name': name,
      'price': price,
      'mg': mg,
      'indications': indications,
      'requiresPrescription': _requiresPrescription,
      'image': _pickedImage?.path,
    };
    _medCtrl.addMedicine(med);
    setState(() {
      _nameCtrl.clear();
      _priceCtrl.clear();
      _mgCtrl.clear();
      _otherSymptomCtrl.clear();
      _selectedSymptoms.clear();
      _requiresPrescription = false;
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
      appBar: AppBar(title: Text('Cadastro de remédio - $_pharmacyName')),
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
                      labelText: 'Nome do remédio',
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
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mgCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Miligrama (ex: 500mg)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Indicado para (selecione):'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _symptoms.map((s) {
                      final selected = _selectedSymptoms.contains(s);
                      return FilterChip(
                        label: Text(s),
                        selected: selected,
                        onSelected: (v) => setState(() {
                          if (v)
                            _selectedSymptoms.add(s);
                          else
                            _selectedSymptoms.remove(s);
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _otherSymptomCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Outro sintoma (opcional)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: _requiresPrescription,
                        onChanged: (v) =>
                            setState(() => _requiresPrescription = v ?? false),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(child: Text('Requer receita?')),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                    onPressed: _addMedicine,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Text('Adicionar remédio'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Remédios cadastrados:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final meds = _medCtrl.medicines;
              if (meds.isEmpty)
                return const Text('Nenhum remédio cadastrado ainda.');
              return Column(
                children: meds.reversed.map((p) {
                  final indications = (p['indications'] as List).join(', ');
                  final String? imgPath = p['image'] as String?;
                  Widget leading;
                  if (imgPath == null) {
                    leading = const Icon(Icons.medication);
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
                      title: Text('${p['name']} ${p['mg'] ?? ''}'),
                      subtitle: Text(
                        'R\$ ${(p['price'] as num).toDouble().toStringAsFixed(2)} • Indicado: $indications',
                      ),
                      trailing: p['requiresPrescription']
                          ? const Icon(Icons.description)
                          : null,
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
