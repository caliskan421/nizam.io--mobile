// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// Kapalı etiket kümesi (RECORDS-K07).
@JsonEnum()
enum RetagFileRequestTag {
  @JsonValue('ister')
  ister('ister'),
  @JsonValue('plan')
  plan('plan'),
  @JsonValue('girdi')
  girdi('girdi'),
  @JsonValue('analiz')
  analiz('analiz'),
  @JsonValue('cikti')
  cikti('cikti'),
  @JsonValue('sonuc')
  sonuc('sonuc'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const RetagFileRequestTag(this.json);

  factory RetagFileRequestTag.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<RetagFileRequestTag> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
