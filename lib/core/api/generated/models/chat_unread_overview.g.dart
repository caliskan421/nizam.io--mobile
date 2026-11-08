// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_unread_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatUnreadOverview _$ChatUnreadOverviewFromJson(Map<String, dynamic> json) =>
    _ChatUnreadOverview(
      items: (json['items'] as List<dynamic>)
          .map((e) => ChatUnreadProgram.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatUnreadOverviewToJson(_ChatUnreadOverview instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
