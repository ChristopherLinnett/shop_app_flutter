import 'package:flutter/foundation.dart';
import 'package:shop_app_flutter/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> productList;
  final DateTime ordertime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.productList,
      required this.ordertime});
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder({required List<CartItem> cartProducts, required double total}) {
    _orders.insert(
      0,
      OrderItem(
          id: UniqueKey().toString(),
          amount: total,
          ordertime: DateTime.now(),
          productList: cartProducts),
    );
  }
}
