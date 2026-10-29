// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'conference_status.dart';

part 'conference.freezed.dart';
part 'conference.g.dart';

/// Toplantıya bağlı görüntülü konferansın istemci görünümü (ADR-0015 Ek B §3.1).
@Freezed()
abstract class Conference with _$Conference {
  const factory Conference({
    required String id,

    /// starting: sağlayıcı onayı bekleniyor; live: sürüyor; ending: kapatıldı, oda henüz kapanmadı.
    required ConferenceStatus status,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'started_by_account_id') required String startedByAccountId,
  }) = _Conference;

  factory Conference.fromJson(Map<String, Object?> json) =>
      _$ConferenceFromJson(json);
}
