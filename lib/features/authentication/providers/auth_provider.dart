import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/features/manage_product/modals/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  late DateTime _expiryDate;
  String _userId = '';

  bool get isAuth {
    return token != '';
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != '' && _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return '';
  }

  Future<void> authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCb8YuvUwurikm4Oy9tvx7rwR7oZK8DfT8',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      log(response.body);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message'].toString());
      }
      _token = responseData['idToken'] as String;
      _userId = responseData['localId'] as String;
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn'] as String),
        ),
      );
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      await pref.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logIn(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    // await pref.clear();
    if (!pref.containsKey('userData')) {
      return false;
    }
    final extractedUSerData =
        jsonDecode(pref.getString('userData')!) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extractedUSerData['expiryDate'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUSerData['token'] as String;
    _userId = extractedUSerData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = '';
    _expiryDate = DateTime.now();
    _userId = '';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
