import 'package:json_annotation/json_annotation.dart';

part 'info_model.g.dart';

@JsonSerializable()
class InfoModel {
  final String? id;
  final String? username;
  final String? timeAgo;
  final String? tag;
  final String? title;
  final String? description;
  final String? image;
  final String? dateRange;
  int? views;

  InfoModel({
    this.id,
    this.username,
    this.timeAgo,
    this.tag,
    this.title,
    this.description,
    this.image,
    this.dateRange,
    this.views = 0,
  });

  /// ✅ This must be a factory constructor
  factory InfoModel.fromJson(Map<String, dynamic> json) =>
      _$InfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$InfoModelToJson(this);

  /// ✅ Static method for list conversion
  static List<InfoModel> fromList(List<dynamic> data) =>
      data.map((e) => InfoModel.fromJson(e)).toList();
}
