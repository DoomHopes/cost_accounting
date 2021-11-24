import 'package:cost_accounting/application/core/transaction_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final transactionNotifier =
    ChangeNotifierProvider((ref) => TransactionNotifier());

class TransactionForm extends StatefulWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
