// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'kind.dart';

part 'refs.freezed.dart';
part 'refs.g.dart';

@Freezed()
abstract class Refs with _$Refs {
  const factory Refs({
    required Kind kind,
    @JsonKey(name: 'target_id') required String targetId,
  }) = _Refs;

  factory Refs.fromJson(Map<String, Object?> json) => _$RefsFromJson(json);
}
