// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_revoke_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableRevokeCommand _$TableRevokeCommandFromJson(Map<String, dynamic> json) =>
    _TableRevokeCommand(
      kind: TableRevokeCommandKind.fromJson(json['kind'] as String),
      accountId: json['account_id'] as String,
    );

Map<String, dynamic> _$TableRevokeCommandToJson(_TableRevokeCommand instance) =>
    <String, dynamic>{
      'kind': _$TableRevokeCommandKindEnumMap[instance.kind]!,
      'account_id': instance.accountId,
    };

const _$TableRevokeCommandKindEnumMap = {
  TableRevokeCommandKind.revoke: 'revoke',
  TableRevokeCommandKind.$unknown: r'$unknown',
};
