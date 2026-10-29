// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'transition_result_actor.dart';

part 'transition_result.freezed.dart';
part 'transition_result.g.dart';

@Freezed()
abstract class TransitionResult with _$TransitionResult {
  const factory TransitionResult({
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String from,
    required String to,
    required TransitionResultActor actor,
    @JsonKey(name: 'end_on') DateTime? endOn,
  }) = _TransitionResult;

  factory TransitionResult.fromJson(Map<String, Object?> json) =>
      _$TransitionResultFromJson(json);
}
