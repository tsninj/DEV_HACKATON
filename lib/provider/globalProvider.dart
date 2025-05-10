import 'package:flutter/material.dart';
import 'package:smartub/models/info_model.dart';
import 'package:smartub/models/report_model.dart';
import 'package:smartub/models/user_model.dart';

class Global_provider extends ChangeNotifier {
  List<ReportModel> reports = [];
  List<InfoModel> infos = [];
  User? currentUser;
  int currentIdx = 0;

  void setInfos(List<InfoModel> data) {
    infos = data;
    notifyListeners();
  }

  // Бараа бүрийн тоо ширхэгийг хадгалах Map
  final Map<int?, int> _quantities = {};
  String? _token;
  String? get token => _token;
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  bool get isLoggedIn => currentUser != null;
  // Нийт үнийг тооцоолох

  // API-аас авах бүтээгдэхүүнийг products-д оноох
  // Сагснаас устгах
  Future<void> removeFromCart(ReportModel product) async {
    if (product.id != null) {
      _quantities.remove(product.id);
    }
    notifyListeners();
  }

  // Сагсыг цэвэрлэх
  Future<void> clearCart() async {
    _quantities.clear();
    notifyListeners();
  }

  void login(User user) {
    currentUser = user;
    notifyListeners();
  }

  void logout() {
    currentUser = null;
    _token = null;
    currentIdx = 0;
    _quantities.clear();
    notifyListeners();
  }

  void changeCurrentIdx(int idx) {
    // Bottom navigation bar-ын идэвхтэй tab-ыг солих
    currentIdx = idx;
    notifyListeners();
  }
}
