// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference_connected.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConferenceConnected _$ConferenceConnectedFromJson(Map<String, dynamic> json) =>
    _ConferenceConnected(
      count: (json['count'] as num).toInt(),
      accountIds: (json['account_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      observedAt: json['observed_at'] == null
          ? null
          : DateTime.parse(json['observed_at'] as String),
    );

Map<String, dynamic> _$ConferenceConnectedToJson(
  _ConferenceConnected instance,
) => <String, dynamic>{
  'count': instance.count,
  'account_ids': instance.accountIds,
  'observed_at': ?instance.observedAt?.toIso8601String(),
};
