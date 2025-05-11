import 'package:flutter/material.dart';

class Volunteer {
  final String name;
  final String photo;
  final String description;
  final IconData iconData;
  final String date;

  Volunteer({
    required this.name,
    required this.photo,
    required this.description,
    required this.iconData,
    required this.date,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      name: json['name'],
      photo: json['photo'],
      description: json['description'],
      iconData: _getIconData(json['icon']),
      date: json['date'],
    );
  }

  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'calendar_today':
        return Icons.calendar_today;
      case 'event':
        return Icons.event;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.help_outline;
    }
  }
}
