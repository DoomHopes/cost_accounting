import 'package:cost_accounting/application/core/transaction_notifier.dart';
import 'package:cost_accounting/domain/transactions/transaction_model.dart';
import 'package:cost_accounting/presentation/widgets/input_widget.dart';
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
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        setState(() {
          _selectedDate = DateTime.now();
        });
      }
      setState(() {
        _selectedDate = pickedDate!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add transaction'),
      ),
      body: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              InputWidget(
                controller: _titleController,
                keyboardType: TextInputType.text,
                labelDecoration: 'Title',
              ),
              InputWidget(
                controller: _amountController,
                keyboardType: TextInputType.number,
                labelDecoration: 'Amount',
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    ElevatedButton(
                      child: const Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, watch, child) {
                  final consumerNotifier = watch.watch(transactionNotifier);
                  return ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isEmpty ||
                          _amountController.text.isEmpty) {
                        return;
                      }

                      final transactionModel = TransactionModel(
                          id: consumerNotifier.transactionsList.isEmpty
                              ? 1
                              : consumerNotifier.transactionsList.last.id + 1,
                          title: _titleController.text,
                          amount: _amountController.text,
                          date:
                              _selectedDate.millisecondsSinceEpoch.toString());

                      consumerNotifier.addTransaction(transactionModel);

                      Navigator.of(context).pop();
                    },
                    child: const Text('Add Transaction'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
