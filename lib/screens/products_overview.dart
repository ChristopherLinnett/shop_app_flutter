import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart.dart';
import 'package:shop_app_flutter/providers/products_provider.dart';
import 'package:shop_app_flutter/screens/shopping_cart.dart';
import 'package:shop_app_flutter/widgets/app_drawer.dart';
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
  var _isInit = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      return;
    }
    _isInit = true;
    _isLoading = true;
    Provider.of<Products>(context, listen: false).fetchProducts(filterByUser: false).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('MyCoolShop'), actions: [
          Consumer<ShoppingCart>(
            builder: (ctx, cart, ch) =>
                Badge(value: cart.itemCount.toString(), child: ch!),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
              },
            ),
          ),
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
        ]),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : ProductGrid(favouritesOnly: showOnlyFavourites),
        drawer: const AppDrawer());
  }
}
