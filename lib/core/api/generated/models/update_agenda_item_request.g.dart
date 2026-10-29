// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_agenda_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateAgendaItemRequest _$UpdateAgendaItemRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateAgendaItemRequest(
  title: json['title'] as String?,
  isChecked: json['is_checked'] as bool?,
);

Map<String, dynamic> _$UpdateAgendaItemRequestToJson(
  _UpdateAgendaItemRequest instance,
) => <String, dynamic>{
  'title': ?instance.title,
  'is_checked': ?instance.isChecked,
};
