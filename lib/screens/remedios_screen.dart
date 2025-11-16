import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/medicineController.dart';

class RemediosScreen extends StatelessWidget {
  RemediosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MedicineController medCtrl = Get.find<MedicineController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Remédios')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          final meds = medCtrl.medicines;
          if (meds.isEmpty) {
            return const Center(child: Text('Nenhum remédio cadastrado.'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: meds.length,
            itemBuilder: (context, index) {
              final it = meds[index];
              final String name = it['name'] ?? '';
              final double price = (it['price'] ?? 0).toDouble();
              final String mg = it['mg'] ?? '';
              final List<dynamic> inds = it['indications'] ?? [];
              final String? imgPath = it['image'] as String?;

              Widget imageWidget;
              if (imgPath == null) {
                imageWidget = const Icon(
                  Icons.medication,
                  size: 48,
                  color: Colors.black26,
                );
              } else if (kIsWeb) {
                imageWidget = Image.network(
                  imgPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                );
              } else {
                imageWidget = Image.file(
                  File(imgPath),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                );
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: SizedBox(height: 120, child: imageWidget),
                            ),
                            const SizedBox(height: 12),
                            Text('R\$ ${price.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            Text('Miligrama: $mg'),
                            const SizedBox(height: 8),
                            Text('Indicações: ${inds.join(', ')}'),
                            const SizedBox(height: 8),
                            Text(
                              it['requiresPrescription'] == true
                                  ? 'Requer receita'
                                  : 'Sem receita',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Center(child: imageWidget)),
                        const SizedBox(height: 8),
                        Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text('R\$ ${price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
