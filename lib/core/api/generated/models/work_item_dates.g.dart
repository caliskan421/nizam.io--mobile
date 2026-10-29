// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_dates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemDates _$WorkItemDatesFromJson(Map<String, dynamic> json) =>
    _WorkItemDates(
      startOn: const DateOnlyConverter().fromJson(json['start_on'] as String),
      endOn: const DateOnlyConverter().fromJson(json['end_on'] as String),
      plannedEndOn: _$JsonConverterFromJson<String, DateTime>(
        json['planned_end_on'],
        const DateOnlyConverter().fromJson,
      ),
      completedOn: _$JsonConverterFromJson<String, DateTime>(
        json['completed_on'],
        const DateOnlyConverter().fromJson,
      ),
      originalCompletedOn: _$JsonConverterFromJson<String, DateTime>(
        json['original_completed_on'],
        const DateOnlyConverter().fromJson,
      ),
      submittedOn: _$JsonConverterFromJson<String, DateTime>(
        json['submitted_on'],
        const DateOnlyConverter().fromJson,
      ),
    );

Map<String, dynamic> _$WorkItemDatesToJson(_WorkItemDates instance) =>
    <String, dynamic>{
      'start_on': const DateOnlyConverter().toJson(instance.startOn),
      'end_on': const DateOnlyConverter().toJson(instance.endOn),
      'planned_end_on': ?_$JsonConverterToJson<String, DateTime>(
        instance.plannedEndOn,
        const DateOnlyConverter().toJson,
      ),
      'completed_on': ?_$JsonConverterToJson<String, DateTime>(
        instance.completedOn,
        const DateOnlyConverter().toJson,
      ),
      'original_completed_on': ?_$JsonConverterToJson<String, DateTime>(
        instance.originalCompletedOn,
        const DateOnlyConverter().toJson,
      ),
      'submitted_on': ?_$JsonConverterToJson<String, DateTime>(
        instance.submittedOn,
        const DateOnlyConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
