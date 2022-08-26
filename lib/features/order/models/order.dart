import 'package:shop_app/features/cart/models/cart.dart';

class Order {
  Order({
    required this.id,
    required this.amount,
    required this.product,
    required this.dateTime,
  });

  final String id;
  final double amount;
  final List<Cart> product;
  final DateTime dateTime;
}
