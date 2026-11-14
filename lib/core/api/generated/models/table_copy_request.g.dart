// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_copy_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableCopyRequest _$TableCopyRequestFromJson(Map<String, dynamic> json) =>
    _TableCopyRequest(
      sourceTableId: json['source_table_id'] as String,
      sourceSpace: TableCopyRequestSourceSpace.fromJson(
        json['source_space'] as String,
      ),
      mode: TableCopyRequestMode.fromJson(json['mode'] as String),
      sourceProgramId: json['source_program_id'] as String?,
      sourceDepartmentId: json['source_department_id'] as String?,
      name: json['name'] as String?,
      projectId: json['project_id'] as String?,
    );

Map<String, dynamic> _$TableCopyRequestToJson(
  _TableCopyRequest instance,
) => <String, dynamic>{
  'source_table_id': instance.sourceTableId,
  'source_space': _$TableCopyRequestSourceSpaceEnumMap[instance.sourceSpace]!,
  'mode': _$TableCopyRequestModeEnumMap[instance.mode]!,
  'source_program_id': ?instance.sourceProgramId,
  'source_department_id': ?instance.sourceDepartmentId,
  'name': ?instance.name,
  'project_id': ?instance.projectId,
};

const _$TableCopyRequestSourceSpaceEnumMap = {
  TableCopyRequestSourceSpace.personal: 'personal',
  TableCopyRequestSourceSpace.coordinatorship: 'coordinatorship',
  TableCopyRequestSourceSpace.$unknown: r'$unknown',
};

const _$TableCopyRequestModeEnumMap = {
  TableCopyRequestMode.structure: 'structure',
  TableCopyRequestMode.full: 'full',
  TableCopyRequestMode.$unknown: r'$unknown',
};
