import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'label': 'Eletrônicos', 'icon': Icons.devices},
    {'label': 'Moda', 'icon': Icons.checkroom},
    {'label': 'Casa e Móveis', 'icon': Icons.chair},
    {'label': 'Esporte', 'icon': Icons.sports_soccer},
    {'label': 'Veículos', 'icon': Icons.directions_car},
    {'label': 'Livros', 'icon': Icons.book},
    {'label': 'Alimentos', 'icon': Icons.fastfood},
    {'label': 'Brinquedos', 'icon': Icons.toys},
    {'label': 'Servicos', 'icon': Icons.handyman},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Selecione uma Categoria',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          // Verificação para garantir que label e icon não sejam nulos
          final label = category['label'] as String? ?? 'Categoria';
          final icon = category['icon'] as IconData? ?? Icons.category;  
      
          return GestureDetector(
            onTap: () {
              // Use a chave correta e garanta que o valor não seja nulo
              Navigator.pushNamed(context, '/search_product', arguments: label);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 48, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
