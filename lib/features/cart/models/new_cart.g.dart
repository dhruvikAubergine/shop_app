// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_cart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewCartAdapter extends TypeAdapter<NewCart> {
  @override
  final int typeId = 0;

  @override
  NewCart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewCart(
      id: fields[0] as String?,
      title: fields[1] as String?,
      image: fields[2] as String?,
      price: fields[3] as double?,
      quantity: fields[4] as double?,
      productId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NewCart obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.productId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewCartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewCart _$NewCartFromJson(Map<String, dynamic> json) => NewCart(
      id: json['id'] as String?,
      title: json['title'] as String?,
      image: json['image'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toDouble(),
      productId: json['productId'] as String?,
    );

Map<String, dynamic> _$NewCartToJson(NewCart instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('image', instance.image);
  writeNotNull('price', instance.price);
  writeNotNull('quantity', instance.quantity);
  writeNotNull('productId', instance.productId);
  return val;
}
