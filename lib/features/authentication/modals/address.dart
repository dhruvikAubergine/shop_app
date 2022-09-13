import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address extends Equatable {

  const Address({this.area, this.city, this.state});

  factory Address.fromJson(Map<String, dynamic> json) {
    return _$AddressFromJson(json);
  }
  final String? area;
  final String? city;
  final String? state;

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  Address copyWith({
    String? area,
    String? city,
    String? state,
  }) {
    return Address(
      area: area ?? this.area,
      city: city ?? this.city,
      state: state ?? this.state,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [area, city, state];
}
