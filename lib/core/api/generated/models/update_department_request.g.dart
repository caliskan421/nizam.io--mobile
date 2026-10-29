// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_department_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateDepartmentRequest _$UpdateDepartmentRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateDepartmentRequest(
  name: json['name'] as String?,
  kind: json['kind'] == null
      ? null
      : UpdateDepartmentRequestKind.fromJson(json['kind'] as String),
  code: json['code'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$UpdateDepartmentRequestToJson(
  _UpdateDepartmentRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'kind': ?_$UpdateDepartmentRequestKindEnumMap[instance.kind],
  'code': ?instance.code,
  'description': ?instance.description,
};

const _$UpdateDepartmentRequestKindEnumMap = {
  UpdateDepartmentRequestKind.koordinatorluk: 'koordinatorluk',
  UpdateDepartmentRequestKind.calismaGrubu: 'calisma_grubu',
  UpdateDepartmentRequestKind.$unknown: r'$unknown',
};
