// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_result.freezed.dart';
part 'account_result.g.dart';

@Freezed()
abstract class AccountResult with _$AccountResult {
  const factory AccountResult({
    @JsonKey(name: 'account_id') required String accountId,

    /// Düşürülen oturum sayısı; sıfırsa alan yoktur.
    @JsonKey(name: 'revoked_sessions') int? revokedSessions,
  }) = _AccountResult;

  factory AccountResult.fromJson(Map<String, Object?> json) =>
      _$AccountResultFromJson(json);
}
