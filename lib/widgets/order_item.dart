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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded
          ? min(widget.orderItem.productList.length * 30 + 120, 220)
          : 92,
      child: Card(
        margin: const EdgeInsets.all(10),
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height:
                  _isExpanded ? widget.orderItem.productList.length * 30 : 0,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView.builder(
                itemCount: widget.orderItem.productList.length,
                itemBuilder: (context, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.orderItem.productList[i].title,
                        style: Theme.of(context)
                            .copyWith(
                              textTheme: const TextTheme(
                                titleLarge: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                            )
                            .textTheme
                            .titleLarge),
                    Text(
                        'x${widget.orderItem.productList[i].quantity}  @ \$${widget.orderItem.productList[i].price.toStringAsFixed(2)} ea',
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
