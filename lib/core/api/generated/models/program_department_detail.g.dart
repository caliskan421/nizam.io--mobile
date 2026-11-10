// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_department_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramDepartmentDetail _$ProgramDepartmentDetailFromJson(
  Map<String, dynamic> json,
) => _ProgramDepartmentDetail(
  departmentId: json['department_id'] as String,
  displayName: json['display_name'] as String,
  kind: ProgramDepartmentDetailKind.fromJson(json['kind'] as String),
  code: json['code'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$ProgramDepartmentDetailToJson(
  _ProgramDepartmentDetail instance,
) => <String, dynamic>{
  'department_id': instance.departmentId,
  'display_name': instance.displayName,
  'kind': _$ProgramDepartmentDetailKindEnumMap[instance.kind]!,
  'code': ?instance.code,
  'description': ?instance.description,
};

const _$ProgramDepartmentDetailKindEnumMap = {
  ProgramDepartmentDetailKind.koordinatorluk: 'koordinatorluk',
  ProgramDepartmentDetailKind.calismaGrubu: 'calisma_grubu',
  ProgramDepartmentDetailKind.$unknown: r'$unknown',
};
