import 'package:farmacio_app/controller/cartController.dart';
import 'package:farmacio_app/models/productModel.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Product _product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _product = ModalRoute.of(context)!.settings.arguments as Product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_product.description),
            Text('Price: \$${_product.price}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add product to cart
                _addToCart(_product);
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart(Product product) async {
    // Add product to cart
    final cartcontroller = CartController();
    await cartcontroller.addProductToCart(product.id);
    // Navigate to cart screen
    Navigator.pushNamed(context, '/cart');
  }
}
