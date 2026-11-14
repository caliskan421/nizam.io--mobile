// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_grant_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableGrantCommand _$TableGrantCommandFromJson(Map<String, dynamic> json) =>
    _TableGrantCommand(
      kind: TableGrantCommandKind.fromJson(json['kind'] as String),
      accountId: json['account_id'] as String,
      role: TableGrantCommandRole.fromJson(json['role'] as String),
    );

Map<String, dynamic> _$TableGrantCommandToJson(_TableGrantCommand instance) =>
    <String, dynamic>{
      'kind': _$TableGrantCommandKindEnumMap[instance.kind]!,
      'account_id': instance.accountId,
      'role': _$TableGrantCommandRoleEnumMap[instance.role]!,
    };

const _$TableGrantCommandKindEnumMap = {
  TableGrantCommandKind.grant: 'grant',
  TableGrantCommandKind.$unknown: r'$unknown',
};

const _$TableGrantCommandRoleEnumMap = {
  TableGrantCommandRole.editor: 'editor',
  TableGrantCommandRole.viewer: 'viewer',
  TableGrantCommandRole.$unknown: r'$unknown',
};
