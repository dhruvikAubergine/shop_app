// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String?,
      title: json['title'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      duration: json['duration'] == null
          ? null
          : DateTime.parse(json['duration'] as String),
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      checkSalesAvailability: json['checkSalesAvailability'] as bool? ?? true,
    );

Map<String, dynamic> _$ProductToJson(Product instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('description', instance.description);
  writeNotNull('price', instance.price);
  val['isFavorite'] = instance.isFavorite;
  writeNotNull('duration', instance.duration?.toIso8601String());
  val['checkSalesAvailability'] = instance.checkSalesAvailability;
  return val;
}
