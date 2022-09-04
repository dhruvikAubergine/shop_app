import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product extends Equatable {
  const Product({
    this.id,
    this.image,
    this.price,
    this.quantity,
    this.title,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }
  final String? id;
  final String? image;
  final int? price;
  final int? quantity;
  final String? title;

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? id,
    String? image,
    int? price,
    int? quantity,
    String? title,
  }) {
    return Product(
      id: id ?? this.id,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      title: title ?? this.title,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, image, price, quantity, title];
}
