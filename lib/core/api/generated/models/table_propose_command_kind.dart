// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum TableProposeCommandKind {
  @JsonValue('propose_move')
  proposeMove('propose_move'),
  @JsonValue('propose_copy')
  proposeCopy('propose_copy'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const TableProposeCommandKind(this.json);

  factory TableProposeCommandKind.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<TableProposeCommandKind> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
