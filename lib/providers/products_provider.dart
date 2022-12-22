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

  void editProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((oldProduct) {
      return oldProduct.id == id;
    });
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void addProduct(Product product) {
    final newProduct = Product(
        id: UniqueKey().toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    _items.add(newProduct);
    notifyListeners();
  }
}
