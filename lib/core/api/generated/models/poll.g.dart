// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Poll _$PollFromJson(Map<String, dynamic> json) => _Poll(
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  multi: json['multi'] as bool?,
  closesAt: json['closes_at'] == null
      ? null
      : DateTime.parse(json['closes_at'] as String),
);

Map<String, dynamic> _$PollToJson(_Poll instance) => <String, dynamic>{
  'options': instance.options,
  'multi': ?instance.multi,
  'closes_at': ?instance.closesAt?.toIso8601String(),
};
