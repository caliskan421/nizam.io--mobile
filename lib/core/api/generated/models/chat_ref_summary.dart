// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_ref_summary_department.dart';
import 'chat_ref_summary_kind.dart';
import 'file.dart';
import 'task.dart';

part 'chat_ref_summary.freezed.dart';
part 'chat_ref_summary.g.dart';

@Freezed()
abstract class ChatRefSummary with _$ChatRefSummary {
  const factory ChatRefSummary({
    @JsonKey(name: 'ref_id') required String refId,
    required ChatRefSummaryKind kind,
    @JsonKey(name: 'target_id') required String targetId,
    @JsonKey(name: 'chat_id') required String chatId,
    @JsonKey(name: 'message_id') required String messageId,

    /// `false` ise hedef artık yoktur; kart alanları gelmez.
    required bool available,
    Task? task,
    ChatRefSummaryDepartment? department,
    File? file,
  }) = _ChatRefSummary;

  factory ChatRefSummary.fromJson(Map<String, Object?> json) =>
      _$ChatRefSummaryFromJson(json);
}
