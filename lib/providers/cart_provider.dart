import 'package:flutter/widgets.dart';
import 'package:shop_app/models/cart.dart';

class CartProvider with ChangeNotifier {
  final Map<String, Cart> _items = {};

  Map<String, Cart> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingproduct) => Cart(
          id: existingproduct.id,
          image: existingproduct.image,
          price: existingproduct.price,
          quantity: existingproduct.quantity - 1,
          title: existingproduct.title,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addItem(
    String productId,
    double price,
    String title,
    String image,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingcartvalue) => Cart(
          id: existingcartvalue.id,
          price: existingcartvalue.price,
          title: existingcartvalue.title,
          image: existingcartvalue.image,
          quantity: existingcartvalue.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => Cart(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          image: image,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
