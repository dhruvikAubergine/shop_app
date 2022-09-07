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
      total = value.price! * (value.quantity!) as double;
    });

    return total;
  }

  void removeItem(String productId) {
    cartBox.delete(productId);
    notifyListeners();
  }

  void clear() {
    cartBox.clear();
    notifyListeners();
  }

  // void removeSingleItem(String productId) {
  //   if (!_items.containsKey(productId)) {
  //     return;
  //   }
  //   if (_items[productId]!.quantity! > 1) {
  //     _items.update(
  //       productId,
  //       (existingproduct) => NewCart(
  //         id: existingproduct.id,
  //         image: existingproduct.image,
  //         price: existingproduct.price,
  //         quantity: existingproduct.quantity! - 1,
  //         title: existingproduct.title,
  //       ),
  //     );
  //   } else {
  //     _items.remove(productId);
  //   }
  //   notifyListeners();
  // }

  Future<void> addItem(
    String productId,
    double price,
    String title,
    String image,
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
        ),
      );
    }

    notifyListeners();
    log(cartBox.keys.toString());
    log(cartBox.values.toString());

    final keys = cartBox.keys.toList();
    log(keys.toString());
  }
}
