// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'transition_request_to.dart';

part 'transition_request.freezed.dart';
part 'transition_request.g.dart';

@Freezed()
abstract class TransitionRequest with _$TransitionRequest {
  const factory TransitionRequest({
    /// Hedef durum.
    required TransitionRequestTo to,

    /// Geri alma geçişlerinde zorunlu gerekçe.
    String? reason,
    @JsonKey(name: 'pull_end_date') bool? pullEndDate,

    /// Yalnız `tamamlandi` hedefinde: açık alt görevleri aynı işlemde kapatır (ADR-0024); başka hedefte 422 `work.input_invalid`. Verilmezse açık alt görev 409 `work.subtasks_open` üretir.
    @JsonKey(name: 'close_subtasks') bool? closeSubtasks,
  }) = _TransitionRequest;

  factory TransitionRequest.fromJson(Map<String, Object?> json) =>
      _$TransitionRequestFromJson(json);
}
