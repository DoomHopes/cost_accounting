import 'dart:io';

import 'package:cost_accounting/domain/transactions/transaction_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TransactionHelper {
  TransactionHelper._();

  static final TransactionHelper db = TransactionHelper._();

  Database? _database = null;

  final String _tableName =
      'transactions'; // transaction - это ключевое слово языка, поэтому оно не создает... блэт

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'transaction_DB.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, amount TEXT NOT NULL, date TEXT NOT NULL)');
    });
  }

  addTransation(TransactionModel transactionModel) async {
    final db = await database;
    await db.rawInsert(
      'INSERT Into $_tableName (title,amount,date) VALUES (?,?,?);',
      [
        transactionModel.title.toString(),
        transactionModel.amount.toString(),
        transactionModel.date.toString()
      ],
    );
  }

  updateTransaction(TransactionModel transactionModel) async {
    final db = await database;
    //todo update
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    var res = await db.query(_tableName);
    List<TransactionModel> list = res.isNotEmpty
        ? res.map((c) => TransactionModel.fromMap(c)).toList()
        : [];
    return list;
  }

  deleteTransaction(int id) async {
    final db = await database;
    db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete('Delete * from $_tableName;');
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
