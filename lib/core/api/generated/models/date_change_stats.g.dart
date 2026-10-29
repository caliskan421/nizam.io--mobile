// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_change_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DateChangeStats _$DateChangeStatsFromJson(Map<String, dynamic> json) =>
    _DateChangeStats(
      total: (json['total'] as num).toInt(),
      approved: (json['approved'] as num).toInt(),
      rejected: (json['rejected'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
    );

Map<String, dynamic> _$DateChangeStatsToJson(_DateChangeStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'approved': instance.approved,
      'rejected': instance.rejected,
      'pending': instance.pending,
    };
