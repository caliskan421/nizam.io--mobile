// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'extend_request.freezed.dart';
part 'extend_request.g.dart';

@Freezed()
abstract class ExtendRequest with _$ExtendRequest {
  const factory ExtendRequest({
    /// Ek gün sayısı, 1–90 (aksi 422 `work.input_invalid`).
    required int days,

    /// İsteğe bağlı: istemcinin gördüğü tarih sürümü (`dates_revision`; WORK-K89). Verilirse kilit altındaki güncel sürümle karşılaştırılır; farklıysa 409 `work.edit_conflict` (`fields[0].field = expected_dates_revision`), uzatma uygulanmaz. Pozitif değilse 422 `work.input_invalid` (alan kodu `work.revision_invalid`). Uzatma göreli olduğundan ADR-0027'nin "istenen değer zaten güncelse 200" kuralı yoktur.
    @JsonKey(name: 'expected_dates_revision') int? expectedDatesRevision,
  }) = _ExtendRequest;

  factory ExtendRequest.fromJson(Map<String, Object?> json) =>
      _$ExtendRequestFromJson(json);
}
