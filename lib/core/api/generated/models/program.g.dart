// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Program _$ProgramFromJson(Map<String, dynamic> json) => _Program(
  programId: json['program_id'] as String,
  name: json['name'] as String,
  year: (json['year'] as num?)?.toInt(),
  description: json['description'] as String?,
  created: json['created'] as bool?,
);

Map<String, dynamic> _$ProgramToJson(_Program instance) => <String, dynamic>{
  'program_id': instance.programId,
  'name': instance.name,
  'year': ?instance.year,
  'description': ?instance.description,
  'created': ?instance.created,
};
