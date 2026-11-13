// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_comment_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableCommentPage _$TableCommentPageFromJson(Map<String, dynamic> json) =>
    _TableCommentPage(
      items: (json['items'] as List<dynamic>)
          .map((e) => TableComment.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$TableCommentPageToJson(_TableCommentPage instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };
