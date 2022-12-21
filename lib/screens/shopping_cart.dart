import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart.dart';
import 'package:shop_app_flutter/widgets/cart_item.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});
  static const routeName = '/shopping-cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<ShoppingCart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.cartTotal}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.contents.length,
              itemBuilder: (context, i) => CartScreenItem(
                  id: cart.contents.values.toList()[i].id,
                  price: cart.contents.values.toList()[i].price,
                  quantity: cart.contents.values.toList()[i].quantity,
                  title: cart.contents.values.toList()[i].title),
            ),
          )
        ],
      ),
    );
  }
}
