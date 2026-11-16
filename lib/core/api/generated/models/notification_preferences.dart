// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_preference.dart';

part 'notification_preferences.freezed.dart';
part 'notification_preferences.g.dart';

@Freezed()
abstract class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    required List<NotificationPreference> preferences,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, Object?> json) =>
      _$NotificationPreferencesFromJson(json);
}
