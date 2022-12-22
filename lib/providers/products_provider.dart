import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app_flutter/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

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

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-app-a0ea3-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, product) {
        var newProduct = Product(
            id: productId,
            title: product['title'] ?? 'error',
            description: product['description'] ?? 'error',
            price: product['price'] ?? 'error',
            imageUrl: product['imageUrl'] ?? false,
            isFavourite: product['isFavourite'] ?? 'error');
        loadedProducts.add(newProduct);
      });
      _items = [...loadedProducts];
      print(_items);
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shop-app-a0ea3-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    var response = await http.post(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavourite': product.isFavourite
        }));
    final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    _items.add(newProduct);
    notifyListeners();
  }
}
