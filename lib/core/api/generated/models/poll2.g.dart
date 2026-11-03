// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Poll2 _$Poll2FromJson(Map<String, dynamic> json) => _Poll2(
  multi: json['multi'] as bool,
  closesAt: json['closes_at'] == null
      ? null
      : DateTime.parse(json['closes_at'] as String),
  closedAt: json['closed_at'] == null
      ? null
      : DateTime.parse(json['closed_at'] as String),
  results: (json['results'] as List<dynamic>)
      .map((e) => Results.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$Poll2ToJson(_Poll2 instance) => <String, dynamic>{
  'multi': instance.multi,
  'closes_at': ?instance.closesAt?.toIso8601String(),
  'closed_at': ?instance.closedAt?.toIso8601String(),
  'results': instance.results.map((e) => e.toJson()).toList(),
};
