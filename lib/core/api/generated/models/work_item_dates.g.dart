// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_dates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemDates _$WorkItemDatesFromJson(Map<String, dynamic> json) =>
    _WorkItemDates(
      startOn: DateTime.parse(json['start_on'] as String),
      endOn: DateTime.parse(json['end_on'] as String),
      plannedEndOn: json['planned_end_on'] == null
          ? null
          : DateTime.parse(json['planned_end_on'] as String),
      completedOn: json['completed_on'] == null
          ? null
          : DateTime.parse(json['completed_on'] as String),
      originalCompletedOn: json['original_completed_on'] == null
          ? null
          : DateTime.parse(json['original_completed_on'] as String),
      submittedOn: json['submitted_on'] == null
          ? null
          : DateTime.parse(json['submitted_on'] as String),
    );

Map<String, dynamic> _$WorkItemDatesToJson(_WorkItemDates instance) =>
    <String, dynamic>{
      'start_on': instance.startOn.toIso8601String(),
      'end_on': instance.endOn.toIso8601String(),
      'planned_end_on': ?instance.plannedEndOn?.toIso8601String(),
      'completed_on': ?instance.completedOn?.toIso8601String(),
      'original_completed_on': ?instance.originalCompletedOn?.toIso8601String(),
      'submitted_on': ?instance.submittedOn?.toIso8601String(),
    };
