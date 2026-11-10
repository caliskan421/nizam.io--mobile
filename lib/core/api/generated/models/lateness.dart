// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'lateness.freezed.dart';
part 'lateness.g.dart';

@Freezed()
abstract class Lateness with _$Lateness {
  const factory Lateness({
    /// Açık görevin gecikmesi (WORK-K37): durum `tamamlandi` değilken bugün `end_on`'dan.
    /// sonraysa `true`. Bitiş günü boyunca gecikmiş değildir; gecikme ertesi günden.
    /// başlar. Gün sınırı kurulumun saat dilimidir (`GET /v1/instance/profile`.
    /// `timezone`), istemcinin yerel saati değil. Tamamlanmış görevde her zaman `false`.
    /// (geç tamamlama `is_completed_late`/`days_late` ile taşınır).
    ///
    @JsonKey(name: 'is_overdue') required bool isOverdue,

    /// Açık görevde `bugün − end_on` gün farkı (gecikmiyorsa 0); tamamlanmış görevde her zaman 0. Gün sınırı kurulumun saat dilimidir.
    @JsonKey(name: 'days_overdue') required int daysOverdue,
    @JsonKey(name: 'is_completed_late') required bool isCompletedLate,
    @JsonKey(name: 'days_late') required int daysLate,
    @JsonKey(name: 'is_completed_early') required bool isCompletedEarly,
    @JsonKey(name: 'days_early') required int daysEarly,
  }) = _Lateness;

  factory Lateness.fromJson(Map<String, Object?> json) =>
      _$LatenessFromJson(json);
}
