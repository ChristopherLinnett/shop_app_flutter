import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/auth.dart';
import 'package:shop_app_flutter/providers/cart.dart';
import 'package:shop_app_flutter/providers/orders.dart';
import 'package:shop_app_flutter/screens/auth_screen.dart';
import 'package:shop_app_flutter/screens/edit_product.dart';
import 'package:shop_app_flutter/screens/orders_screen.dart';

import 'package:shop_app_flutter/screens/product_detail.dart';
import 'package:shop_app_flutter/screens/products_overview.dart';
import 'package:shop_app_flutter/providers/products_provider.dart';
import 'package:shop_app_flutter/screens/shopping_cart.dart';
import 'package:shop_app_flutter/screens/splash_screen.dart';
import 'package:shop_app_flutter/screens/user_products.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(prevItems: [], token: null),
          update: (ctx, auth, prevProducts) => Products(
              token: auth.token,
              prevItems: prevProducts == null ? [] : prevProducts.items,
              userId: auth.userId),
        ),
        ChangeNotifierProvider(
          create: (context) => ShoppingCart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, auth, prevValue) => Orders(
              token: auth.token,
              prevOrders: prevValue?.orders,
              userId: auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.indigo,
              ),
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              AuthScreen.routeName: (context) => const AuthScreen(),
              ProductsOverviewScreen.routeName: (context) =>
                  const ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              ShoppingCartScreen.routeName: (context) =>
                  const ShoppingCartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
            }),
      ),
    );
  }
}
