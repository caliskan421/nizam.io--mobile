// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../date_only.dart';

import 'convert_note_request_priority.dart';

part 'convert_note_request.freezed.dart';
part 'convert_note_request.g.dart';

@Freezed()
abstract class ConvertNoteRequest with _$ConvertNoteRequest {
  const factory ConvertNoteRequest({
    /// Zorunlu; bitişten sonra olamaz ve bugünden önce olamaz.
    @DateOnlyConverter()
    @JsonKey(name: 'start_date')
    required DateTime startDate,

    /// Zorunlu; başlangıçtan önce olamaz.
    @DateOnlyConverter() @JsonKey(name: 'end_date') required DateTime endDate,

    /// Boşsa notun ilk 100 karakteri.
    String? title,

    /// Gönderilmezse `orta`; boş dizge de `orta` sayılır.
    ConvertNoteRequestPriority? priority,
    @JsonKey(name: 'department_id') String? departmentId,
    @JsonKey(name: 'assignee_account_ids') List<String>? assigneeAccountIds,
  }) = _ConvertNoteRequest;

  factory ConvertNoteRequest.fromJson(Map<String, Object?> json) =>
      _$ConvertNoteRequestFromJson(json);
}
