// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_column.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableColumn _$TableColumnFromJson(Map<String, dynamic> json) => _TableColumn(
  multiple: json['multiple'] as bool,
  id: json['id'] as String,
  name: json['name'] as String,
  type: TableColumnType.fromJson(json['type'] as String),
  width: (json['width'] as num).toInt(),
  position: (json['position'] as num).toInt(),
);

Map<String, dynamic> _$TableColumnToJson(_TableColumn instance) =>
    <String, dynamic>{
      'multiple': instance.multiple,
      'id': instance.id,
      'name': instance.name,
      'type': _$TableColumnTypeEnumMap[instance.type]!,
      'width': instance.width,
      'position': instance.position,
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
