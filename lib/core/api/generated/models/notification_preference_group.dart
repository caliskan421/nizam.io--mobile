// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// Olay türü önekinden türeyen push grubu (work → gorev, collaboration/meetings → toplanti, mesaj olayları → mesaj, diğer → sistem).
@JsonEnum()
enum NotificationPreferenceGroup {
  @JsonValue('gorev')
  gorev('gorev'),
  @JsonValue('mesaj')
  mesaj('mesaj'),
  @JsonValue('toplanti')
  toplanti('toplanti'),
  @JsonValue('sistem')
  sistem('sistem'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const NotificationPreferenceGroup(this.json);

  factory NotificationPreferenceGroup.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<NotificationPreferenceGroup> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
