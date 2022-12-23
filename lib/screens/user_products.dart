import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/products_provider.dart';
import 'package:shop_app_flutter/screens/edit_product.dart';
import 'package:shop_app_flutter/widgets/app_drawer.dart';
import 'package:shop_app_flutter/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routeName = 'UserProductsScreen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator.adaptive())
            : RefreshIndicator(
                onRefresh: () {
                  return _refreshProducts(context);
                },
                child: Consumer<Products>(
                  builder: ((ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, index) => Column(
                            children: [
                              UserProductItemTile(
                                title: productsData.items[index].title,
                                imageUrl: productsData.items[index].imageUrl,
                                id: productsData.items[index].id,
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
