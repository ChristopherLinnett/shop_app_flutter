import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart.dart';
import 'package:shop_app_flutter/providers/products_provider.dart';
import 'package:shop_app_flutter/screens/shopping_cart.dart';
import 'package:shop_app_flutter/widgets/badge.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/ProductDetailScreen';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(title: Text(product.title), actions: [
      //   Consumer<ShoppingCart>(
      //     builder: (ctx, cart, ch) =>
      //         Badge(value: cart.itemCount.toString(), child: ch!),
      //     child: IconButton(
      //       icon: const Icon(Icons.shopping_cart),
      //       onPressed: () {
      //         Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
      //       },
      //     ),
      //   ),
      // ]),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: EdgeInsets.all(6),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                child: Text(product.title),
              ),
              background: Hero(
                tag: productId,
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(200, 75))),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Add to Cart',
                            style: Theme.of(context)
                                .copyWith(
                                    textTheme: TextTheme(
                                        headline5: TextStyle(
                                            color: Colors.white, fontSize: 24)))
                                .textTheme
                                .headline5),
                        Icon(
                          Icons.add_shopping_cart,
                          size: 40,
                        ),
                      ],
                    ),
                    onPressed: () {
                      final cart =
                          Provider.of<ShoppingCart>(context, listen: false);
                      cart.addItem(
                          productId: product.id,
                          price: product.price,
                          title: product.title);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 3,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          content: Text('Added ${product.title} to cart',
                              style: Theme.of(context)
                                  .copyWith(
                                    textTheme: TextTheme(
                                      headline6: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                  .textTheme
                                  .headline6),
                          action: SnackBarAction(
                            label: 'UNDO',
                            textColor: Colors.red,
                            onPressed: () {
                              cart.removeSingleItem(product.id);
                            },
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
        },
        child: Consumer<ShoppingCart>(
          builder: (ctx, cart, ch) =>
              Badge(value: cart.itemCount.toString(), child: ch!),
          child: Icon(Icons.shopping_cart, size: 36),
        ),
      ),
    );
  }
}
