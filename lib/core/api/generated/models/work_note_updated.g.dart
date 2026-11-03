// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_note_updated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkNoteUpdated _$WorkNoteUpdatedFromJson(Map<String, dynamic> json) =>
    _WorkNoteUpdated(
      status: json['status'] as String,
      editRevision: (json['edit_revision'] as num).toInt(),
    );

Map<String, dynamic> _$WorkNoteUpdatedToJson(_WorkNoteUpdated instance) =>
    <String, dynamic>{
      'status': instance.status,
      'edit_revision': instance.editRevision,
    };
