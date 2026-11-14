// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// Yalnız koordinatörlük alanında, sahibin açtığı dinamik departman ekibi paylaşımı (TABLES-K12). Yoksa paylaşım kapalıdır. Rol her istekte güncel ekip satırından türetilir; üyeler açık paylaşıma kopyalanmaz. Koordinatörlük ve şirket yöneticiliği tek başına erişim vermez.
@JsonEnum()
enum TableTeamRole {
  @JsonValue('editor')
  editor('editor'),
  @JsonValue('viewer')
  viewer('viewer'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const TableTeamRole(this.json);

  factory TableTeamRole.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<TableTeamRole> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
