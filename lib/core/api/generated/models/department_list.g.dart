// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DepartmentList _$DepartmentListFromJson(Map<String, dynamic> json) =>
    _DepartmentList(
      departments: (json['departments'] as List<dynamic>)
          .map((e) => Department.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DepartmentListToJson(_DepartmentList instance) =>
    <String, dynamic>{
      'departments': instance.departments.map((e) => e.toJson()).toList(),
    };
