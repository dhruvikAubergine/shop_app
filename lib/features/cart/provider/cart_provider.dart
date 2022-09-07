import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:shop_app/features/cart/models/cart.dart';

class CartProvider with ChangeNotifier {
  // final Map<String, NewCart> _items = {};
  final cartBox = Hive.box('Cart Box');

  Map<String, Cart> get items {
    // return {..._items};
    final _items = <String, Cart>{};
    final keys = cartBox.keys.toList();
    final values = cartBox.values.toList();

    for (var i = 0; i < keys.length; i++) {
      _items[keys[i].toString()] = values[i] as Cart;
    }
    return _items;
  }

  int get itemCount {
    // return _items.length;
    return cartBox.values.length;
  }

  double get totalAmount {
    var total = 0.0;
    cartBox.toMap().forEach((key, value) {
      total = value.price! * (value.quantity!) as double;
    });

    // _items.forEach((key, cartItem) {
    //   total += cartItem.price! * cartItem.quantity!;
    // });
    return total;
  }

  void removeItem(String productId) {
    // _items.remove(productId);
    cartBox.delete(productId);
    notifyListeners();
  }

  void clear() {
    // _items.clear();
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
    // final prefs = await SharedPreferences.getInstance();

    // final encodedCartData = prefs.getString('cartData');
    // // await prefs.clear();
    // // return;
    // if (encodedCartData != null) {
    //   final decodedCartData =
    //       jsonDecode(encodedCartData) as Map<String, dynamic>;

    //   // final decodedCartData =
    //   //     decodedCartData1.map((key, value) => MapEntry(key, value as NewCart));

    //   if (decodedCartData.containsKey(productId)) {
    //     decodedCartData.update(
    //       productId,
    //       (existingcartvalue) => existingcartvalue.copyWith(
    //         quantity: (existingcartvalue.quantity!) + 1,
    //       ),
    //     );
    //   } else {
    //     decodedCartData.putIfAbsent(
    //       productId,
    //       () => NewCart(
    //         id: DateTime.now().toString(),
    //         price: price,
    //         title: title,
    //         image: image,
    //         quantity: 1,
    //       ),
    //     );
    //   }
    //   await prefs.setString('cartData', jsonEncode(decodedCartData));

    //   _items =
    //       decodedCartData.map((key, value) =>
    //MapEntry(key, value as NewCart));
    //   notifyListeners();
    //   log('shred prefs items');
    //   log(decodedCartData.toString());
    //   log('local items');
    //   log(_items.toString());
    // } else {
    //   final cartProduct = NewCart(
    //     id: DateTime.now().toString(),
    //     price: price,
    //     title: title,
    //     image: image,
    //     quantity: 1,
    //   );
    //   final cartMap = <String, NewCart>{};
    //   cartMap.putIfAbsent(productId, () => cartProduct);

    //   await prefs.setString('cartData', jsonEncode(cartMap));

    //   _items = cartMap;
    //   notifyListeners();
    //   log('shred prefs items');
    //   log(cartMap.toString());
    //   log('local items');
    //   log(_items.toString());
    // }

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

    // if (_items.containsKey(productId)) {
    //   _items.update(
    //     productId,
    //     (existingcartvalue) => NewCart(
    //       id: existingcartvalue.id,
    //       price: existingcartvalue.price,
    //       title: existingcartvalue.title,
    //       image: existingcartvalue.image,
    //       quantity: existingcartvalue.quantity! + 1,
    //     ),
    //   );
    // } else {
    //   _items.putIfAbsent(
    //     productId,
    //     () => NewCart(
    //       id: DateTime.now().toString(),
    //       price: price,
    //       title: title,
    //       image: image,
    //       quantity: 1,
    //     ),
    //   );
    // }
    notifyListeners();
    log(cartBox.keys.toString());
    log(cartBox.values.toString());

    final keys = cartBox.keys.toList();
    log(keys.toString());
  }
}
