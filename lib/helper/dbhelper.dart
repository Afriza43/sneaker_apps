import 'package:sneaker_apps/models/Cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DBHelper {
  static DBHelper? _dbHelper;
  static Database? _database;

  DBHelper._createObject();

  factory DBHelper() {
    if (_dbHelper == null) {
      _dbHelper = DBHelper._createObject();
    }
    return _dbHelper!;
  }

  Future<Database> initDb() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'sneaker.db';
    var sneakerDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return sneakerDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sneaker (
        id TEXT PRIMARY KEY,
        nama TEXT,
        harga TEXT,
        gambar TEXT,
        tipe TEXT,
        deskripsi TEXT,
        jumlah INTEGER
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database!;
  }

  Future<List<Map<String, dynamic>>> selectkeranjang() async {
    Database db = await this.database;
    var mapList = await db.query('sneaker');
    return mapList;
  }

  Future<List<Cart>> getCart() async {
    var mapList = await selectkeranjang();
    int count = mapList.length;
    List<Cart> list = [];
    for (int i = 0; i < count; i++) {
      list.add(Cart.fromMap(mapList[i]));
    }
    return list;
  }
}
