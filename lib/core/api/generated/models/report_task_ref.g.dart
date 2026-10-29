// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_task_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportTaskRef _$ReportTaskRefFromJson(Map<String, dynamic> json) =>
    _ReportTaskRef(
      workItemId: json['work_item_id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      departmentName: json['department_name'] as String,
    );

Map<String, dynamic> _$ReportTaskRefToJson(_ReportTaskRef instance) =>
    <String, dynamic>{
      'work_item_id': instance.workItemId,
      'title': instance.title,
      'status': instance.status,
      'department_name': instance.departmentName,
    };
