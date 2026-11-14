// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_preference_group.dart';

part 'notification_preference.freezed.dart';
part 'notification_preference.g.dart';

@Freezed()
abstract class NotificationPreference with _$NotificationPreference {
  const factory NotificationPreference({
    /// Olay türü önekinden türeyen push grubu (work → gorev, collaboration/meetings → toplanti, mesaj olayları → mesaj, diğer → sistem).
    required NotificationPreferenceGroup group,
    @JsonKey(name: 'push_muted') required bool pushMuted,
  }) = _NotificationPreference;

  factory NotificationPreference.fromJson(Map<String, Object?> json) =>
      _$NotificationPreferenceFromJson(json);
}
