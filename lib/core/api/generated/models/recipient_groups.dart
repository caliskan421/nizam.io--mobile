// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'recipient_group.dart';

part 'recipient_groups.freezed.dart';
part 'recipient_groups.g.dart';

@Freezed()
abstract class RecipientGroups with _$RecipientGroups {
  const factory RecipientGroups({required List<RecipientGroup> groups}) =
      _RecipientGroups;

  factory RecipientGroups.fromJson(Map<String, Object?> json) =>
      _$RecipientGroupsFromJson(json);
}
