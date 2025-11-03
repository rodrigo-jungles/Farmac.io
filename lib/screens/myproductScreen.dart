import 'package:flutter/material.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({Key? key}) : super(key: key);

  @override
  _MyProductsScreenState createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      //final products = await ProductController().getProducts();
      setState(() {
        //_products = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar produtos: $e')),
      );
    }
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text('Meus Produtos Publicados', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _products.isEmpty
          ? const Center(child: Text('Nenhum produto publicado ainda.'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag, color: Colors.blue),
                    title: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Preço: R\$ ${product['price']} • Estoque: ${product['stock']}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                    },
                  ),
                );
              },
            ),
    );
  }
}
