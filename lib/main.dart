import 'package:flutter/material.dart';
import 'package:flutter_finance_app_ui/data/models/add_data.dart';
import 'package:flutter_finance_app_ui/widgets/bottomnavigationbar.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Hive Configure
  await Hive.initFlutter();
  Hive.registerAdapter(AddDataAdapter());
  await Hive.openBox<AddData>('data');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Finance App UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BottomNavBar(),
    );
  }
}
