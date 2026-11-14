// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_delete_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableDeleteCommand _$TableDeleteCommandFromJson(Map<String, dynamic> json) =>
    _TableDeleteCommand(
      kind: TableDeleteCommandKind.fromJson(json['kind'] as String),
    );

Map<String, dynamic> _$TableDeleteCommandToJson(_TableDeleteCommand instance) =>
    <String, dynamic>{'kind': _$TableDeleteCommandKindEnumMap[instance.kind]!};

const _$TableDeleteCommandKindEnumMap = {
  TableDeleteCommandKind.deleteTable: 'delete_table',
  TableDeleteCommandKind.$unknown: r'$unknown',
};
