import 'package:sneaker_apps/models/Cart_model.dart';
import 'package:sneaker_apps/models/UserModel.dart';
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
    String path = directory.path + 'toko7.db';
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

    await db.execute('''
      CREATE TABLE akun (
        userName TEXT PRIMARY KEY, 
        userPassword TEXT)
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database!;
  }

  Future<bool> login(Users user) async {
    final Database db = await initDb();

    var result = await db.rawQuery(
        "select * from akun where userName = '${user.userName}' AND userPassword = '${user.userPassword}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAkun(String userName) async {
    Database db = await initDb();
    var akun =
        await db.query("akun", where: 'userName = ?', whereArgs: [userName]);
    return akun;
  }

  Future<int> signUp(Users user) async {
    final Database db = await database;

    return db.insert('akun', user.toMap());
  }

  Future<List<Map<String, dynamic>>> selectkeranjang() async {
    Database db = await database;
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
