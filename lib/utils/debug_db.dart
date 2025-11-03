import 'package:flutter/foundation.dart' show kDebugMode;
import '../helper/databaseHelper.dart';

/// Funções de debug para inspecionar o banco local em tempo de execução.
/// Use apenas em desenvolvimento.
Future<void> printUserByEmail(String email) async {
  if (!kDebugMode) return;
  try {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    // Imprime o conteúdo encontrado (pode incluir o hash da senha)
    // Use o console do Flutter (stdout) para visualizar.
    // ignore: avoid_print
    print('DEBUG: usuários encontrados para $email: $rows');
  } catch (e, st) {
    // ignore: avoid_print
    print('DEBUG: erro ao consultar users: $e\n$st');
  }
}
