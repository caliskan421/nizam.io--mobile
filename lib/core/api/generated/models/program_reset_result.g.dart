// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_reset_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramResetResult _$ProgramResetResultFromJson(Map<String, dynamic> json) =>
    _ProgramResetResult(
      programId: json['program_id'] as String,
      tasks: (json['tasks'] as num).toInt(),
      files: (json['files'] as num).toInt(),
      messages: (json['messages'] as num).toInt(),
      meetings: (json['meetings'] as num).toInt(),
    );

Map<String, dynamic> _$ProgramResetResultToJson(_ProgramResetResult instance) =>
    <String, dynamic>{
      'program_id': instance.programId,
      'tasks': instance.tasks,
      'files': instance.files,
      'messages': instance.messages,
      'meetings': instance.meetings,
    };
