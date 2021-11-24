import 'package:cost_accounting/domain/transaction/transaction_model.dart';
import 'package:cost_accounting/infrastructures/transaction/transaction_helper.dart';
import 'package:flutter/cupertino.dart';

class TransactionNotifier extends ChangeNotifier {
  List<TransactionModel> transactionsList = [];
  final _db = TransactionHelper.db;

  Future<void> fetchTransactionList() async {
    transactionsList = await _db.getTransactions();
    notifyListeners();
  }

  void addTransaction(TransactionModel transactionModel) {
    _db.addTransation(transactionModel);
  }

  void deleteTransaction(int id) {
    _db.deleteTransaction(id);
  }

  void deleteAll() {
    _db.deleteAll();
  }

  void close() {
    _db.close();
  }
}
