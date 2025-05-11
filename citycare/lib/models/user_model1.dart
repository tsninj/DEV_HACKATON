import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String email;
  final String avatar;

  UserProfile({required this.name, required this.email, required this.avatar});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}
