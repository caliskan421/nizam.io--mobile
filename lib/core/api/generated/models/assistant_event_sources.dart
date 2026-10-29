// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_event_sources.freezed.dart';
part 'assistant_event_sources.g.dart';

@Freezed()
abstract class AssistantEventSources with _$AssistantEventSources {
  const factory AssistantEventSources({
    /// Cevabın dayandığı araç adları.
    required List<String> kaynaklar,
  }) = _AssistantEventSources;

  factory AssistantEventSources.fromJson(Map<String, Object?> json) =>
      _$AssistantEventSourcesFromJson(json);
}
