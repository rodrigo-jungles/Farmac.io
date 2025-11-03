import 'package:farmacio_app/helper/databaseHelper.dart';
import 'package:farmacio_app/models/adressModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Adresscontroller extends GetxController {
  Future<dynamic> get database async {
    return await DatabaseHelper.instance.database;
  }

  Future<List<Address>> getAddressesByUserId(int userId) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'addresses',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    print("🔍 Buscando endereços para o userId: $userId...");
    print("📝 Dados retornados do banco: $maps");

    return maps.map((map) => Address.fromMap(map)).toList();
  }

  Future<Address?> getAddressById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'addresses',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Address.fromMap(result.first);
    }
    return null;
  }

  Future<int> insertAddress(Address address) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('addresses', {
      'userId': address.userId,
      'street': address.street,
      'number': address.number,
      'complement': address.complement!.isNotEmpty ? address.complement : '',
      'city': address.city,
      'state': address.state,
      'zipCode': address.zipCode,
      'bairro': address.bairro,
      'telefone': address.telefone,
      'horario': address.horario!.isNotEmpty ? address.horario : '',
      'observacao': address.observacao!.isNotEmpty ? address.observacao : '',
    });

    print("✅ Novo endereço inserido com ID: $id");
    return id;
  }

  Future<int> updateAddress(Address address) async {
    final db = await database;
    return await db.update(
      'addresses',
      address.toMap(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  Future<int> deleteAddress(int id) async {
    final db = await database;
    return await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> setPrimaryAddress(int addressId, int userId) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'addresses',
      {'isPrimary': 0},
      where: 'userId = ?',
      whereArgs: [userId],
    );
    await db.update(
      'addresses',
      {'isPrimary': 1},
      where: 'id = ?',
      whereArgs: [addressId],
    );
  }

  Future<Address?> getPrimaryAddress(int userId) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      'addresses',
      where: 'userId = ? AND isPrimary = 1',
      whereArgs: [userId],
      limit: 1,
    );
    if (result.isNotEmpty) {
      print("🏠 Endereço Principal Encontrado: ${result.first}");
      return Address.fromMap(result.first);
    }
    print("⚠️ Nenhum endereço principal encontrado para userId: $userId");
    SnackBar(content: Text('Erro: Usuário não definiu um endereço principal'));
    return null;
  }
}
