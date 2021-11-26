import 'package:cost_accounting/application/core/transaction_notifier.dart';
import 'package:cost_accounting/domain/transactions/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'input_widget.dart';

final transactionNotifier =
    ChangeNotifierProvider((ref) => TransactionNotifier());

class AddTransactionDialogWidget extends StatefulWidget {
  const AddTransactionDialogWidget({Key? key}) : super(key: key);

  @override
  State<AddTransactionDialogWidget> createState() =>
      _AddTransactionDialogWidgetState();
}

class _AddTransactionDialogWidgetState
    extends State<AddTransactionDialogWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController();
    final _amountController = TextEditingController();
    DateTime _selectedDate = DateTime.now();

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Add transaction',
                style: TextStyle(fontSize: 20),
              ),
              Consumer(
                builder: (context, watch, child) {
                  final consumerNotifier = watch.watch(transactionNotifier);
                  return TextButton(
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
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Date: ${DateFormat.yMMMMd().format(_selectedDate)}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
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
                        },
                        icon:
                            const Icon(Icons.calendar_today_outlined, size: 20),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
