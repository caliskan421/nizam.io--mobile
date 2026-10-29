// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_department_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateDepartmentRequest _$CreateDepartmentRequestFromJson(
  Map<String, dynamic> json,
) => _CreateDepartmentRequest(
  name: json['name'] as String,
  kind: CreateDepartmentRequestKind.fromJson(json['kind'] as String),
  code: json['code'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$CreateDepartmentRequestToJson(
  _CreateDepartmentRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'kind': _$CreateDepartmentRequestKindEnumMap[instance.kind]!,
  'code': ?instance.code,
  'description': ?instance.description,
};

const _$CreateDepartmentRequestKindEnumMap = {
  CreateDepartmentRequestKind.koordinatorluk: 'koordinatorluk',
  CreateDepartmentRequestKind.calismaGrubu: 'calisma_grubu',
  CreateDepartmentRequestKind.$unknown: r'$unknown',
};
