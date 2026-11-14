// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableProject _$TableProjectFromJson(Map<String, dynamic> json) =>
    _TableProject(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      programId: json['program_id'] as String,
      departmentId: json['department_id'] as String,
      space: TableProjectSpace.fromJson(json['space'] as String),
    );

Map<String, dynamic> _$TableProjectToJson(_TableProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'program_id': instance.programId,
      'department_id': instance.departmentId,
      'space': _$TableProjectSpaceEnumMap[instance.space]!,
    };

const _$TableProjectSpaceEnumMap = {
  TableProjectSpace.personal: 'personal',
  TableProjectSpace.coordinatorship: 'coordinatorship',
  TableProjectSpace.$unknown: r'$unknown',
};
