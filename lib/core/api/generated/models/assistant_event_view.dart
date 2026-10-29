// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_event_view.freezed.dart';
part 'assistant_event_view.g.dart';

@Freezed()
abstract class AssistantEventView with _$AssistantEventView {
  const factory AssistantEventView({
    /// Katalogdaki görünüm adı; istemci rotaya çevirir ve veriyi normal API'den çeker.
    required String gorunum,

    /// Çözümlenmiş tipli süzgeç.
    required dynamic filtre,
  }) = _AssistantEventView;

  factory AssistantEventView.fromJson(Map<String, Object?> json) =>
      _$AssistantEventViewFromJson(json);
}
