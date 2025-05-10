// models/user_model.dart
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;
  final String password;
  final String email;
  final Name name;
  final Address address;
  final String image;
  final String phone;
  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.name,
    required this.address,
    required this.image,
    required this.phone,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  static List<User> fromList(List<dynamic> jsonList) =>
      jsonList.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
}

@JsonSerializable()
class Name {
  final String firstname;
  final String lastname;
  Name({required this.firstname, required this.lastname});
  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);
  Map<String, dynamic> toJson() => _$NameToJson(this);
}

@JsonSerializable()
class Address {
  final Geolocation geolocation;
  final String city;
  final String street;
  final int number;
  final String zipcode;
  Address({
    required this.geolocation,
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });
  // JSON -> UserModel object
  factory Address.fromJson
  (Map<String, dynamic> json) => _$AddressFromJson(json);
  // UserModel object -> JSON
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Geolocation {
  final String lat;
  final String long;
  Geolocation({required this.lat, required this.long});
  factory Geolocation.fromJson(Map<String, dynamic> json) => _$GeolocationFromJson(json);
  Map<String, dynamic> toJson() => _$GeolocationToJson(this);
}