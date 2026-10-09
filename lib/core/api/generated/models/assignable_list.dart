// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignable_account.dart';

part 'assignable_list.freezed.dart';
part 'assignable_list.g.dart';

@Freezed()
abstract class AssignableList with _$AssignableList {
  const factory AssignableList({required List<AssignableAccount>? accounts}) =
      _AssignableList;

  factory AssignableList.fromJson(Map<String, Object?> json) =>
      _$AssignableListFromJson(json);
}
