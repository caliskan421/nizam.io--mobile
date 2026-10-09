// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roster_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RosterList _$RosterListFromJson(Map<String, dynamic> json) => _RosterList(
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => RosterMember.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RosterListToJson(_RosterList instance) =>
    <String, dynamic>{
      'members': ?instance.members?.map((e) => e.toJson()).toList(),
    };
