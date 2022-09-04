import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_cart.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class NewCart extends Equatable {
  const NewCart({
    this.id,
    this.title,
    this.image,
    this.price,
    this.quantity,
    this.productId,
  });

  factory NewCart.fromJson(Map<String, dynamic> json) {
    return _$NewCartFromJson(json);
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

  Map<String, dynamic> toJson() => _$NewCartToJson(this);

  NewCart copyWith({
    String? id,
    String? title,
    String? image,
    double? price,
    double? quantity,
    String? productId,
  }) {
    return NewCart(
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
