import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:shop_app/features/cart/models/cart.dart';

class CartProvider with ChangeNotifier {
  final cartBox = Hive.box('Cart Box');

  Map<String, Cart> get items {
    final _items = <String, Cart>{};
    final keys = cartBox.keys.toList();
    final values = cartBox.values.toList();

    for (var i = 0; i < keys.length; i++) {
      _items[keys[i].toString()] = values[i] as Cart;
    }
    return _items;
  }

  int get itemCount {
    return cartBox.values.length;
  }

  double get totalAmount {
    var total = 0.0;
    cartBox.toMap().forEach((key, value) {
      total += value.price! * (value.quantity!) as double;
    });

    return total;
  }

  double get totalTax {
    var tax = 0.0;
    cartBox.toMap().forEach((key, value) {
      tax += ((value.price * value.taxPercentage) / 100) * value.quantity
          as double;
    });
    return tax;
  }

  void removeItem(String productId) {
    cartBox.delete(productId);
    notifyListeners();
  }

  void clear() {
    cartBox.clear();
    notifyListeners();
  }

  Future<void> addOrRemoveQuantity({
    required String id,
    required bool isForAdd,
  }) async {
    if (cartBox.containsKey(id)) {
      final existingValue = cartBox.get(id) as Cart;
      if (isForAdd) {
        await cartBox.put(
          id,
          existingValue.copyWith(quantity: existingValue.quantity! + 1),
        );
        notifyListeners();
        log(cartBox.get(id).toString());
      } else {
        await cartBox.put(
          id,
          existingValue.copyWith(quantity: existingValue.quantity! - 1),
        );
        notifyListeners();
        log(cartBox.get(id).toString());
      }
    }
  }

  Future<void> addItem(
    String productId,
    double price,
    String title,
    String image,
    double taxPercentage,
  ) async {
    if (cartBox.containsKey(productId)) {
      final existingValue = cartBox.get(productId) as Cart;
      await cartBox.put(
        productId,
        existingValue.copyWith(quantity: existingValue.quantity! + 1),
      );
    } else {
      await cartBox.put(
        productId,
        Cart(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          image: image,
          quantity: 1,
          taxPercentage: taxPercentage,
          productId: productId,
        ),
      );
    }

    notifyListeners();
    log(cartBox.keys.toString());
    log(cartBox.values.toString());
  }
}
