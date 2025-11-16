import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/sintomaController.dart';
import '../controller/medicineController.dart';

// ignore: must_be_immutable

class SintomaQiScreen extends StatefulWidget {
  const SintomaQiScreen({super.key});

  @override
  State<SintomaQiScreen> createState() => _SintomaQiScreenState();
}

class _SintomaQiScreenState extends State<SintomaQiScreen> {
  final SintomaController _ctrl = Get.put(SintomaController());
  final TextEditingController _textCtrl = TextEditingController();
  final MedicineController _medCtrl = Get.put(MedicineController());
  final RxList<Map<String, dynamic>> _recommendations =
      <Map<String, dynamic>>[].obs;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) {
      Get.snackbar(
        'Atenção',
        'Descreva seu sintoma antes de salvar',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await _ctrl.add(text);
    _textCtrl.clear();
    // gerar recomendações
    final recs = _medCtrl.recommendForText(text);
    _recommendations.assignAll(recs);
    Get.snackbar(
      'Salvo',
      'Sintoma salvo com sucesso',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Descreva seu sintoma')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conte-nos o que você está sentindo. Descreva os sintomas com palavras simples (ex: "dor de cabeça e febre")',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Escreva sua descrição aqui...',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    _textCtrl.clear();
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Resultado gerado',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final diag = _ctrl.lastDiagnosis.value;
              if (diag.isEmpty) {
                return const Text('Nenhum resultado gerado ainda.');
              }
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(diag),
              );
            }),
            const SizedBox(height: 18),
            const Text(
              'Recomendações de remédios',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (_recommendations.isEmpty) {
                return const Text(
                  'Nenhuma recomendação encontrada para o sintoma atual.',
                );
              }
              return Column(
                children: _recommendations.map((m) {
                  final inds = (m['indications'] as List).join(', ');
                  return Card(
                    child: ListTile(
                      title: Text(m['name'] ?? ''),
                      subtitle: Text(
                        'R\$ ${(m['price'] as num).toDouble().toStringAsFixed(2)} • Indicado: $inds',
                      ),
                      trailing: Text('score: ${m['score'] ?? 0}'),
                    ),
                  );
                }).toList(),
              );
            }),
            const Text(
              'Histórico de sintomas salvos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                final items = _ctrl.symptoms;
                if (items.isEmpty) {
                  return const Center(
                    child: Text('Nenhum sintoma salvo ainda.'),
                  );
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final s = items[index];
                    return ListTile(
                      title: Text(s),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () async {
                          await _ctrl.removeAt(index);
                          Get.snackbar(
                            'Removido',
                            'Sintoma removido',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                      onTap: () {
                        // ao tocar re-gerar diagnóstico para este item
                        final diag = _ctrl.generateDiagnosis(s);
                        _ctrl.lastDiagnosis.value = diag;
                        // recompute recommendations for tapped symptom
                        final recs = _medCtrl.recommendForText(s);
                        _recommendations.assignAll(recs);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
