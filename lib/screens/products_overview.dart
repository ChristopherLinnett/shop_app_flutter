import 'package:flutter/material.dart';
import 'package:shop_app_flutter/widgets/product_grid.dart';
import '../dummyproducts.dart';

import 'package:shop_app_flutter/providers/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const String routeName = 'ProductsOverviewScreen';

  ProductsOverviewScreen({super.key});
  final List<Product> loadedProducts = [...dummyProductList];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyCoolShop'),
      ),
      body: const ProductGrid(),
    );
  }
}
