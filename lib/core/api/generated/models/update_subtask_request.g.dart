// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_subtask_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateSubtaskRequest _$UpdateSubtaskRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateSubtaskRequest(
  title: json['title'] as String?,
  assigneeAccountId: json['assignee_account_id'] as String?,
  startOn: json['start_on'] as String?,
  endOn: json['end_on'] as String?,
  done: json['done'] as bool?,
);

Map<String, dynamic> _$UpdateSubtaskRequestToJson(
  _UpdateSubtaskRequest instance,
) => <String, dynamic>{
  'title': ?instance.title,
  'assignee_account_id': ?instance.assigneeAccountId,
  'start_on': ?instance.startOn,
  'end_on': ?instance.endOn,
  'done': ?instance.done,
};
