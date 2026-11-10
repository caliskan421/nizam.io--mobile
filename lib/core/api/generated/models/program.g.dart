// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Program _$ProgramFromJson(Map<String, dynamic> json) => _Program(
  programId: json['program_id'] as String,
  name: json['name'] as String,
  shortName: json['short_name'] as String?,
  color: json['color'] == null
      ? null
      : ProgramColor.fromJson(json['color'] as String),
  year: (json['year'] as num?)?.toInt(),
  description: json['description'] as String?,
  created: json['created'] as bool?,
);

Map<String, dynamic> _$ProgramToJson(_Program instance) => <String, dynamic>{
  'program_id': instance.programId,
  'name': instance.name,
  'short_name': ?instance.shortName,
  'color': ?_$ProgramColorEnumMap[instance.color],
  'year': ?instance.year,
  'description': ?instance.description,
  'created': ?instance.created,
};

const _$ProgramColorEnumMap = {
  ProgramColor.violet: 'violet',
  ProgramColor.gold: 'gold',
  ProgramColor.blue: 'blue',
  ProgramColor.teal: 'teal',
  ProgramColor.green: 'green',
  ProgramColor.orange: 'orange',
  ProgramColor.red: 'red',
  ProgramColor.slate: 'slate',
  ProgramColor.valueNull: 'null',
  ProgramColor.$unknown: r'$unknown',
};
