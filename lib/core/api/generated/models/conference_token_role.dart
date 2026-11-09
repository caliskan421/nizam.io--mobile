// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// host: yönetici; `coordinatorship` kipinde toplantıya bağlı departmanın koordinatörü, `person` kipinde sahip departmanı hâlâ koordine eden oluşturan. speaker: toplantıyı gören üye ve katılımcı (koordinatörlüğü düşmüş katılımcı oluşturan dahil).
@JsonEnum()
enum ConferenceTokenRole {
  @JsonValue('host')
  host('host'),
  @JsonValue('speaker')
  speaker('speaker'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ConferenceTokenRole(this.json);

  factory ConferenceTokenRole.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<ConferenceTokenRole> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
