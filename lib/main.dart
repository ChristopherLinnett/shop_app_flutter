import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart.dart';

import 'package:shop_app_flutter/screens/product_detail.dart';
import 'package:shop_app_flutter/screens/products_overview.dart';
import 'package:shop_app_flutter/providers/products_provider.dart';
import 'package:shop_app_flutter/screens/shopping_cart.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(
          create: (context) => ShoppingCart(),
        )
      ],
      child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.indigo,
            ),
            fontFamily: 'Lato',
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
          ),
          initialRoute: ProductsOverviewScreen.routeName,
          routes: {
            ProductsOverviewScreen.routeName: (context) =>
                const ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            ShoppingCartScreen.routeName: (context) =>
                const ShoppingCartScreen(),
          }),
    );
  }
}
