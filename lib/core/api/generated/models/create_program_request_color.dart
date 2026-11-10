// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// İsteğe bağlı palet anahtarı (birebir). Yok ya da `null` = verilmemiş; başka değer `422 program.input_invalid` (`program.invalid_color`).
@JsonEnum()
enum CreateProgramRequestColor {
  @JsonValue('violet')
  violet('violet'),
  @JsonValue('gold')
  gold('gold'),
  @JsonValue('blue')
  blue('blue'),
  @JsonValue('teal')
  teal('teal'),
  @JsonValue('green')
  green('green'),
  @JsonValue('orange')
  orange('orange'),
  @JsonValue('red')
  red('red'),
  @JsonValue('slate')
  slate('slate'),

  /// The name has been replaced because it contains a keyword. Original name: `null`.
  @JsonValue('null')
  valueNull('null'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const CreateProgramRequestColor(this.json);

  factory CreateProgramRequestColor.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<CreateProgramRequestColor> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
