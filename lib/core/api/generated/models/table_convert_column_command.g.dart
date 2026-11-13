// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_convert_column_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableConvertColumnCommand _$TableConvertColumnCommandFromJson(
  Map<String, dynamic> json,
) => _TableConvertColumnCommand(
  kind: TableConvertColumnCommandKind.fromJson(json['kind'] as String),
  id: json['id'] as String,
  type: TableColumnType.fromJson(json['type'] as String),
  expectedSchema: (json['expected_schema'] as num).toInt(),
);

Map<String, dynamic> _$TableConvertColumnCommandToJson(
  _TableConvertColumnCommand instance,
) => <String, dynamic>{
  'kind': _$TableConvertColumnCommandKindEnumMap[instance.kind]!,
  'id': instance.id,
  'type': _$TableColumnTypeEnumMap[instance.type]!,
  'expected_schema': instance.expectedSchema,
};

const _$TableConvertColumnCommandKindEnumMap = {
  TableConvertColumnCommandKind.convertColumn: 'convert_column',
  TableConvertColumnCommandKind.$unknown: r'$unknown',
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
