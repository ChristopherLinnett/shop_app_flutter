import 'package:flutter/material.dart';
import 'package:shop_app_flutter/dummyproducts.dart';

import 'package:shop_app_flutter/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [...dummyProductList];

  List<Product> get items {
    return [..._items];
  }

  void addProduct(newProduct) {
    _items.add(newProduct);
    notifyListeners();
  }
}
