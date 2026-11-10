// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_program_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateProgramRequest _$UpdateProgramRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProgramRequest(
  name: json['name'] as String?,
  year: (json['year'] as num?)?.toInt(),
  description: json['description'] as String?,
  shortName: programPatchStringFromJson(json['short_name'] as String?),
  color: programPatchColorFromJson(json['color'] as String?),
);

Map<String, dynamic> _$UpdateProgramRequestToJson(
  _UpdateProgramRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'year': ?instance.year,
  'description': ?instance.description,
  if (instance.shortName != null)
    'short_name': programPatchStringToJson(instance.shortName),
  if (instance.color != null) 'color': programPatchColorToJson(instance.color),
};
