// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_note_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConvertNoteRequest _$ConvertNoteRequestFromJson(Map<String, dynamic> json) =>
    _ConvertNoteRequest(
      startDate: const DateOnlyConverter().fromJson(
        json['start_date'] as String,
      ),
      endDate: const DateOnlyConverter().fromJson(json['end_date'] as String),
      title: json['title'] as String?,
      priority: json['priority'] == null
          ? null
          : ConvertNoteRequestPriority.fromJson(json['priority'] as String),
      departmentId: json['department_id'] as String?,
      assigneeAccountIds: (json['assignee_account_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ConvertNoteRequestToJson(_ConvertNoteRequest instance) =>
    <String, dynamic>{
      'start_date': const DateOnlyConverter().toJson(instance.startDate),
      'end_date': const DateOnlyConverter().toJson(instance.endDate),
      'title': ?instance.title,
      'priority': ?_$ConvertNoteRequestPriorityEnumMap[instance.priority],
      'department_id': ?instance.departmentId,
      'assignee_account_ids': ?instance.assigneeAccountIds,
    };

const _$ConvertNoteRequestPriorityEnumMap = {
  ConvertNoteRequestPriority.dusuk: 'dusuk',
  ConvertNoteRequestPriority.orta: 'orta',
  ConvertNoteRequestPriority.yuksek: 'yuksek',
  ConvertNoteRequestPriority.acil: 'acil',
  ConvertNoteRequestPriority.$unknown: r'$unknown',
};
