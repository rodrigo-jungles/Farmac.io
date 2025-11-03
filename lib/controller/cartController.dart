import 'package:farmacio_app/helper/databaseHelper.dart';
import 'package:farmacio_app/models/productModel.dart';
import 'package:get/get.dart';
// Keep sqflite_common_ffi out of web flow; database is dynamic and the
// implementation will be chosen at runtime.

class CartController extends GetxController {
  Future<dynamic> get database async {
    return await DatabaseHelper.instance.database;
  }

  Future<int> addProductToCart(int productId) async {
    final db = await database;
    return await db.insert('cart', {'productId': productId});
  }

  Future<int> removeProductFromCart(int productId) async {
    final db = await database;
    return await db.delete(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }

  Future<List<Product>> getCart() async {
    final db = await database;
    // Use a portable approach: read cart rows then fetch products by id.
    final cartRows = await db.query('cart');
    final List<Product> products = [];
    for (final c in cartRows) {
      final pid = c['productId'];
      final prodRows = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [pid],
      );
      if (prodRows.isNotEmpty) {
        products.add(Product.fromMap(prodRows.first));
      }
    }
    return products;
  }
}
