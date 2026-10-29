// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssistantMessage _$AssistantMessageFromJson(Map<String, dynamic> json) =>
    _AssistantMessage(
      sira: (json['sira'] as num).toInt(),
      rol: AssistantMessageRol.fromJson(json['rol'] as String),
      icerik: json['icerik'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AssistantMessageToJson(_AssistantMessage instance) =>
    <String, dynamic>{
      'sira': instance.sira,
      'rol': _$AssistantMessageRolEnumMap[instance.rol]!,
      'icerik': instance.icerik,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$AssistantMessageRolEnumMap = {
  AssistantMessageRol.kullanici: 'kullanici',
  AssistantMessageRol.asistan: 'asistan',
  AssistantMessageRol.$unknown: r'$unknown',
};
