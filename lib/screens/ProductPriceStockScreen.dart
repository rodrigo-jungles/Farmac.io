import 'package:flutter/material.dart';

class ProductPriceStockScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductPriceStockScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductPriceStockScreenState createState() => _ProductPriceStockScreenState();
}

class _ProductPriceStockScreenState extends State<ProductPriceStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Definir Preço e Estoque',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildTitle(),
              const SizedBox(height: 20),
              _buildProductSummary(widget.product),
              const SizedBox(height: 20),
              _buildNumberField(
                label: 'Preço Unitário',
                controller: _priceController,
                hint: 'Digite o valor do produto',
                icon: Icons.attach_money,
                validator: _validateRequiredField,
              ),
              const SizedBox(height: 16),
              _buildNumberField(
                label: 'Estoque',
                controller: _stockController,
                hint: 'Digite a quantidade disponível',
                icon: Icons.inventory,
                validator: _validateRequiredField,
              ),
              const SizedBox(height: 30),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Informe o preço e estoque do produto:',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProductSummary(Map<String, dynamic> product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.asset(product['image'], height: 60, width: 60, fit: BoxFit.cover),
        title: Text(
          product['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Modelo: ${product['model']}, Cor: ${product['color']}'),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Envia os dados confirmados
            final price = double.parse(_priceController.text);
            final stock = int.parse(_stockController.text);

            final result = {
              ...widget.product,
              'price': price,
              'stock': stock,
            };

            Navigator.pop(context, result); // Retorna os dados para a tela anterior
          }
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
    );
  }

  String? _validateRequiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }
}
