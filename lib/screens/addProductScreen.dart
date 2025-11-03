import 'package:farmacio_app/controller/authController.dart';
import 'package:farmacio_app/controller/productController.dart';
import 'package:farmacio_app/models/productModel.dart';
import 'package:farmacio_app/models/userModel.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _description = '';
  String _category = '';
  double _price = 0.0;
  int _stock = 0;
  String _imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text(
          'Adicionar Produto',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: 'Nome do Produto',
                  onSaved: (value) => _name = value!,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor, insira o nome do produto'
                      : null,
                ),
                _buildTextField(
                  label: 'Descrição',
                  onSaved: (value) => _description = value!,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor, insira a descrição'
                      : null,
                ),
                _buildTextField(
                  label: 'Categoria',
                  onSaved: (value) => _category = value!,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor, insira a categoria'
                      : null,
                ),
                _buildTextField(
                  label: 'Preço',
                  inputType: TextInputType.number,
                  onSaved: (value) => _price = double.parse(value!),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor, insira o preço'
                      : null,
                ),
                _buildTextField(
                  label: 'Estoque',
                  inputType: TextInputType.number,
                  onSaved: (value) => _stock = int.parse(value!),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor, insira o estoque'
                      : null,
                ),
                _buildTextField(
                  label: 'URL da Imagem',
                  onSaved: (value) => _imageUrl = value!,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor, insira ao menos uma URL de imagem'
                      : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _validateAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Adicionar Produto',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String?) onSaved,
    String? Function(String?)? validator,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        keyboardType: inputType,
        onSaved: onSaved,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _addProduct();
    }
  }

  Future<void> _addProduct() async {
    final productController = ProductController();

    // Recuperar o userId da sessão
    final authController = AuthController();
    UserModel? user = await authController.getUserFromSession();

    if (user == null || user.id == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Usuário não autenticado')),
      );
      return;
    }

    final product = Product(
      id: 0,
      name: _name,
      description: _description,
      category: _category,
      userId: user.id ?? 0,
      stock: _stock,
      price: _price,
      imageUrl: _imageUrl,
    );

    try {
      await productController.addProduct(product);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto adicionado com sucesso!')),
      );
      Navigator.pushNamed(context, '/products');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao adicionar produto: $e')));
    }
  }
}
