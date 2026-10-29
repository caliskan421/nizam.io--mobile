// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipient_groups.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipientGroups _$RecipientGroupsFromJson(Map<String, dynamic> json) =>
    _RecipientGroups(
      groups: (json['groups'] as List<dynamic>)
          .map((e) => RecipientGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecipientGroupsToJson(_RecipientGroups instance) =>
    <String, dynamic>{
      'groups': instance.groups.map((e) => e.toJson()).toList(),
    };
