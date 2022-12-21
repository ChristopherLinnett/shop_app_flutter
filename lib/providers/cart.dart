import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  int quantity;
  final double price;
  CartItem(
      {required this.id,
      required this.title,
      this.quantity = 1,
      required this.price});
}

class ShoppingCart with ChangeNotifier {
  final Map<String, CartItem> _contents = {};

  Map<String, CartItem> get contents {
    return {..._contents};
  }

  int get itemCount {
    return _contents.length;
  }

  void addItem(
      {required String productId,
      required double price,
      required String title}) {
    if (_contents.containsKey(productId)) {
      _contents.update(
          productId,
          (cartItem) => CartItem(
              id: cartItem.id,
              title: cartItem.title,
              quantity: cartItem.quantity + 1,
              price: cartItem.price));
    } else {
      _contents.putIfAbsent(
        productId,
        () => CartItem(id: productId, price: price, title: title),
      );
    }
    notifyListeners();
  }
}
