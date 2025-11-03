import 'package:farmacio_app/controller/productController.dart';
import 'package:farmacio_app/models/productModel.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
        title: const Text('Products'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_products[index].name),
            subtitle: Text(_products[index].description),
            onTap: () {
              // Navigate to product details screen
              Navigator.pushNamed(context, '/product_details', arguments: _products[index]);
            },
          );
        },
      ),
    );
  }
}
