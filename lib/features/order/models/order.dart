import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shop_app/features/cart/models/cart.dart';

part 'order.g.dart';

@JsonSerializable()
class Order extends Equatable {
  const Order({this.amount, this.dateTime, this.products, this.id});
  factory Order.fromJson(Map<String, dynamic> json) {
    return _$OrderFromJson(json);
  }
  final double? amount;
  final DateTime? dateTime;
  final List<Cart>? products;
  final String? id;

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  Order copyWith({
    double? amount,
    DateTime? dateTime,
    List<Cart>? products,
    String? id,
  }) {
    return Order(
      amount: amount ?? this.amount,
      dateTime: dateTime ?? this.dateTime,
      products: products ?? this.products,
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [amount, dateTime, products, id];
}
