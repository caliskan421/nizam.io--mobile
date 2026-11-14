// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'participants.dart';

part 'table_presence_frame.freezed.dart';
part 'table_presence_frame.g.dart';

/// Tablo akışının `presence` çerçevesi (ADR-0040). Alıcının kendi oturumu hariç, o anda doğrulanmış katılımcıların tam listesidir (liste değişince yazılır, en çok saniyede bir). `key` opak süreç içi kimliktir ve oturum kimliği değildir; hücre değeri, e-posta, rol ve süre yoktur.
@Freezed()
abstract class TablePresenceFrame with _$TablePresenceFrame {
  const factory TablePresenceFrame({
    @JsonKey(name: 'table_id') required String tableId,
    required List<Participants> participants,
  }) = _TablePresenceFrame;

  factory TablePresenceFrame.fromJson(Map<String, Object?> json) =>
      _$TablePresenceFrameFromJson(json);
}
