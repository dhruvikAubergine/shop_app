// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Cart.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) {
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
  writeNotNull('deliveryCharge', instance.deliveryCharge);
  writeNotNull('tax', instance.tax);
  return val;
}
