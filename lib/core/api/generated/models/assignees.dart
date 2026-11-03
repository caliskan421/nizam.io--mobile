// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignees.freezed.dart';
part 'assignees.g.dart';

@Freezed()
abstract class Assignees with _$Assignees {
  const factory Assignees({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String? fullName,
  }) = _Assignees;

  factory Assignees.fromJson(Map<String, Object?> json) =>
      _$AssigneesFromJson(json);
}
