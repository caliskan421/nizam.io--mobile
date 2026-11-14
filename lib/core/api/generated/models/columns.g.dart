// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'columns.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Columns _$ColumnsFromJson(Map<String, dynamic> json) => _Columns(
  name: json['name'] as String,
  type: TableColumnType.fromJson(json['type'] as String),
  multiple: json['multiple'] as bool,
);

Map<String, dynamic> _$ColumnsToJson(_Columns instance) => <String, dynamic>{
  'name': instance.name,
  'type': _$TableColumnTypeEnumMap[instance.type]!,
  'multiple': instance.multiple,
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
