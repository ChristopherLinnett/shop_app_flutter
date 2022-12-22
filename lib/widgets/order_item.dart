import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app_flutter/providers/orders.dart';

class OrderItemTile extends StatefulWidget {
  const OrderItemTile({super.key, required this.orderItem});
  final OrderItem orderItem;

  @override
  State<OrderItemTile> createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(
              DateFormat('EEEEE dd MMMM yyyy hh:mm a')
                  .format(widget.orderItem.ordertime),
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.orderItem.productList.length * 20 + 30, 150),
              child: ListView.builder(
                itemCount: widget.orderItem.productList.length,
                itemBuilder: (context, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.orderItem.productList[i].title,
                        style: Theme.of(context)
                            .copyWith(
                              textTheme: TextTheme(
                                titleLarge: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                            )
                            .textTheme
                            .titleLarge),
                    Text(
                        'x${widget.orderItem.productList[i].quantity}  @ \$${widget.orderItem.productList[i].price}ea',
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
