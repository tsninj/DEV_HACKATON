import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

@JsonSerializable()
class ReportModel {
  final String? id;
  final String? imageUrl;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? userId;
  final String? status;
  final DateTime? createdAt;

  ReportModel({
    this.id,
    this.imageUrl,
    this.description,
    this.latitude,
    this.longitude,
    this.userId,
    this.status,
    this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);

  static List<ReportModel> fromList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => ReportModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}