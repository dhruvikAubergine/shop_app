import 'package:flutter/cupertino.dart';
import 'package:shop_app/features/cart/models/cart.dart';
import 'package:shop_app/features/order/models/order.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orderitems {
    return _orders;
  }

  void addOrder(List<Cart> cartProduct, double total) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        product: cartProduct,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
