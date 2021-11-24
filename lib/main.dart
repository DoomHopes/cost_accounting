import 'package:flutter/material.dart';

import 'presentation/transaction/transaction_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cost Accounting',
      theme: ThemeData.dark(),
      home: const TransactionPage(),
    );
  }
}
