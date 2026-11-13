// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// Çalışma alanı (TABLES-K11). `personal` program içi, departmansız ve `/v1/personal/tables` rotalarıyla; `coordinatorship` departmanlı ve `/v1/tables` rotalarıyla erişilir. Bir alanın tablo kimliği diğer alanın rotasında 404'tür.
@JsonEnum()
enum TableSpace {
  @JsonValue('personal')
  personal('personal'),
  @JsonValue('coordinatorship')
  coordinatorship('coordinatorship'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const TableSpace(this.json);

  factory TableSpace.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<TableSpace> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
