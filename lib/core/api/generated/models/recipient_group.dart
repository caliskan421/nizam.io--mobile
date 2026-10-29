// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'recipient.dart';

part 'recipient_group.freezed.dart';
part 'recipient_group.g.dart';

@Freezed()
abstract class RecipientGroup with _$RecipientGroup {
  const factory RecipientGroup({
    required String key,
    required List<Recipient> recipients,

    /// Grup tavanla kırpıldıysa `true`.
    required bool truncated,
  }) = _RecipientGroup;

  factory RecipientGroup.fromJson(Map<String, Object?> json) =>
      _$RecipientGroupFromJson(json);
}
