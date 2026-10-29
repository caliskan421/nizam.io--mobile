// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// Gönderilmezse `orta`; boş dizge de `orta` sayılır.
@JsonEnum()
enum ConvertNoteRequestPriority {
  @JsonValue('dusuk')
  dusuk('dusuk'),
  @JsonValue('orta')
  orta('orta'),
  @JsonValue('yuksek')
  yuksek('yuksek'),
  @JsonValue('acil')
  acil('acil'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ConvertNoteRequestPriority(this.json);

  factory ConvertNoteRequestPriority.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<ConvertNoteRequestPriority> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
