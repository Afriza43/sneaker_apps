import 'package:sneaker_apps/models/HistoryModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class HistoryDBHelper {
  static HistoryDBHelper? _historyDBHelper;
  static Database? _historyDatabase;

  HistoryDBHelper._createObject();

  factory HistoryDBHelper() {
    if (_historyDBHelper == null) {
      _historyDBHelper = HistoryDBHelper._createObject();
    }
    return _historyDBHelper!;
  }

  Future<Database> initHistoryDb() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'riwayat_bayar.db';
    var historyDatabase =
        await openDatabase(path, version: 1, onCreate: _createHistoryDb);
    return historyDatabase;
  }

  void _createHistoryDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE riwayat_bayar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        subtotal INTEGER,
        gambar TEXT,
        quantity INTEGER,
        purchaseTime TEXT
      )
    ''');
  }

  Future<Database> get historyDatabase async {
    if (_historyDatabase == null) {
      _historyDatabase = await initHistoryDb();
    }
    return _historyDatabase!;
  }

  Future<List<Map<String, dynamic>>> selectPurchaseHistory() async {
    Database db = await historyDatabase;
    var mapList = await db.query('riwayat_bayar');
    return mapList;
  }

  Future<List<History>> getHistory() async {
    var mapList = await selectPurchaseHistory();
    int count = mapList.length;
    List<History> list = [];
    for (int i = 0; i < count; i++) {
      list.add(History.fromMap(mapList[i]));
    }
    return list;
  }
}
