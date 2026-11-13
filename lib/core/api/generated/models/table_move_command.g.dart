// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_move_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableMoveCommand _$TableMoveCommandFromJson(Map<String, dynamic> json) =>
    _TableMoveCommand(
      kind: TableMoveCommandKind.fromJson(json['kind'] as String),
      targetSpace: TableMoveCommandTargetSpace.fromJson(
        json['target_space'] as String,
      ),
      targetDepartmentId: json['target_department_id'] as String?,
      targetProjectId: json['target_project_id'] as String?,
    );

Map<String, dynamic> _$TableMoveCommandToJson(
  _TableMoveCommand instance,
) => <String, dynamic>{
  'kind': _$TableMoveCommandKindEnumMap[instance.kind]!,
  'target_space': _$TableMoveCommandTargetSpaceEnumMap[instance.targetSpace]!,
  'target_department_id': ?instance.targetDepartmentId,
  'target_project_id': ?instance.targetProjectId,
};

const _$TableMoveCommandKindEnumMap = {
  TableMoveCommandKind.moveTable: 'move_table',
  TableMoveCommandKind.$unknown: r'$unknown',
};

const _$TableMoveCommandTargetSpaceEnumMap = {
  TableMoveCommandTargetSpace.personal: 'personal',
  TableMoveCommandTargetSpace.coordinatorship: 'coordinatorship',
  TableMoveCommandTargetSpace.$unknown: r'$unknown',
};
