import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/products_provider.dart';
import 'package:shop_app_flutter/screens/edit_product.dart';

class UserProductItemTile extends StatelessWidget {
  const UserProductItemTile(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.id});
  final String title;
  final String id;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                }),
            IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  } catch (error) {
                    scaffoldMessenger.hideCurrentSnackBar();
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to Delete Product',
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
