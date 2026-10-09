// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum RosterMemberStatus {
  @JsonValue('active')
  active('active'),
  @JsonValue('deleted')
  deleted('deleted'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const RosterMemberStatus(this.json);

  factory RosterMemberStatus.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<RosterMemberStatus> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
