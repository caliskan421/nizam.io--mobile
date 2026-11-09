// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// Davet kipi (COLLABORATION-K73, K74). `coordinatorship`: bağlı departmanların koordinatörleri ve `members_included` ise üyeleri erişir. `person`: departman bağı erişim vermez; yönetici ve sahip departmanı hâlâ koordine eden oluşturan yönetir (koordinatörlüğü düşen oluşturan katılımcıysa üye düzeyindedir, değilse toplantıyı görmez). İki kipte de katılımcı üye düzeyinde görür. Kuruluşta seçilir, değişmez.
@JsonEnum()
enum MeetingInviteMode {
  @JsonValue('coordinatorship')
  coordinatorship('coordinatorship'),
  @JsonValue('person')
  person('person'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const MeetingInviteMode(this.json);

  factory MeetingInviteMode.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<MeetingInviteMode> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
