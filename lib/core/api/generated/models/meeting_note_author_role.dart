// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// Yazarın rol kopyası; eski notlarda boş (null) olabilir.
@JsonEnum()
enum MeetingNoteAuthorRole {
  @JsonValue('admin')
  admin('admin'),
  @JsonValue('coordinator')
  coordinator('coordinator'),
  @JsonValue('member')
  member('member'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const MeetingNoteAuthorRole(this.json);

  factory MeetingNoteAuthorRole.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<MeetingNoteAuthorRole> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
