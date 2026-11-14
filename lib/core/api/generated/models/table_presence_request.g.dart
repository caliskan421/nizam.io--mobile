// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_presence_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TablePresenceRequest _$TablePresenceRequestFromJson(
  Map<String, dynamic> json,
) => _TablePresenceRequest(
  rowId: json['row_id'] as String?,
  columnId: json['column_id'] as String?,
);

Map<String, dynamic> _$TablePresenceRequestToJson(
  _TablePresenceRequest instance,
) => <String, dynamic>{
  'row_id': ?instance.rowId,
  'column_id': ?instance.columnId,
};
