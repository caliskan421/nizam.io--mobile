// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_event_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssistantEventError _$AssistantEventErrorFromJson(Map<String, dynamic> json) =>
    _AssistantEventError(
      kod: AssistantEventErrorKod.fromJson(json['kod'] as String),
      mesaj: json['mesaj'] as String,
    );

Map<String, dynamic> _$AssistantEventErrorToJson(
  _AssistantEventError instance,
) => <String, dynamic>{
  'kod': _$AssistantEventErrorKodEnumMap[instance.kod]!,
  'mesaj': instance.mesaj,
};

const _$AssistantEventErrorKodEnumMap = {
  AssistantEventErrorKod.undefined0: 'assistant.limit_exceeded',
  AssistantEventErrorKod.undefined1: 'assistant.refused',
  AssistantEventErrorKod.undefined2: 'assistant.provider_unavailable',
  AssistantEventErrorKod.undefined3: 'platform.internal',
  AssistantEventErrorKod.$unknown: r'$unknown',
};
