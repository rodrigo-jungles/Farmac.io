import 'package:farmacio_app/controller/cartController.dart';
import 'package:farmacio_app/models/productModel.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  Future<void> _calculateTotal() async {
    // Calculate total price of products in cart
    final cartcontroller = CartController();
    var cart = await cartcontroller.getCart();
    double total = 0;
    for (Product product in cart) {
      total += product.price;
    }
    setState(() {
      _total = total;
    });
  }
  Future<void> _processPayment() async {
    // Process payment
    // Update order status in database
    // Clear the cart
    final cartcontroller = CartController();
    await cartcontroller.clearCart();
    // Navigate to order confirmation screen
    Navigator.pushNamed(context, '/order_confirmation');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Total: \$$_total'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Process payment
                _processPayment();
              },
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
