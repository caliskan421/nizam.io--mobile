// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_project_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableProjectList _$TableProjectListFromJson(Map<String, dynamic> json) =>
    _TableProjectList(
      items: (json['items'] as List<dynamic>)
          .map((e) => TableProject.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$TableProjectListToJson(_TableProjectList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };
