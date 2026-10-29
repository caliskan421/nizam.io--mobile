// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageStats _$MessageStatsFromJson(Map<String, dynamic> json) =>
    _MessageStats(
      total: (json['total'] as num).toInt(),
      fromAdmins: (json['from_admins'] as num).toInt(),
      fromOthers: (json['from_others'] as num).toInt(),
    );

Map<String, dynamic> _$MessageStatsToJson(_MessageStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'from_admins': instance.fromAdmins,
      'from_others': instance.fromOthers,
    };
