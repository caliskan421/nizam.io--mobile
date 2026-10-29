// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'assistant_event_tool_arac.dart';

part 'assistant_event_tool.freezed.dart';
part 'assistant_event_tool.g.dart';

@Freezed()
abstract class AssistantEventTool with _$AssistantEventTool {
  const factory AssistantEventTool({
    required AssistantEventToolArac arac,

    /// Arayüzde gösterilecek kısa metin.
    required String etiket,
  }) = _AssistantEventTool;

  factory AssistantEventTool.fromJson(Map<String, Object?> json) =>
      _$AssistantEventToolFromJson(json);
}
