// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'agenda_item_request.freezed.dart';
part 'agenda_item_request.g.dart';

@Freezed()
abstract class AgendaItemRequest with _$AgendaItemRequest {
  const factory AgendaItemRequest({
    /// Madde başlığı. Sunucu düz metne indirir ve kırpar; sonuç boş olamaz, kontrol karakteri taşıyamaz ve en çok 300 karakterdir (Unicode kod noktası, düz metne indirildikten sonra); aksi 422 `collaboration.input_invalid` (alan `title`). Toplantı başına en çok 50 madde; aşım 422 `collaboration.agenda_limit_reached` (COLLABORATION-K24).
    required String title,
  }) = _AgendaItemRequest;

  factory AgendaItemRequest.fromJson(Map<String, Object?> json) =>
      _$AgendaItemRequestFromJson(json);
}
