// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'by_status.freezed.dart';
part 'by_status.g.dart';

@Freezed()
abstract class ByStatus with _$ByStatus {
  const factory ByStatus({
    required int baslanmadi,
    @JsonKey(name: 'devam_ediyor') required int devamEdiyor,
    @JsonKey(name: 'onaya_sunuldu') required int onayaSunuldu,
    @JsonKey(name: 'iade_edildi') required int iadeEdildi,
    required int tamamlandi,
  }) = _ByStatus;

  factory ByStatus.fromJson(Map<String, Object?> json) =>
      _$ByStatusFromJson(json);
}
