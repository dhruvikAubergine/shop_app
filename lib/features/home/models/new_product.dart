import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_product.g.dart';

@JsonSerializable()
class NewProduct extends Equatable {
  NewProduct({
    this.id,
    this.title,
    this.price,
    this.imageUrl,
    this.isFavorite = false,
    this.description,
  });

  factory NewProduct.fromJson(Map<String, dynamic> json) {
    return _$NewProductFromJson(json);
  }

  void toggleFavoriteStatus(String id) {
    isFavorite = !isFavorite;
  }

  final String? id;
  final String? title;
  final double? price;
  final String? imageUrl;
  final String? description;
  bool isFavorite;

  Map<String, dynamic> toJson() => _$NewProductToJson(this);

  NewProduct copyWith({
    String? id,
    String? title,
    double? price,
    String? imageUrl,
    String? description,
    bool? isFavorite,
  }) {
    return NewProduct(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      price,
      imageUrl,
      description,
      isFavorite,
    ];
  }
}
