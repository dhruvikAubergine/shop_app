import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product extends Equatable {
  Product({
    this.id,
    this.title,
    this.price,
    this.duration,
    this.imageUrl,
    this.description,
    this.taxPercentage,
    this.isFavorite = false,
    this.checkSalesAvailability = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }

  void toggleFavoriteStatus(String id) {
    isFavorite = !isFavorite;
  }

  final String? id;
  final String? title;
  final String? imageUrl;
  final String? description;
  double? price;
  bool isFavorite;
  DateTime? duration;
  bool checkSalesAvailability;
  double? taxPercentage;

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? id,
    String? title,
    double? price,
    String? imageUrl,
    String? description,
    bool? isFavorite,
    DateTime? duration,
    bool? checkSalesAvailability,
    double? taxPercentage,
  }) {
    return Product(
      id: id ?? this.id,
      duration: duration ?? this.duration,
      title: title ?? this.title,
      price: price ?? this.price,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      checkSalesAvailability:
          checkSalesAvailability ?? this.checkSalesAvailability,
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
      duration,
      imageUrl,
      isFavorite,
      description,
      taxPercentage,
      checkSalesAvailability
    ];
  }
}
