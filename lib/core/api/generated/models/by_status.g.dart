// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'by_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ByStatus _$ByStatusFromJson(Map<String, dynamic> json) => _ByStatus(
  baslanmadi: (json['baslanmadi'] as num).toInt(),
  devamEdiyor: (json['devam_ediyor'] as num).toInt(),
  onayaSunuldu: (json['onaya_sunuldu'] as num).toInt(),
  iadeEdildi: (json['iade_edildi'] as num).toInt(),
  tamamlandi: (json['tamamlandi'] as num).toInt(),
);

Map<String, dynamic> _$ByStatusToJson(_ByStatus instance) => <String, dynamic>{
  'baslanmadi': instance.baslanmadi,
  'devam_ediyor': instance.devamEdiyor,
  'onaya_sunuldu': instance.onayaSunuldu,
  'iade_edildi': instance.iadeEdildi,
  'tamamlandi': instance.tamamlandi,
};
