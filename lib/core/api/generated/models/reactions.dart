// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'kind2.dart';

part 'reactions.freezed.dart';
part 'reactions.g.dart';

@Freezed()
abstract class Reactions with _$Reactions {
  const factory Reactions({
    required Kind2 kind,
    required int count,
    required bool mine,
  }) = _Reactions;

  factory Reactions.fromJson(Map<String, Object?> json) =>
      _$ReactionsFromJson(json);
}
