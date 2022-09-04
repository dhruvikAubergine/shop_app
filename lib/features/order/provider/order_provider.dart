import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/features/cart/models/new_cart.dart';
import 'package:shop_app/features/order/models/new_order.dart';

class OrderProvider with ChangeNotifier {
  OrderProvider(this.authToken, this._orders);
  List<NewOrder> _orders = [];
  final String authToken;

  List<NewOrder> get orderitems {
    return _orders;
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
      'https://personal-expenses-e3eac-default-rtdb.firebaseio.com//orders.json?auth=$authToken',
    );
    try {
      final response = await http.get(url);
      log(json.decode(response.body).toString());

      if (jsonDecode(response.body) != null) {
        final loadedOrders = <NewOrder>[];

        (jsonDecode(response.body) as Map<String, dynamic>)
            .forEach((key, value) {
          (value as Map<String, dynamic>).putIfAbsent('id', () => key);
          loadedOrders.add(NewOrder.fromJson(value));
        });

        // final extractedData =
        //     json.decode(response.body) as Map<String, Map<String, dynamic>>;
        // if (extractedData.isEmpty) return;

        // extractedData.forEach((NewOrderId, order) {
        //   final demo = order['products'];
        //   log(demo.toString());
        //   loadedOrders.add(
        //     Order(
        //       id: orderId,
        //       amount: order['amount'] as double,
        //       dateTime: DateTime.parse(order['dateTime'] as String),
        //       product:
        //           (order['product'] as List<Map<String, dynamic>>).map((item) {
        //         return Cart(
        //           id: item['id'] as String,
        //           price: item['price'] as double,
        //           title: item['title'] as String,
        //           image: item['imageUrl'] as String,
        //           quantity: item['quantity'] as double,
        //         );
        //       }).toList(),
        //     ),
        //   );
        // });
        _orders = loadedOrders.reversed.toList();
      } else {
        _orders = [];
      }
      notifyListeners();
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> addOrder(List<NewCart> cartProduct, double total) async {
    final timestamp = DateTime.now();
    final url = Uri.parse(
      'https://personal-expenses-e3eac-default-rtdb.firebaseio.com//orders.json?auth=$authToken',
    );
    final order =
        NewOrder(amount: total, dateTime: timestamp, products: cartProduct);
    final response = await http.post(
      url,
      body: jsonEncode(order.toJson()),

      // json.encode({
      //   'amount': total,
      //   'dateTime': timestamp.toIso8601String(),
      //   'products': cartProduct
      //       .map(
      //         (cartProduct) => {
      //           'id': cartProduct.id,
      //           'title': cartProduct.title,
      //           'quantity': cartProduct.quantity,
      //           'price': cartProduct.price,
      //         },
      //       )
      //       .toList()
      // }),
    );

    _orders.insert(
      0,
      order.copyWith(
        id: (jsonDecode(response.body) as Map<String, dynamic>)['name']
            as String,
      ),
      // Order(
      //   id: json.decode(response.body)['name'].toString(),
      //   amount: total,
      //   products: cartProduct,
      //   dateTime: timestamp,
      // ),
    );
    notifyListeners();
  }
}
