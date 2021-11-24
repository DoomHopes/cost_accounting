import 'package:flutter/material.dart';

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
      home: const Scaffold(
        body: Center(child: Text('Bite my shiny metal ass!')),
      ),
    );
  }
}
