import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shop_app/features/authentication/modals/address.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({this.name, this.email, this.phone, this.address});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  final String? name;
  final String? email;
  final int? phone;
  final Address? address;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? name,
    String? email,
    int? phone,
    Address? address,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name, email, phone, address];
}
