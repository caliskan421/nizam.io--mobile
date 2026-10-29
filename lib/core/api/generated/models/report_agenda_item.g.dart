// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_agenda_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportAgendaItem _$ReportAgendaItemFromJson(Map<String, dynamic> json) =>
    _ReportAgendaItem(
      title: json['title'] as String,
      isChecked: json['is_checked'] as bool,
    );

Map<String, dynamic> _$ReportAgendaItemToJson(_ReportAgendaItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'is_checked': instance.isChecked,
    };
