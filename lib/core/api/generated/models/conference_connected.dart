// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'conference_connected.freezed.dart';
part 'conference_connected.g.dart';

/// Bağlı kişiler (COLLABORATION-K78): uzlaştırma turunun son gözlediği, toplantıya erişimi geçerli bağlı hesaplar. Anlık görüntüdür, yetki kararı değildir. Tazelik `NIZAMIO_VIDEO_RECONCILE_INTERVAL` (varsayılan 1 dk) içindedir; sağlayıcı okunamazsa önceki görüntü kalır ve `observed_at` eskir. Hiç gözlenmediyse `count` 0, `observed_at` null. Oda adı ve token taşınmaz.
@Freezed()
abstract class ConferenceConnected with _$ConferenceConnected {
  const factory ConferenceConnected({
    required int count,

    /// Sıralı ve tekil hesap kimlikleri.
    @JsonKey(name: 'account_ids') required List<String> accountIds,
    @JsonKey(name: 'observed_at') required DateTime? observedAt,
  }) = _ConferenceConnected;

  factory ConferenceConnected.fromJson(Map<String, Object?> json) =>
      _$ConferenceConnectedFromJson(json);
}
