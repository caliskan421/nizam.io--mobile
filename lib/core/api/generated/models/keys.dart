// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'keys.freezed.dart';
part 'keys.g.dart';

@Freezed()
abstract class Keys with _$Keys {
  const factory Keys({required String p256dh, required String auth}) = _Keys;

  factory Keys.fromJson(Map<String, Object?> json) => _$KeysFromJson(json);
}
