import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app_flutter/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavourite() async {
    isFavourite = !isFavourite;
    notifyListeners();

    var url = Uri.parse(
        'https://flutter-shop-app-a0ea3-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    try {
      var response = await http.patch(
        url,
        body: json.encode(
          {'isFavourite': isFavourite},
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Could Not Update Favourite');
      }
    } catch (error) {
      isFavourite = !isFavourite;
      notifyListeners();
    }
  }
}
