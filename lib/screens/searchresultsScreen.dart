import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final String category;

  const SearchResultsScreen({Key? key, required this.category}) : super(key: key);

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Samsung Galaxy S9 64 GB titanium grey 4 GB RAM',
      'color': 'Titanium Grey',
      'model': 'S9',
      'internalMemory': '64 GB',
      'ram': '4 GB',
      'image': 'assets/images/samsung_s9.png',
    },
    {
      'name': 'Samsung Galaxy S9+ 128 GB roxo-lilás 6 GB RAM',
      'color': 'Roxo-lilás',
      'model': 'S9+',
      'internalMemory': '128 GB',
      'ram': '6 GB',
      'image': 'assets/images/samsung_s9_plus.png',
    },
    {
      'name': 'Samsung Galaxy S9+ 64 GB dourado-amanhecer 6 GB RAM',
      'color': 'Dourado-amanhecer',
      'model': 'S9+',
      'internalMemory': '64 GB',
      'ram': '6 GB',
      'image': 'assets/images/samsung_s9_plus_gold.png',
    },
    {
      'name': 'Samsung Galaxy S9 128 GB coral blue 4 GB RAM',
      'color': 'Coral Blue',
      'model': 'S9',
      'internalMemory': '128 GB',
      'ram': '4 GB',
      'image': 'assets/images/samsung_s9_blue.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filtra os produtos pela categoria
    final filteredProducts = products;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(category, style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('Nenhum produto encontrado.'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _buildProductCard(product);
                    },
                  ),
          ),
          _buildAddProductButton(context),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image.asset(
          product['image'],
          height: 60,
          width: 60,
          fit: BoxFit.cover,
        ),
        title: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTag(product['color'], Colors.grey),
                const SizedBox(width: 8),
                _buildTag("Modelo: ${product['model']}", Colors.blue),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildTag("Memória interna: ${product['internalMemory']}", Colors.green),
                const SizedBox(width: 8),
                _buildTag("Memória RAM: ${product['ram']}", Colors.orange),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
        onTap: () {
          // Navegar para detalhes do produto
        },
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAddProductButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/add_product', arguments: {'category': category});
        },
        child: const Text(
          'Não é o que eu vendo',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
