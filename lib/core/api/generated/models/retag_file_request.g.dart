// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retag_file_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RetagFileRequest _$RetagFileRequestFromJson(Map<String, dynamic> json) =>
    _RetagFileRequest(tag: RetagFileRequestTag.fromJson(json['tag'] as String));

Map<String, dynamic> _$RetagFileRequestToJson(_RetagFileRequest instance) =>
    <String, dynamic>{'tag': _$RetagFileRequestTagEnumMap[instance.tag]!};

const _$RetagFileRequestTagEnumMap = {
  RetagFileRequestTag.ister: 'ister',
  RetagFileRequestTag.plan: 'plan',
  RetagFileRequestTag.girdi: 'girdi',
  RetagFileRequestTag.analiz: 'analiz',
  RetagFileRequestTag.cikti: 'cikti',
  RetagFileRequestTag.sonuc: 'sonuc',
  RetagFileRequestTag.$unknown: r'$unknown',
};
