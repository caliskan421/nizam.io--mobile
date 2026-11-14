// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_propose_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableProposeCommand _$TableProposeCommandFromJson(Map<String, dynamic> json) =>
    _TableProposeCommand(
      kind: TableProposeCommandKind.fromJson(json['kind'] as String),
      targetSpace: TableProposeCommandTargetSpace.fromJson(
        json['target_space'] as String,
      ),
      targetDepartmentId: json['target_department_id'] as String,
      targetProjectId: json['target_project_id'] as String?,
      role: json['role'] == null
          ? null
          : TableProposeCommandRole.fromJson(json['role'] as String),
    );

Map<String, dynamic> _$TableProposeCommandToJson(
  _TableProposeCommand instance,
) => <String, dynamic>{
  'kind': _$TableProposeCommandKindEnumMap[instance.kind]!,
  'target_space':
      _$TableProposeCommandTargetSpaceEnumMap[instance.targetSpace]!,
  'target_department_id': instance.targetDepartmentId,
  'target_project_id': ?instance.targetProjectId,
  'role': ?_$TableProposeCommandRoleEnumMap[instance.role],
};

const _$TableProposeCommandKindEnumMap = {
  TableProposeCommandKind.proposeMove: 'propose_move',
  TableProposeCommandKind.proposeCopy: 'propose_copy',
  TableProposeCommandKind.$unknown: r'$unknown',
};

const _$TableProposeCommandTargetSpaceEnumMap = {
  TableProposeCommandTargetSpace.coordinatorship: 'coordinatorship',
  TableProposeCommandTargetSpace.$unknown: r'$unknown',
};

const _$TableProposeCommandRoleEnumMap = {
  TableProposeCommandRole.editor: 'editor',
  TableProposeCommandRole.viewer: 'viewer',
  TableProposeCommandRole.$unknown: r'$unknown',
};
