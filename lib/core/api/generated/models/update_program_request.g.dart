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
  shortName: json['short_name'] as String?,
  color: json['color'] == null
      ? null
      : UpdateProgramRequestColor.fromJson(json['color'] as String),
);

Map<String, dynamic> _$UpdateProgramRequestToJson(
  _UpdateProgramRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'year': ?instance.year,
  'description': ?instance.description,
  'short_name': ?instance.shortName,
  'color': ?_$UpdateProgramRequestColorEnumMap[instance.color],
};

const _$UpdateProgramRequestColorEnumMap = {
  UpdateProgramRequestColor.violet: 'violet',
  UpdateProgramRequestColor.gold: 'gold',
  UpdateProgramRequestColor.blue: 'blue',
  UpdateProgramRequestColor.teal: 'teal',
  UpdateProgramRequestColor.green: 'green',
  UpdateProgramRequestColor.orange: 'orange',
  UpdateProgramRequestColor.red: 'red',
  UpdateProgramRequestColor.slate: 'slate',
  UpdateProgramRequestColor.valueNull: 'null',
  UpdateProgramRequestColor.$unknown: r'$unknown',
};
