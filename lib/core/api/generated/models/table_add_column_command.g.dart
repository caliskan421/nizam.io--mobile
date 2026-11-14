// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_add_column_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableAddColumnCommand _$TableAddColumnCommandFromJson(
  Map<String, dynamic> json,
) => _TableAddColumnCommand(
  kind: TableAddColumnCommandKind.fromJson(json['kind'] as String),
  name: json['name'] as String,
  type: TableColumnType.fromJson(json['type'] as String),
  width: (json['width'] as num).toInt(),
  expectedSchema: (json['expected_schema'] as num).toInt(),
  multiple: json['multiple'] as bool? ?? false,
);

Map<String, dynamic> _$TableAddColumnCommandToJson(
  _TableAddColumnCommand instance,
) => <String, dynamic>{
  'kind': _$TableAddColumnCommandKindEnumMap[instance.kind]!,
  'name': instance.name,
  'type': _$TableColumnTypeEnumMap[instance.type]!,
  'width': instance.width,
  'expected_schema': instance.expectedSchema,
  'multiple': instance.multiple,
};

const _$TableAddColumnCommandKindEnumMap = {
  TableAddColumnCommandKind.addColumn: 'add_column',
  TableAddColumnCommandKind.$unknown: r'$unknown',
};

const _$TableColumnTypeEnumMap = {
  TableColumnType.text: 'text',
  TableColumnType.number: 'number',
  TableColumnType.phone: 'phone',
  TableColumnType.email: 'email',
  TableColumnType.date: 'date',
  TableColumnType.checkbox: 'checkbox',
  TableColumnType.tableReference: 'table_reference',
  TableColumnType.personReference: 'person_reference',
  TableColumnType.departmentReference: 'department_reference',
  TableColumnType.taskReference: 'task_reference',
  TableColumnType.fileReference: 'file_reference',
  TableColumnType.attachment: 'attachment',
  TableColumnType.$unknown: r'$unknown',
};
