// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_department_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyDepartmentList _$MyDepartmentListFromJson(Map<String, dynamic> json) =>
    _MyDepartmentList(
      departments: (json['departments'] as List<dynamic>?)
          ?.map((e) => MyDepartment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyDepartmentListToJson(_MyDepartmentList instance) =>
    <String, dynamic>{
      'departments': ?instance.departments?.map((e) => e.toJson()).toList(),
    };
