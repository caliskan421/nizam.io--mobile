// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum AssistantEventErrorKod {
  /// Incorrect name has been replaced. Original name: `assistant.limit_exceeded`.
  @JsonValue('assistant.limit_exceeded')
  undefined0('assistant.limit_exceeded'),

  /// Incorrect name has been replaced. Original name: `assistant.refused`.
  @JsonValue('assistant.refused')
  undefined1('assistant.refused'),

  /// Incorrect name has been replaced. Original name: `assistant.provider_unavailable`.
  @JsonValue('assistant.provider_unavailable')
  undefined2('assistant.provider_unavailable'),

  /// Incorrect name has been replaced. Original name: `platform.internal`.
  @JsonValue('platform.internal')
  undefined3('platform.internal'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const AssistantEventErrorKod(this.json);

  factory AssistantEventErrorKod.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<AssistantEventErrorKod> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
