import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/auth.dart';
import 'package:shop_app_flutter/providers/product.dart';
import 'package:shop_app_flutter/screens/product_detail.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.title,
            overflow: TextOverflow.visible,
            style: Theme.of(context)
                .copyWith(
                  textTheme: TextTheme(
                    headline6: TextStyle(color: Colors.white),
                  ),
                )
                .textTheme
                .bodyMedium,
            textAlign: TextAlign.start,
          ),
          trailing: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 0),
            icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_outline),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              var token = Provider.of<Auth>(context, listen: false).token;
              product.toggleFavourite(token: token);
            },
          ),
          // trailing: IconButton(
          //   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          //   icon: const Icon(Icons.shopping_cart),
          //   color: Theme.of(context).colorScheme.secondary,
          //   onPressed: () {
          //     cart.addItem(
          //         productId: product.id,
          //         price: product.price,
          //         title: product.title);
          //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(
          //         elevation: 3,
          //         backgroundColor: Theme.of(context).colorScheme.primary,
          //         content: Text('Added ${product.title} to cart',
          //             style: Theme.of(context)
          //                 .copyWith(
          //                   textTheme: TextTheme(
          //                     headline6:
          //                         TextStyle(color: Colors.white, fontSize: 20),
          //                   ),
          //                 )
          //                 .textTheme
          //                 .headline6),
          //         action: SnackBarAction(
          //           label: 'UNDO',
          //           textColor: Colors.red,
          //           onPressed: () {
          //             cart.removeSingleItem(product.id);
          //           },
          //         ),
          //   //   //   //   duration: Duration(seconds: 3),
          //   //   //   // ),
          //   //   // );
          //   // },
          // ),
          backgroundColor: Colors.black87,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: CachedNetworkImage(
            imageUrl: product.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }
}
