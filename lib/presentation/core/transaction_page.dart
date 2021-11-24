import 'package:cost_accounting/application/core/transaction_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionNotifier =
    ChangeNotifierProvider((ref) => TransactionNotifier());

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cost Accounting")),
      body: Consumer(
        builder: (context, watch, child) {
          final consumerNotifier = watch.watch(transactionNotifier);
          return ListView.builder(
            itemCount: consumerNotifier.transactionsList.length,
            itemBuilder: (BuildContext context, int index) {
              consumerNotifier.fetchTransactionList();
              return ListTile(
                title: Text(consumerNotifier.transactionsList[index].title),
                subtitle: Text(
                    consumerNotifier.transactionsList[index].date.toString()),
                trailing: Text(consumerNotifier.transactionsList[index].amount),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
