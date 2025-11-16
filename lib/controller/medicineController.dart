import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart' as sembast_io;
import 'package:sembast_web/sembast_web.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineController extends GetxController {
  // cada remédio: {name, price, mg, indications(List<String>), requiresPrescription(bool), image(String?)}
  final RxList<Map<String, dynamic>> medicines = <Map<String, dynamic>>[].obs;
  // produtos gerais: {name, price, description, image}
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;

  Future<void> addMedicine(Map<String, dynamic> m) async {
    medicines.add(m);
    await _saveMedicinesToDb();
    // debug
    print(
      'MedicineController: adicionou remédio "${m['name']}". Total agora: ${medicines.length}',
    );
  }

  Future<void> addProduct(Map<String, dynamic> p) async {
    products.add(p);
    await _saveProductsToDb();
    print(
      'MedicineController: adicionou produto "${p['name']}". Total agora: ${products.length}',
    );
  }

  static const String _kMedsKey = 'medicine_controller_medicines_v1';
  static const String _kProductsKey = 'medicine_controller_products_v1';

  // Sembast DB
  Database? _db;
  final _medStore = intMapStoreFactory.store('medicines');
  final _prodStore = intMapStoreFactory.store('products');
  static const String _dbName = 'farmacio.db';

  @override
  void onInit() {
    super.onInit();
    _initDbAndLoad();
  }

  Future<void> _initDbAndLoad() async {
    try {
      // open DB (web or io)
      if (kIsWeb) {
        _db = await databaseFactoryWeb.openDatabase(_dbName);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final dbPath = p.join(dir.path, _dbName);
        print('MedicineController: DB path will be $dbPath');
        _db = await sembast_io.databaseFactoryIo.openDatabase(dbPath);
      }

      print('MedicineController: DB aberto. kIsWeb=$kIsWeb');

      // migrate from SharedPreferences if present
      try {
        final prefs = await SharedPreferences.getInstance();
        final medsStr = prefs.getString(_kMedsKey);
        if (medsStr != null && medsStr.isNotEmpty) {
          print(
            'MedicineController: encontradas ${medsStr.length} chars em prefs for meds',
          );
          final List<dynamic> data = jsonDecode(medsStr);
          print(
            'MedicineController: migrando ${data.length} remédios de SharedPreferences para Sembast',
          );
          // clear store then add
          await _medStore.delete(_db!);
          int i = 0;
          for (final e in data) {
            await _medStore.add(_db!, Map<String, dynamic>.from(e as Map));
            i++;
          }
          print('MedicineController: migrados $i remédios para o DB');
          await prefs.remove(_kMedsKey);
        }

        final prodsStr = prefs.getString(_kProductsKey);
        if (prodsStr != null && prodsStr.isNotEmpty) {
          print('MedicineController: migrando produtos de prefs para Sembast');
          final List<dynamic> pdata = jsonDecode(prodsStr);
          await _prodStore.delete(_db!);
          int j = 0;
          for (final e in pdata) {
            await _prodStore.add(_db!, Map<String, dynamic>.from(e as Map));
            j++;
          }
          print('MedicineController: migrados $j produtos para o DB');
          await prefs.remove(_kProductsKey);
        }
      } catch (e) {
        // ignore prefs errors
      }

      // load from DB
      final medSnapshots = await _medStore.find(_db!);
      medicines.assignAll(
        medSnapshots.map((s) => Map<String, dynamic>.from(s.value)).toList(),
      );

      print('MedicineController: carregou ${medicines.length} remédios do DB.');

      final prodSnapshots = await _prodStore.find(_db!);
      products.assignAll(
        prodSnapshots.map((s) => Map<String, dynamic>.from(s.value)).toList(),
      );
      print('MedicineController: carregou ${products.length} produtos do DB.');
    } catch (e) {
      print('MedicineController: erro ao inicializar DB: $e');
    }
  }

  Future<void> _saveMedicinesToDb() async {
    if (_db == null) return;
    try {
      await _medStore.delete(_db!);
      for (final m in medicines) {
        await _medStore.add(_db!, Map<String, dynamic>.from(m));
      }
    } catch (e) {
      print('MedicineController: erro ao salvar medicines no DB: $e');
    }
  }

  Future<void> _saveProductsToDb() async {
    if (_db == null) return;
    try {
      await _prodStore.delete(_db!);
      for (final pitem in products) {
        await _prodStore.add(_db!, Map<String, dynamic>.from(pitem));
      }
    } catch (e) {
      print('MedicineController: erro ao salvar products no DB: $e');
    }
  }

  /// Retorna lista de remédios recomendados com base no texto de sintomas.
  /// A recomendação é feita por interseção entre palavras-chave encontradas no texto
  /// e as indicações dos remédios. Retorna lista ordenada por maior número de matches.
  List<Map<String, dynamic>> recommendForText(String text) {
    final s = text.toLowerCase();
    List<Map<String, dynamic>> scored = [];
    for (final m in medicines) {
      final List<dynamic> inds = m['indications'] ?? [];
      int score = 0;
      for (final ind in inds) {
        final key = ind.toString().toLowerCase();
        if (key.isEmpty) continue;
        if (s.contains(key)) score += 1;
      }
      if (score > 0) {
        final copy = Map<String, dynamic>.from(m);
        copy['score'] = score;
        scored.add(copy);
      }
    }
    scored.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    return scored;
  }
}
