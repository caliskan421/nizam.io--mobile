// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_stream_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableStreamFrame _$TableStreamFrameFromJson(Map<String, dynamic> json) =>
    _TableStreamFrame(
      tableId: json['table_id'] as String,
      sequence: (json['sequence'] as num).toInt(),
    );

Map<String, dynamic> _$TableStreamFrameToJson(_TableStreamFrame instance) =>
    <String, dynamic>{
      'table_id': instance.tableId,
      'sequence': instance.sequence,
    };
