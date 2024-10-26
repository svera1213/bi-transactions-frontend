import 'package:bi_transactions_frontend/main_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[200],
          appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey[100])),
      routerConfig: mainRouter,
    );
  }
}
