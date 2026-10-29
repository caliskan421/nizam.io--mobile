// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_event_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssistantEventUsage _$AssistantEventUsageFromJson(Map<String, dynamic> json) =>
    _AssistantEventUsage(
      girisToken: (json['giris_token'] as num).toInt(),
      cikisToken: (json['cikis_token'] as num).toInt(),
    );

Map<String, dynamic> _$AssistantEventUsageToJson(
  _AssistantEventUsage instance,
) => <String, dynamic>{
  'giris_token': instance.girisToken,
  'cikis_token': instance.cikisToken,
};
