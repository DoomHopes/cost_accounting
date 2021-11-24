import 'package:cost_accounting/domain/transactions/transaction_model.dart';
import 'package:cost_accounting/infrastructure/core/transaction_helper.dart';
import 'package:flutter/cupertino.dart';

class TransactionNotifier extends ChangeNotifier {
  List<TransactionModel> transactionsList = [];
  final _db = TransactionHelper.db;

  Future<void> fetchTransactionList() async {
    transactionsList = await _db.getTransactions();
    notifyListeners();
  }

  void addTransaction(TransactionModel transactionModel) {
    transactionsList.add(transactionModel);
    _db.addTransation(transactionModel);
    notifyListeners();
  }

  void updateTransaction(TransactionModel transactionModel) {
    _db.updateTransaction(transactionModel);

    for (int i = 0; i < transactionsList.length; i++) {
      print(transactionsList[i]);
    }
    fetchTransactionList();
  }

  void deleteTransaction(int id) {
    transactionsList.removeWhere((element) => element.id == id);
    _db.deleteTransaction(id);
    notifyListeners();
  }

  void deleteAll() {
    transactionsList = [];
    _db.deleteAll();
    notifyListeners();
  }

  void close() {
    _db.close();
  }
}
