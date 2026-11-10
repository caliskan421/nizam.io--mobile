// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_status_result_account_status.dart';

part 'account_status_result.freezed.dart';
part 'account_status_result.g.dart';

@Freezed()
abstract class AccountStatusResult with _$AccountStatusResult {
  const factory AccountStatusResult({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'account_status')
    required AccountStatusResultAccountStatus accountStatus,

    /// Durum bu istekle değişti mi; zaten hedef durumdaysa `false` (idempotent tekrar).
    required bool changed,

    /// Kapatmada düşürülen oturum sayısı (açmada 0).
    @JsonKey(name: 'revoked_sessions') required int revokedSessions,
  }) = _AccountStatusResult;

  factory AccountStatusResult.fromJson(Map<String, Object?> json) =>
      _$AccountStatusResultFromJson(json);
}
