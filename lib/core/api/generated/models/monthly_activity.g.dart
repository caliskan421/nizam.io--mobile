// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyActivity _$MonthlyActivityFromJson(Map<String, dynamic> json) =>
    _MonthlyActivity(
      month: json['month'] as String,
      createdTasks: (json['created_tasks'] as num).toInt(),
      completedTasks: (json['completed_tasks'] as num).toInt(),
      meetings: (json['meetings'] as num).toInt(),
      messages: (json['messages'] as num).toInt(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$MonthlyActivityToJson(_MonthlyActivity instance) =>
    <String, dynamic>{
      'month': instance.month,
      'created_tasks': instance.createdTasks,
      'completed_tasks': instance.completedTasks,
      'meetings': instance.meetings,
      'messages': instance.messages,
      'count': instance.count,
    };
