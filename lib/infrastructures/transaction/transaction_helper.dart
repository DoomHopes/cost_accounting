import 'dart:io';

import 'package:cost_accounting/domain/transaction/transaction_model.dart';
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
          "id TEXT PRIMARY KEY,"
          "title TEXT,"
          "amount TEXT,"
          "date TEXT"
          ")");
    });
  }

  addTransation(TransactionModel transactionModel) async {
    final db = await database;
    db.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Transaction(lastname, mobileno, emailid ) VALUES(' '\'' +
              transactionModel.title +
              '\'' +
              ',' +
              '\'' +
              transactionModel.amount.toString() +
              '\'' +
              ',' +
              '\'' +
              transactionModel.date.toString() +
              '\'' +
              ')');
    });
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    List<Map> list = await db.rawQuery('SELECT * FROM Transaction');
    List<TransactionModel> transactions = [];
    for (int i = 0; i < list.length; i++) {
      transactions.add(TransactionModel(
        id: list[i]["id"],
        title: list[i]["title"],
        amount: list[i]["amount"],
        date: list[i]["date"],
      ));
    }
    print(transactions.length);
    return transactions;
  }

  deleteTransaction(int id) async {
    final db = await database;
    return db.delete("Transaction", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Transaction");
  }

  Future close() async {
    final db = await database;
    await db.close();
  }
}
