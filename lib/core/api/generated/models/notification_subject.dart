// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_subject.freezed.dart';
part 'notification_subject.g.dart';

@Freezed()
abstract class NotificationSubject with _$NotificationSubject {
  const factory NotificationSubject({
    required String kind,
    required String id,
  }) = _NotificationSubject;

  factory NotificationSubject.fromJson(Map<String, Object?> json) =>
      _$NotificationSubjectFromJson(json);
}
