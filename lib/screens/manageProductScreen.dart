import 'package:farmacio_app/controller/productController.dart';
import 'package:farmacio_app/models/productModel.dart';
import 'package:flutter/material.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  _ManageProductsScreenState createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // Load products from database
    final productcontroller = ProductController();
    _products = await productcontroller.getProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_products[index].name),
            subtitle: Text(_products[index].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit product screen
                    Navigator.pushNamed(context, '/edit_product', arguments: _products[index]);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Delete product from database
                    _deleteProduct(_products[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product screen
          Navigator.pushNamed(context, '/add_product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteProduct(Product product) async {
    // Delete product from database
    final productcontroller = ProductController();
    await productcontroller.deleteProduct(product.id);
    _loadProducts();
  }
}
