import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/features/cart/models/cart.dart';
import 'package:shop_app/features/order/models/order.dart';

class OrderProvider with ChangeNotifier {
  OrderProvider(this.authToken, this.userId, this._orders);
  List<Order> _orders = [];
  final String authToken;
  final String userId;

  List<Order> get orderitems {
    return _orders;
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
      'https://personal-expenses-e3eac-default-rtdb.firebaseio.com//orders/$userId.json?auth=$authToken',
    );
    try {
      final response = await http.get(url);
      log(json.decode(response.body).toString());

      if (jsonDecode(response.body) != null) {
        final loadedOrders = <Order>[];

        (jsonDecode(response.body) as Map<String, dynamic>)
            .forEach((key, value) {
          (value as Map<String, dynamic>).putIfAbsent('id', () => key);
          loadedOrders.add(Order.fromJson(value));
        });

        _orders = loadedOrders.reversed.toList();
      } else {
        _orders = [];
      }
      notifyListeners();
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> addOrder(
    List<Cart> cartProduct,
    double total,
    double deliveryCharge,
    double tax,
  ) async {
    final timestamp = DateTime.now();
    final url = Uri.parse(
      'https://personal-expenses-e3eac-default-rtdb.firebaseio.com//orders/$userId.json?auth=$authToken',
    );
    final order = Order(
      amount: total,
      dateTime: timestamp,
      products: cartProduct,
      deliveryCharge: deliveryCharge,
      tax: tax,
    );
    final response = await http.post(
      url,
      body: jsonEncode(order.toJson()),
    );

    _orders.insert(
      0,
      order.copyWith(
        id: (jsonDecode(response.body) as Map<String, dynamic>)['name']
            as String,
      ),
    );
    notifyListeners();
  }
}
