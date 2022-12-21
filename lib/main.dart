import 'package:flutter/material.dart';
import 'package:shop_app_flutter/screens/product_detail.dart';
import 'package:shop_app_flutter/screens/products_overview.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.red,
                primaryColorDark: Colors.deepPurple,
                errorColor: Colors.deepPurple,
                backgroundColor: Colors.black,
                accentColor: Colors.redAccent),
            fontFamily: 'Lato',
            textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white))),
        initialRoute: ProductsOverviewScreen.routeName,
        routes: {
          ProductsOverviewScreen.routeName: (context) =>
              ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        });
  }
}
