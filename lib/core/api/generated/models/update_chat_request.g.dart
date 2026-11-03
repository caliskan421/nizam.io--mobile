// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateChatRequest _$UpdateChatRequestFromJson(Map<String, dynamic> json) =>
    _UpdateChatRequest(
      name: json['name'] as String?,
      source: json['source'] == null
          ? null
          : UpdateChatRequestSource.fromJson(json['source'] as String),
      sourceDepartmentId: json['source_department_id'] as String?,
    );

Map<String, dynamic> _$UpdateChatRequestToJson(_UpdateChatRequest instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'source': ?_$UpdateChatRequestSourceEnumMap[instance.source],
      'source_department_id': ?instance.sourceDepartmentId,
    };

const _$UpdateChatRequestSourceEnumMap = {
  UpdateChatRequestSource.none: 'none',
  UpdateChatRequestSource.department: 'department',
  UpdateChatRequestSource.program: 'program',
  UpdateChatRequestSource.$unknown: r'$unknown',
};
