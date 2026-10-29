// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'deleted_account.freezed.dart';
part 'deleted_account.g.dart';

@Freezed()
abstract class DeletedAccount with _$DeletedAccount {
  const factory DeletedAccount({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,
  }) = _DeletedAccount;

  factory DeletedAccount.fromJson(Map<String, Object?> json) =>
      _$DeletedAccountFromJson(json);
}
