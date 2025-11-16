import 'package:flutter/material.dart';
import 'medicine_form.dart';
import 'product_form.dart';

class PharmacyMenu extends StatelessWidget {
  const PharmacyMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu da Farmácia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Escolha uma ação:'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MedicineForm()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Text('Cadastrar remédio'),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductForm()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Text('Cadastrar produto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
