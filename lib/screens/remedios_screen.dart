import 'package:flutter/material.dart';

class RemediosScreen extends StatelessWidget {
  const RemediosScreen({super.key});

  static const List<Map<String, String>> _items = [
    {'file': 'dipirona.png', 'label': 'Dipirona'},
    {'file': 'dorflex.png', 'label': 'Dorflex'},
    {'file': 'torsilax.png', 'label': 'Torsilax'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remédios')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final it = _items[index];
            final path = 'assets/img_remedios/${it['file']}';
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // mostrar detalhes simples ao tocar
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            it['label'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Image.asset(
                              path,
                              height: 120,
                              errorBuilder: (c, e, s) => const Icon(
                                Icons.broken_image,
                                size: 64,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Descrição inicial: medicamento exemplo. Consulte o rótulo ou um profissional de saúde para indicações e dosagens.',
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
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            path,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Icon(
                              Icons.broken_image,
                              size: 48,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        it['label'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
