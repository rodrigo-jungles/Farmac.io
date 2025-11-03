import 'package:flutter/material.dart';

class SearchProductScreen extends StatefulWidget {
  final String category;

  const SearchProductScreen({Key? key, required this.category}) : super(key: key);

  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allProducts = ['Samsung TV', 'Camiseta Azul', 'Cadeira de Escritório'];
  List<String> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filterProducts();
  }

  void _filterProducts([String? query]) {
    setState(() {
      _filteredProducts = _allProducts
          .where((product) =>
              product.toLowerCase().contains(query?.toLowerCase() ?? '') &&
              product.toLowerCase().contains(widget.category.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Buscar Produtos - ${widget.category}', style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: 'Buscar produto...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? _buildNoResults()
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.shopping_bag, color: Colors.blue),
                        title: Text(_filteredProducts[index]),
                        onTap: () {
                          // Implementar lógica para editar ou visualizar produto
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Nenhum produto encontrado.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add_product', arguments: widget.category);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Cadastrar Novo Produto', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
