import 'package:farmacio_app/helper/databaseHelper.dart';
import 'package:farmacio_app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class UserController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  // Getter para acessar o banco de dados
  Future<dynamic> get _database async {
    return await DatabaseHelper.instance.database;
  }

  // Inserir um novo usuário no banco de dados
  Future<int> insertUser(
    String name,
    String email,
    String lastname,
    String password,
    String number,
  ) async {
    final db = await DatabaseHelper.instance.database;

    try {
      return await db.insert('users', {
        'name': name,
        'lastname': lastname,
        'email': email,
        'password': password,
        'number': number,
      });
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError('users.email')) {
        throw Exception('Email already registered');
      } else {
        rethrow; // Lança outras exceções
      }
    }
  }

  static Future<UserModel?> getUserById(int id) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      return null; // Caso não encontre o usuário
    }
  }

  // Atualizar um usuário existente
  static Future<bool> updateUser(UserModel user) async {
    try {
      final db = await DatabaseHelper.instance.database;
      print("🔄 Chamando updateUser() para o usuário ID: ${user.id}");
      print("📧 Atualizando e-mail: ${user.email}");
      print(
        "🔑 Atualizando senha: ${user.password != null ? 'Alterada' : 'Não alterada'}",
      );

      final rowsUpdated = await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      print("🔄 Linhas atualizadas: $rowsUpdated");
      return rowsUpdated > 0;
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      return false;
    }
  }

  Future<bool> updateUserAvatar(UserModel user) async {
    try {
      final db = await _database;
      final rowsUpdated = await db.update(
        'users',
        {'avatarUrl': user.avatarUrl},
        where: 'id = ?',
        whereArgs: [user.id],
      );
      print("✅ Avatar atualizado no banco!");
      return rowsUpdated > 0;
    } catch (e) {
      print('❌ Erro ao atualizar avatar no banco: $e');
      return false;
    }
  }

  // Deletar um usuário pelo ID
  Future<int> deleteUser(int id) async {
    final db = await _database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
