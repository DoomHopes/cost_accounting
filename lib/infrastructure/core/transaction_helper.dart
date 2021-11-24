import 'dart:io';

import 'package:cost_accounting/domain/transactions/transaction_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TransactionHelper {
  TransactionHelper._();

  static final TransactionHelper db = TransactionHelper._();

  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TransactionDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Transaction ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "amount TEXT,"
          "date TEXT"
          ")");
    });
  }

  addTransation(TransactionModel transactionModel) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Transaction");
    int id = int.parse(table.first["id"].toString());
    await db.rawInsert(
      "INSERT Into Transaction (id,title,amount,date)"
      " VALUES (?,?,?,?)",
      [
        id,
        transactionModel.title,
        transactionModel.amount,
        transactionModel.date
      ],
    );
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    var res = await db.query("Transaction");
    List<TransactionModel> list = res.isNotEmpty
        ? res.map((c) => TransactionModel.fromMap(c)).toList()
        : [];
    return list;
  }

  deleteTransaction(int id) async {
    final db = await database;
    db.delete("Transaction", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Transaction");
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
