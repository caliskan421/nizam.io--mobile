// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'assistant_event_error_kod.dart';

part 'assistant_event_error.freezed.dart';
part 'assistant_event_error.g.dart';

/// Akış başladıktan sonra doğan hata (HTTP 200 içinde; akışın son olayı).
@Freezed()
abstract class AssistantEventError with _$AssistantEventError {
  const factory AssistantEventError({
    required AssistantEventErrorKod kod,

    /// Kullanıcıya gösterilebilir Türkçe metin; iç ayrıntı taşımaz.
    required String mesaj,
  }) = _AssistantEventError;

  factory AssistantEventError.fromJson(Map<String, Object?> json) =>
      _$AssistantEventErrorFromJson(json);
}
