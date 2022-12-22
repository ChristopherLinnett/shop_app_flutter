import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app_flutter/models/http_exception.dart';
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

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-app-a0ea3-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    final existingItemIndex = _items.indexWhere((item) {
      return item.id == id;
    });
    Product? existingItem = _items[existingItemIndex];
    try {
      _items.removeWhere((item) {
        return item.id == id;
      });
      notifyListeners();
      var response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException('Deletion Error');
      }
    } catch (error) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw HttpException('Deletion Error');
    }
    existingItem = null;
    notifyListeners();
  }

  Future<void> editProduct(String id, Product newProduct) async {
    final url = Uri.parse(
        'https://flutter-shop-app-a0ea3-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    final prodIndex = _items.indexWhere((oldProduct) {
      return oldProduct.id == id;
    });
    if (prodIndex >= 0) {
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            },
          ),
        );
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        print(error.toString());
      }
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
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl'],
            isFavourite: product['isFavourite']);
        loadedProducts.add(newProduct);
      });
      _items = [...loadedProducts];
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
