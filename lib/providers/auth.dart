import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app_flutter/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

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
    autoLogout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final loginData = json.encode({
      'token': token,
      'userid': userId,
      'expiryDate': _expiryDate!.toIso8601String()
    });
    prefs.setString('loginData', loginData);
  }

  Future<void> signin({required String email, required String password}) async {
    return authenticate(
        email: email, password: password, urlSegment: 'signInWithPassword');
  }

  Future<void> signup({required String email, required String password}) async {
    return authenticate(email: email, password: password, urlSegment: 'signUp');
  }

  void logout() async {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    _token = null;
    _userId = null;
    _expiryDate = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('loginData')) {
      return false;
    }
    final loginData = json.decode(prefs.getString('loginData') ?? '{}');
    final expiryDate = DateTime.parse(loginData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = loginData['token'];
    _userId = loginData['userid'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }
}
