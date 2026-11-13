// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_set_cells_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableSetCellsCommand _$TableSetCellsCommandFromJson(
  Map<String, dynamic> json,
) => _TableSetCellsCommand(
  kind: TableSetCellsCommandKind.fromJson(json['kind'] as String),
  cells: (json['cells'] as List<dynamic>)
      .map((e) => TableCell.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TableSetCellsCommandToJson(
  _TableSetCellsCommand instance,
) => <String, dynamic>{
  'kind': _$TableSetCellsCommandKindEnumMap[instance.kind]!,
  'cells': instance.cells.map((e) => e.toJson()).toList(),
};

const _$TableSetCellsCommandKindEnumMap = {
  TableSetCellsCommandKind.setCells: 'set_cells',
  TableSetCellsCommandKind.$unknown: r'$unknown',
};
