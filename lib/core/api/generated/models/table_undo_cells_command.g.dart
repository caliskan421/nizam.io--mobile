// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_undo_cells_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableUndoCellsCommand _$TableUndoCellsCommandFromJson(
  Map<String, dynamic> json,
) => _TableUndoCellsCommand(
  kind: TableUndoCellsCommandKind.fromJson(json['kind'] as String),
  sequence: (json['sequence'] as num).toInt(),
);

Map<String, dynamic> _$TableUndoCellsCommandToJson(
  _TableUndoCellsCommand instance,
) => <String, dynamic>{
  'kind': _$TableUndoCellsCommandKindEnumMap[instance.kind]!,
  'sequence': instance.sequence,
};

const _$TableUndoCellsCommandKindEnumMap = {
  TableUndoCellsCommandKind.undoCells: 'undo_cells',
  TableUndoCellsCommandKind.$unknown: r'$unknown',
};
