import 'package:sembast_web/sembast_web.dart';

/// A very small adapter that provides a subset of the sqflite `Database`
/// operations used by the app: insert, query, update, delete, close.
/// This is intended only as a web fallback so the rest of the code can
/// continue calling the same methods (duck-typed).
class WebDatabase {
  final DatabaseFactory _factory = databaseFactoryWeb;
  Database? _db;

  final String dbName;

  WebDatabase(this.dbName);

  Future<void> _ensureOpen() async {
    if (_db != null) return;
    _db = await _factory.openDatabase(dbName);
  }

  Future<int> insert(String table, Map<String, Object?> values) async {
    await _ensureOpen();
    final store = intMapStoreFactory.store(table);
    // Remove any id passed in values — sembast generates its own key
    final copy = Map<String, Object?>.from(values);
    copy.remove('id');
    final key = await store.add(_db!, copy);
    return key;
  }

  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    int? limit,
  }) async {
    await _ensureOpen();
    final store = intMapStoreFactory.store(table);
    final records = await store.find(_db!);
    final results = <Map<String, Object?>>[];

    for (final r in records) {
      final map = Map<String, Object?>.from(r.value);
      map['id'] = r.key;

      // Simple equality where clause support: "field = ?"
      if (where != null && whereArgs != null && whereArgs.isNotEmpty) {
        // Support simple equality and simple AND combinations like
        // "userId = ? AND isPrimary = 1". We'll test for "AND" and
        // evaluate multiple equality predicates where possible.
        final whereUpper = where.toUpperCase();
        if (whereUpper.contains('AND')) {
          final parts = where.split(RegExp(r'AND', caseSensitive: false));
          var match = true;
          var argIndex = 0;
          for (final p in parts) {
            final eqIndex = p.indexOf('=');
            if (eqIndex <= 0) continue;
            final field = p.substring(0, eqIndex).trim();
            final expected = (argIndex < whereArgs.length)
                ? whereArgs[argIndex]
                : null;
            argIndex++;
            if (expected == null) {
              // If the RHS is a literal like '1' we'll compare against that string
              // Fallback: try to extract literal from the RHS
              final rhs = p.substring(eqIndex + 1).trim();
              final literal = rhs.replaceAll("'", '').replaceAll('"', '');
              if (map[field].toString() != literal) {
                match = false;
                break;
              }
            } else {
              if (map[field] != expected) {
                match = false;
                break;
              }
            }
          }
          if (match) results.add(map);
        } else {
          final eqIndex = where.indexOf('=');
          if (eqIndex > 0) {
            final field = where.substring(0, eqIndex).trim();
            final expected = whereArgs.first;
            if (map[field] == expected) {
              results.add(map);
            }
          } else {
            // If unknown where format, return all
            results.add(map);
          }
        }
      } else {
        results.add(map);
      }

      if (limit != null && results.length >= limit) break;
    }

    return results;
  }

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    await _ensureOpen();
    final store = intMapStoreFactory.store(table);
    final finder = _makeFinder(where, whereArgs);
    final records = await store.find(_db!, finder: finder);
    var count = 0;
    for (final r in records) {
      await store.record(r.key).update(_db!, values);
      count++;
    }
    return count;
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    await _ensureOpen();
    final store = intMapStoreFactory.store(table);
    final finder = _makeFinder(where, whereArgs);
    final deleted = await store.find(_db!, finder: finder);
    for (final r in deleted) {
      await store.record(r.key).delete(_db!);
    }
    return deleted.length;
  }

  Finder? _makeFinder(String? where, List<Object?>? whereArgs) {
    if (where == null || whereArgs == null || whereArgs.isEmpty) return null;
    final eqIndex = where.indexOf('=');
    if (eqIndex <= 0) return null;
    final field = where.substring(0, eqIndex).trim();
    final expected = whereArgs.first;
    return Finder(filter: Filter.equals(field, expected));
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
