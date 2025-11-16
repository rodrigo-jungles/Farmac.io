import 'package:flutter/material.dart';

class ProductConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductConfirmationScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Categoria',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildProductImage(product['image']),
            const SizedBox(height: 20),
            _buildProductDetails(product),
            const SizedBox(height: 30),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String imagePath) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Image.asset(
        imagePath,
        height: 200,
        width: 200,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildProductDetails(Map<String, dynamic> product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Cor', product['color']),
            _buildDetailRow('Linha', product['line']),
            _buildDetailRow('Marca', product['brand']),
            _buildDetailRow('Memória RAM', product['ram']),
            _buildDetailRow('Memória interna', product['internalMemory']),
            _buildDetailRow('Modelo', product['model']),
            _buildDetailRow('É Dual SIM', product['dualSim'] ? 'Sim' : 'Não'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Implementar ação para mostrar todas características
              },
              child: const Text(
                'Mostrar todas as características',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Ação ao confirmar produto
              Navigator.pop(context, product); // Retorna o produto confirmado
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            // Ação para cadastrar produto manualmente
            Navigator.pushNamed(context, '/add_product');
          },
          child: const Text(
            'Não é o que eu vendo',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
