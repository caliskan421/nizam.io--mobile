// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Results _$ResultsFromJson(Map<String, dynamic> json) => _Results(
  optionIndex: (json['option_index'] as num).toInt(),
  label: json['label'] as String,
  count: (json['count'] as num).toInt(),
  voters: (json['voters'] as List<dynamic>)
      .map((e) => Voters.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ResultsToJson(_Results instance) => <String, dynamic>{
  'option_index': instance.optionIndex,
  'label': instance.label,
  'count': instance.count,
  'voters': instance.voters.map((e) => e.toJson()).toList(),
};
