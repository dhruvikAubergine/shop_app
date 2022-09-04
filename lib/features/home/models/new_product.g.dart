// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewProduct _$NewProductFromJson(Map<String, dynamic> json) => NewProduct(
      id: json['id'] as String?,
      title: json['title'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$NewProductToJson(NewProduct instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('price', instance.price);
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('description', instance.description);
  val['isFavorite'] = instance.isFavorite;
  return val;
}
