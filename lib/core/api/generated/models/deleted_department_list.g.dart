// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_department_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeletedDepartmentList _$DeletedDepartmentListFromJson(
  Map<String, dynamic> json,
) => _DeletedDepartmentList(
  departments: (json['departments'] as List<dynamic>)
      .map((e) => DeletedDepartment.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$DeletedDepartmentListToJson(
  _DeletedDepartmentList instance,
) => <String, dynamic>{
  'departments': instance.departments.map((e) => e.toJson()).toList(),
  'next_cursor': ?instance.nextCursor,
};
