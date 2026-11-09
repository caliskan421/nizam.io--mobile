// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// Davet kipi (COLLABORATION-K73); sonradan değişmez. `person` kipinde koordinatör mesajı gönderilmez.
@JsonEnum()
enum CreateMeetingRequestInviteMode {
  @JsonValue('coordinatorship')
  coordinatorship('coordinatorship'),
  @JsonValue('person')
  person('person'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const CreateMeetingRequestInviteMode(this.json);

  factory CreateMeetingRequestInviteMode.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<CreateMeetingRequestInviteMode> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
