class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final int userId;
  final String imageUrl; 

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.userId,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'userId': userId,
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'] ?? 'Produto sem nome',
      description: map['description'] ?? 'Sem descrição',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      category: map['category'] ?? 'Sem categoria',
      userId: map['userId'],
      imageUrl: map['imageUrl'] ?? 'assets/product_placeholder.png', 
    );
  }
}
