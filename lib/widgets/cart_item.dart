import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart.dart';

class CartScreenItem extends StatelessWidget {
  final String id;
  final double price;
  final String title;
  final int quantity;
  final Key uniqueKey = UniqueKey();
  CartScreenItem(
      {super.key,
      required this.id,
      required this.price,
      required this.title,
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: uniqueKey,
      confirmDismiss: ((direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
              title: Text('Are You Sure?'),
              content: Text(
                'Do you want to remove ${title.toUpperCase()} from the cart?',
              ),
              actions: [
                TextButton(
                  child: Text('Yes',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.pop(context, true),
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ]),
        );
      }),
      background: Container(
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 40)),
      onDismissed: (_) {
        Provider.of<ShoppingCart>(context, listen: false).removeItem(id);
      },
      direction: DismissDirection.endToStart,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 40,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FittedBox(
                  child: Text('\$$price',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing:
                Text('x$quantity', style: const TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
