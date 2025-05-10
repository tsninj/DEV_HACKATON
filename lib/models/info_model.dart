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

  InfoModel fromJson(Map<String, dynamic> json) {
    return _$InfoModelFromJson(json);
  }

  static List<InfoModel> fromList(List<dynamic> data) =>
      data.map((e) => InfoModel().fromJson(e)).toList();

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
