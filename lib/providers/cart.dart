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
  Map<String, CartItem> _contents = {};

  Map<String, CartItem> get contents {
    return {..._contents};
  }

  int get itemCount {
    var count = 0;
    _contents.forEach(((key, value) {
      count += value.quantity;
    }));
    return count;
  }

  double get cartTotal {
    var total = 0.0;
    _contents.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return double.parse(total.toStringAsFixed(2));
  }

  List<CartItem> get cartList {
    List<CartItem> items = [];
    _contents.forEach((key, value) {
      items.add(value);
    });
    return items;
  }

  void removeSingleItem(String itemId) {
    if (!_contents.containsKey(itemId)) {
      return;
    }
    if (_contents[itemId]!.quantity > 1) {
      _contents.update(itemId, (value) {
        value.quantity -= 1;
        return value;
      });
      notifyListeners();
    } else {
      removeItem(itemId);
    }
  }

  void removeItem(String itemId) {
    _contents.remove(itemId);
    notifyListeners();
  }

  void clearCart() {
    _contents = {};
    notifyListeners();
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
