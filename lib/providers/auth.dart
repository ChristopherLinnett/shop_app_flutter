import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app_flutter/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  String get userId {
    return _userId ?? '';
  }

  String? get token {
    if (_token != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token!;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  final String API_KEY = 'AIzaSyDvuSbbSpHokXVMRBnnZfEpEDIbz9yKp-4';

  Future<void> authenticate(
      {required String email,
      required String password,
      required String urlSegment}) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$API_KEY');

    try {
      var response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      var responseBody = json.decode(response.body);

      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> signin({required String email, required String password}) async {
    return authenticate(
        email: email, password: password, urlSegment: 'signInWithPassword');
  }

  Future<void> signup({required String email, required String password}) async {
    return authenticate(email: email, password: password, urlSegment: 'signUp');
  }
}
