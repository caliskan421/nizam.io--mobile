// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_public_key.freezed.dart';
part 'push_public_key.g.dart';

@Freezed()
abstract class PushPublicKey with _$PushPublicKey {
  const factory PushPublicKey({
    @JsonKey(name: 'public_key') required String publicKey,
    required bool enabled,
  }) = _PushPublicKey;

  factory PushPublicKey.fromJson(Map<String, Object?> json) =>
      _$PushPublicKeyFromJson(json);
}
