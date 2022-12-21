import 'package:flutter/material.dart';
import 'package:shop_app_flutter/widgets/product_item.dart';
import '../dummyproducts.dart';

import 'package:shop_app_flutter/models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  ProductsOverviewScreen({super.key});
  final List<Product> loadedProducts = [...dummyProductList];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MyCoolShop'),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: loadedProducts.length,
          itemBuilder: (ctx, i) => ProductItem(
              id: loadedProducts[i].id,
              title: loadedProducts[i].title,
              imageUrl: loadedProducts[i].imageUrl),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        ));
  }
}
