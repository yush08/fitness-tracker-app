import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData.light(),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Fitness App',
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }
}