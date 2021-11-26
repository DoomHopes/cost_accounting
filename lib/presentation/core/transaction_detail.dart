import 'package:cost_accounting/application/core/transaction_notifier.dart';
import 'package:cost_accounting/domain/transactions/transaction_model.dart';
import 'package:cost_accounting/presentation/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final transactionNotifier =
    ChangeNotifierProvider((ref) => TransactionNotifier());

class TransactionDetail extends StatefulWidget {
  final TransactionModel transactionModel;

  const TransactionDetail({Key? key, required this.transactionModel})
      : super(key: key);

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _titleController.text = widget.transactionModel.title;
    _amountController.text = widget.transactionModel.amount;
    super.initState();
  }

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
        title: Text(widget.transactionModel.title),
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          consumerNotifier
                              .deleteTransaction(widget.transactionModel.id);

                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_titleController.text.isEmpty ||
                              _amountController.text.isEmpty) {
                            return;
                          }

                          final transactionModel = TransactionModel(
                              id: widget.transactionModel.id,
                              title: _titleController.text,
                              amount: _amountController.text,
                              date: _selectedDate.millisecondsSinceEpoch
                                  .toString());

                          consumerNotifier.updateTransaction(transactionModel);

                          Navigator.of(context).pop();
                        },
                        child: const Text('Change'),
                      ),
                    ],
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
