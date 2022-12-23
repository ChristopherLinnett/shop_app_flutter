import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/orders.dart';
import 'package:shop_app_flutter/widgets/app_drawer.dart';
import 'package:shop_app_flutter/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, index) =>
                  OrderItemTile(orderItem: orderData.orders[index]),
            ),
      drawer: const AppDrawer(),
    );
  }
}
