// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lateness.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lateness _$LatenessFromJson(Map<String, dynamic> json) => _Lateness(
  isOverdue: json['is_overdue'] as bool,
  daysOverdue: (json['days_overdue'] as num).toInt(),
  isCompletedLate: json['is_completed_late'] as bool,
  daysLate: (json['days_late'] as num).toInt(),
  isCompletedEarly: json['is_completed_early'] as bool,
  daysEarly: (json['days_early'] as num).toInt(),
);

Map<String, dynamic> _$LatenessToJson(_Lateness instance) => <String, dynamic>{
  'is_overdue': instance.isOverdue,
  'days_overdue': instance.daysOverdue,
  'is_completed_late': instance.isCompletedLate,
  'days_late': instance.daysLate,
  'is_completed_early': instance.isCompletedEarly,
  'days_early': instance.daysEarly,
};
