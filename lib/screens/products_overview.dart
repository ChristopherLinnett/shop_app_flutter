import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart.dart';
import 'package:shop_app_flutter/widgets/badge.dart';
import 'package:shop_app_flutter/widgets/product_grid.dart';
import '../dummyproducts.dart';

import 'package:shop_app_flutter/providers/product.dart';

enum FavouriteOptions { favourites, all }

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = 'ProductsOverviewScreen';
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final List<Product> loadedProducts = [...dummyProductList];
  bool showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyCoolShop'), actions: [
        PopupMenuButton(
          position: PopupMenuPosition.under,
          icon: const Icon(Icons.more_vert),
          onSelected: (FavouriteOptions selectedValue) {
            setState(() {
              showOnlyFavourites =
                  selectedValue == FavouriteOptions.favourites ? true : false;
            });
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
                value: FavouriteOptions.favourites,
                child: Text('Only Favourites')),
            const PopupMenuItem(
                value: FavouriteOptions.all, child: Text('Show All'))
          ],
        ),
        Consumer<ShoppingCart>(
          builder: (ctx, cart, ch) =>
              Badge(value: cart.itemCount.toString(), child: ch!),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ),
      ]),
      body: ProductGrid(favouritesOnly: showOnlyFavourites),
    );
  }
}
