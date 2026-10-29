// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_event_tool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssistantEventTool _$AssistantEventToolFromJson(Map<String, dynamic> json) =>
    _AssistantEventTool(
      arac: AssistantEventToolArac.fromJson(json['arac'] as String),
      etiket: json['etiket'] as String,
    );

Map<String, dynamic> _$AssistantEventToolToJson(_AssistantEventTool instance) =>
    <String, dynamic>{
      'arac': _$AssistantEventToolAracEnumMap[instance.arac]!,
      'etiket': instance.etiket,
    };

const _$AssistantEventToolAracEnumMap = {
  AssistantEventToolArac.bugun: 'bugun',
  AssistantEventToolArac.kapsamim: 'kapsamim',
  AssistantEventToolArac.gorevDagilimi: 'gorev_dagilimi',
  AssistantEventToolArac.gorevListesi: 'gorev_listesi',
  AssistantEventToolArac.isYuku: 'is_yuku',
  AssistantEventToolArac.toplantiOzeti: 'toplanti_ozeti',
  AssistantEventToolArac.sezonOzeti: 'sezon_ozeti',
  AssistantEventToolArac.goster: 'goster',
  AssistantEventToolArac.$unknown: r'$unknown',
};
