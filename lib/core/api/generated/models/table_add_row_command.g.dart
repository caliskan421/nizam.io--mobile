// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_add_row_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableAddRowCommand _$TableAddRowCommandFromJson(Map<String, dynamic> json) =>
    _TableAddRowCommand(
      kind: TableAddRowCommandKind.fromJson(json['kind'] as String),
    );

Map<String, dynamic> _$TableAddRowCommandToJson(_TableAddRowCommand instance) =>
    <String, dynamic>{'kind': _$TableAddRowCommandKindEnumMap[instance.kind]!};

const _$TableAddRowCommandKindEnumMap = {
  TableAddRowCommandKind.addRow: 'add_row',
  TableAddRowCommandKind.$unknown: r'$unknown',
};
