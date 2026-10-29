// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'deleted_account.dart';

part 'deleted_account_list.freezed.dart';
part 'deleted_account_list.g.dart';

@Freezed()
abstract class DeletedAccountList with _$DeletedAccountList {
  const factory DeletedAccountList({
    required List<DeletedAccount> accounts,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _DeletedAccountList;

  factory DeletedAccountList.fromJson(Map<String, Object?> json) =>
      _$DeletedAccountListFromJson(json);
}
