import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/report_model.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  Future<List<ReportModel>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      return ReportModel.fromList(jsonDecode(response.body));
    }
    throw Exception('Failed to load products: ${response.statusCode}');
  }
}