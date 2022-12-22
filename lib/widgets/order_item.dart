import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app_flutter/providers/orders.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({super.key, required this.orderItem});
  final OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
              title: Text('\$${orderItem.amount}'),
              subtitle: Text(
                DateFormat('dd MMM yy : hh:mm').format(orderItem.ordertime),
              ),
              trailing: IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () {},
              )),
        ],
      ),
    );
  }
}
