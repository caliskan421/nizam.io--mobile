// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum Sort {
  @JsonValue('created_at_desc')
  createdAtDesc('created_at_desc'),
  @JsonValue('meeting_date_asc')
  meetingDateAsc('meeting_date_asc'),
  @JsonValue('meeting_date_desc')
  meetingDateDesc('meeting_date_desc'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const Sort(this.json);

  factory Sort.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<Sort> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
