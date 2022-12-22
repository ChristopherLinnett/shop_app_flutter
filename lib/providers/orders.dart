import 'package:flutter/foundation.dart';
import 'package:shop_app_flutter/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-shop-app-a0ea3-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    _orders = [];
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];

      extractedData.forEach((orderId, order) {
        var newOrder = OrderItem(
          id: orderId,
          ordertime: DateTime.parse(order['ordertime']),
          amount: order['amount'],
          productList:
              (json.decode(order['productList']) as List<dynamic>).map((order) {
            return CartItem(
                id: orderId,
                title: order['title'],
                price: order['price'],
                quantity: order['quantity']);
          }).toList(),
        );
        loadedOrders.add(newOrder);
      });
      _orders = [...loadedOrders];
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  Future<void> addOrder(
      {required List<CartItem> cartProducts, required double total}) async {
    final url = Uri.parse(
        'https://flutter-shop-app-a0ea3-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    final timeStamp = DateTime.now();
    var response = await http.post(url,
        body: json.encode({
          'amount': total,
          'ordertime': timeStamp.toIso8601String(),
          'productList': json.encode(cartProducts
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price
                  })
              .toList())
        }));
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          ordertime: timeStamp,
          productList: cartProducts),
    );
  }
}
