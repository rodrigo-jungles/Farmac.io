import 'package:farmacio_app/helper/databaseHelper.dart';
import 'package:farmacio_app/models/productModel.dart';
import 'package:get/get.dart';
// ProductController uses a dynamic database (sqflite on native or a
// sembast-based adapter on web). We avoid importing sqflite here so the
// analyzer won't complain on web.

class ProductController extends GetxController {
  Future<dynamic> get database async {
    return await DatabaseHelper.instance.database;
  }

  Future<int> addProduct(Product product) async {
    final db = await database;

    try {
      final int id = await db.insert('products', product.toMap());
      print("✅ Produto inserido com sucesso: ${product.toMap()}");
      return id;
    } catch (e) {
      print("❌ Erro ao inserir produto: $e");
      return -1;
    }
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }
}
