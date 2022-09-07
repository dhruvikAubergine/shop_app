import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Cart extends Equatable {
  const Cart({
    this.id,
    this.title,
    this.image,
    this.price,
    this.quantity,
    this.productId,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return _$CartFromJson(json);
  }
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String? image;
  @HiveField(3)
  final double? price;
  @HiveField(4)
  final double? quantity;
  @HiveField(5)
  final String? productId;

  Map<String, dynamic> toJson() => _$CartToJson(this);

  Cart copyWith({
    String? id,
    String? title,
    String? image,
    double? price,
    double? quantity,
    String? productId,
  }) {
    return Cart(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title, image, price, quantity, productId];
}
