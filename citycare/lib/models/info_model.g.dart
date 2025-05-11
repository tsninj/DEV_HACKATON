// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoModel _$InfoModelFromJson(Map<String, dynamic> json) => InfoModel(
  id: json['id'] as String?,
  username: json['username'] as String?,
  timeAgo: json['timeAgo'] as String?,
  tag: json['tag'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  image: json['image'] as String?,
  dateRange: json['dateRange'] as String?,
  views: (json['views'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$InfoModelToJson(InfoModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'timeAgo': instance.timeAgo,
  'tag': instance.tag,
  'title': instance.title,
  'description': instance.description,
  'image': instance.image,
  'dateRange': instance.dateRange,
  'views': instance.views,
};
