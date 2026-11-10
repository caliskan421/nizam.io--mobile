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
  shortName: json['short_name'] as String?,
  color: json['color'] == null
      ? null
      : CreateProgramRequestColor.fromJson(json['color'] as String),
);

Map<String, dynamic> _$CreateProgramRequestToJson(
  _CreateProgramRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'year': ?instance.year,
  'description': ?instance.description,
  'short_name': ?instance.shortName,
  'color': ?_$CreateProgramRequestColorEnumMap[instance.color],
};

const _$CreateProgramRequestColorEnumMap = {
  CreateProgramRequestColor.violet: 'violet',
  CreateProgramRequestColor.gold: 'gold',
  CreateProgramRequestColor.blue: 'blue',
  CreateProgramRequestColor.teal: 'teal',
  CreateProgramRequestColor.green: 'green',
  CreateProgramRequestColor.orange: 'orange',
  CreateProgramRequestColor.red: 'red',
  CreateProgramRequestColor.slate: 'slate',
  CreateProgramRequestColor.valueNull: 'null',
  CreateProgramRequestColor.$unknown: r'$unknown',
};
