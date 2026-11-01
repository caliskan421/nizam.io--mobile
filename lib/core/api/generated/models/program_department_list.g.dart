// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_department_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramDepartmentList _$ProgramDepartmentListFromJson(
  Map<String, dynamic> json,
) => _ProgramDepartmentList(
  departments: (json['departments'] as List<dynamic>)
      .map((e) => ProgramDepartment.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProgramDepartmentListToJson(
  _ProgramDepartmentList instance,
) => <String, dynamic>{
  'departments': instance.departments.map((e) => e.toJson()).toList(),
};
