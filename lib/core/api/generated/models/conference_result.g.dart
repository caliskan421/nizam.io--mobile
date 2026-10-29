// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConferenceResult _$ConferenceResultFromJson(Map<String, dynamic> json) =>
    _ConferenceResult(
      conference: Conference.fromJson(
        json['conference'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ConferenceResultToJson(_ConferenceResult instance) =>
    <String, dynamic>{'conference': instance.conference.toJson()};
