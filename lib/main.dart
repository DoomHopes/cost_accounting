import 'package:cost_accounting/presentation/core/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cost Accounting',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const TransactionPage(),
    );
  }
}
