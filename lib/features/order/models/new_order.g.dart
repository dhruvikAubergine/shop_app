// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewOrder _$NewOrderFromJson(Map<String, dynamic> json) => NewOrder(
      amount: (json['amount'] as num?)?.toDouble(),
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => NewCart.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$NewOrderToJson(NewOrder instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('amount', instance.amount);
  writeNotNull('dateTime', instance.dateTime?.toIso8601String());
  writeNotNull('products', instance.products);
  writeNotNull('id', instance.id);
  return val;
}
