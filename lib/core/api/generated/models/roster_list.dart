// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'roster_member.dart';

part 'roster_list.freezed.dart';
part 'roster_list.g.dart';

@Freezed()
abstract class RosterList with _$RosterList {
  const factory RosterList({required List<RosterMember>? members}) =
      _RosterList;

  factory RosterList.fromJson(Map<String, Object?> json) =>
      _$RosterListFromJson(json);
}
