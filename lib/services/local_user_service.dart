import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:smartub/models/user_model.dart';

class LocalUserService {
  List<User>? _users;
  Future<List<User>> _loadUsers() async {
    if (_users != null) return _users!;
    final data = await rootBundle.loadString('assets/users.json');
    final List<dynamic> jsonList = json.decode(data);
    _users = User.fromList(jsonList);
    return _users!;
  }
  Future<User?> authenticate(String emailOrUsername, String password) async {
    final users = await _loadUsers();
    for (final u in users) {
      if ((u.email == emailOrUsername || u.username == emailOrUsername)
          && u.password == password) {
        return u;
      }
    }
    return null;
  }
}