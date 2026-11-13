// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableCreateRequest _$TableCreateRequestFromJson(Map<String, dynamic> json) =>
    _TableCreateRequest(
      name: json['name'] as String,
      kind: json['kind'] == null
          ? null
          : TableCreateRequestKind.fromJson(json['kind'] as String),
    );

Map<String, dynamic> _$TableCreateRequestToJson(_TableCreateRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'kind': ?_$TableCreateRequestKindEnumMap[instance.kind],
    };

const _$TableCreateRequestKindEnumMap = {
  TableCreateRequestKind.createTable: 'create_table',
  TableCreateRequestKind.$unknown: r'$unknown',
};
