import 'package:cost_accounting/application/core/transaction_notifier.dart';
import 'package:cost_accounting/presentation/core/transaction_detail.dart';
import 'package:cost_accounting/presentation/core/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
          consumerNotifier.fetchTransactionList();
          return consumerNotifier.transactionsList.isEmpty
              ? const Center(
                  child: Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: consumerNotifier.transactionsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final addedDT = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(
                            consumerNotifier.transactionsList[index].date));
                    final formattedAddedDT =
                        DateFormat('dd MMMM yyyy').format(addedDT);
                    return ListTile(
                      title: Text(
                        consumerNotifier.transactionsList[index].title +
                            ' - ' +
                            consumerNotifier.transactionsList[index].amount +
                            ' \$',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        formattedAddedDT,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          //todo переход на страницу редакции
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionDetail(
                                transactionModel:
                                    consumerNotifier.transactionsList[index],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
