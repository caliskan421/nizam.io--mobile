// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipient.freezed.dart';
part 'recipient.g.dart';

@Freezed()
abstract class Recipient with _$Recipient {
  const factory Recipient({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,
  }) = _Recipient;

  factory Recipient.fromJson(Map<String, Object?> json) =>
      _$RecipientFromJson(json);
}
