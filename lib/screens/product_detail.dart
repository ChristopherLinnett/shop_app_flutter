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
        appBar: AppBar(title: Text(product.title), actions: [
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
        ]),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text('\$${product.price}',
                  style: Theme.of(context).textTheme.headline3),
              const SizedBox(height: 20),
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
              ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Add to Cart'),
                    Icon(
                      Icons.add_shopping_cart,
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
            ],
          ),
        ));
  }
}
