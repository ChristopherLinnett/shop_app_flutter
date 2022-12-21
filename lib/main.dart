import 'package:flutter/material.dart';
import 'package:shop_app_flutter/screens/products_overview.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
          colorScheme: const ColorScheme.dark().copyWith(
              primary: const Color.fromARGB(255, 111, 7, 0),
              secondary: Colors.redAccent),
          fontFamily: 'Lato'),
      home: ProductsOverviewScreen(),
    );
  }
}
