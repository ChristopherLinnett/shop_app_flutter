import 'package:flutter/material.dart';
import 'package:shop_app_flutter/dummyproducts.dart';

import 'package:shop_app_flutter/providers/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [...dummyProductList];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favourites {
    return _items.where((item) => item.isFavourite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  void addProduct(Product newProduct) {
    _items.add(newProduct);
    notifyListeners();
  }
}
