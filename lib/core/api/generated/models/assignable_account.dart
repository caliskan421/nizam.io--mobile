// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignable_account.freezed.dart';
part 'assignable_account.g.dart';

@Freezed()
abstract class AssignableAccount with _$AssignableAccount {
  const factory AssignableAccount({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,

    /// Hesabın hedef departman dışındaki rol bağları ("departman:rol").
    required List<String>? roles,
  }) = _AssignableAccount;

  factory AssignableAccount.fromJson(Map<String, Object?> json) =>
      _$AssignableAccountFromJson(json);
}
