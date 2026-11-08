// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Refs _$RefsFromJson(Map<String, dynamic> json) => _Refs(
  kind: Kind.fromJson(json['kind'] as String),
  targetId: json['target_id'] as String,
);

Map<String, dynamic> _$RefsToJson(_Refs instance) => <String, dynamic>{
  'kind': _$KindEnumMap[instance.kind]!,
  'target_id': instance.targetId,
};

const _$KindEnumMap = {
  Kind.task: 'task',
  Kind.department: 'department',
  Kind.file: 'file',
  Kind.$unknown: r'$unknown',
};
