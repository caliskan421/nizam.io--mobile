// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  title: json['title'] as String,
  status: json['status'] as String,
  departmentId: json['department_id'] as String,
  departmentName: json['department_name'] as String?,
  assignees: (json['assignees'] as List<dynamic>)
      .map((e) => Assignees.fromJson(e as Map<String, dynamic>))
      .toList(),
  startOn: const DateOnlyConverter().fromJson(json['start_on'] as String),
  endOn: const DateOnlyConverter().fromJson(json['end_on'] as String),
  description: json['description'] as String,
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'title': instance.title,
  'status': instance.status,
  'department_id': instance.departmentId,
  'department_name': ?instance.departmentName,
  'assignees': instance.assignees.map((e) => e.toJson()).toList(),
  'start_on': const DateOnlyConverter().toJson(instance.startOn),
  'end_on': const DateOnlyConverter().toJson(instance.endOn),
  'description': instance.description,
};
