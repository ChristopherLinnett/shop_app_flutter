import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
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

  void deleteProduct(String id) {
    _items.removeWhere((item) {
      return item.id == id;
    });
    notifyListeners();
  }

  void editProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((oldProduct) {
      return oldProduct.id == id;
    });
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      throw 'index not found while editing';
    }
  }

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
        'https://flutter-shop-app-a0ea3-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    return http
        .post(url,
            body: json.encode({
              'title': product.description,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavourite': product.isFavourite
            }))
        .then((response) {
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    });
  }
}
