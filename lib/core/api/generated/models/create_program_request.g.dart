// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_program_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateProgramRequest _$CreateProgramRequestFromJson(
  Map<String, dynamic> json,
) => _CreateProgramRequest(
  name: json['name'] as String,
  year: (json['year'] as num?)?.toInt(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$CreateProgramRequestToJson(
  _CreateProgramRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'year': ?instance.year,
  'description': ?instance.description,
};
