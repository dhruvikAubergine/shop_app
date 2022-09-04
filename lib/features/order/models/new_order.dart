import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shop_app/features/cart/models/new_cart.dart';

part 'new_order.g.dart';

@JsonSerializable()
class NewOrder extends Equatable {
  const NewOrder({this.amount, this.dateTime, this.products, this.id});
  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return _$NewOrderFromJson(json);
  }
  final double? amount;
  final DateTime? dateTime;
  final List<NewCart>? products;
  final String? id;

  Map<String, dynamic> toJson() => _$NewOrderToJson(this);

  NewOrder copyWith({
    double? amount,
    DateTime? dateTime,
    List<NewCart>? products,
    String? id,
  }) {
    return NewOrder(
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
