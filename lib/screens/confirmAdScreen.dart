import 'package:flutter/material.dart';

class ConfirmAdScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final Map<String, dynamic> deliveryOptions;

  const ConfirmAdScreen({
    super.key,
    required this.product,
    required this.deliveryOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Confirmar Anúncio',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Produto'),
            _buildInfoTile(
              title: product['name'],
              details: '''
Preço: R\$ ${product['price']}
Estoque: ${product['stock']} unidades
Cor: ${product['color'] ?? 'N/A'}
Memória RAM: ${product['ram'] ?? 'N/A'}
Memória Interna: ${product['storage'] ?? 'N/A'}
Modelo: ${product['model'] ?? 'N/A'}
''',
              onEdit: () {
                Navigator.pop(context, {'edit': 'product'});
              },
            ),
            _buildSectionHeader('Entrega'),
            _buildInfoTile(
              title: deliveryOptions['isLocalPickup'] ? 'Retirada Local' : 'Entrega pelo Vendedor',
              details: deliveryOptions['isLocalPickup']
                  ? 'Endereço: ${deliveryOptions['localPickupAddress']}\nInformações: ${deliveryOptions['additionalInfo'] ?? 'Nenhuma'}'
                  : 'Entrega ao cliente disponível',
              onEdit: () {
                Navigator.pop(context, {'edit': 'delivery'});
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anúncio confirmado com sucesso!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Confirmar Anúncio',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String details,
    required VoidCallback onEdit,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    details,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Editar',
            ),
          ],
        ),
      ),
    );
  }
}
