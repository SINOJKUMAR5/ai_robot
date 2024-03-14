import 'package:ai_robot/bot.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyMaterialApp());
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade400,
          primaryColor: Color.fromARGB(255, 124, 64, 221)),
      home: const bot(),
    );
  }
}
