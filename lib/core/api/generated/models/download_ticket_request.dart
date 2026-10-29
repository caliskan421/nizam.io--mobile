// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'download_ticket_request_method.dart';

part 'download_ticket_request.freezed.dart';
part 'download_ticket_request.g.dart';

/// Bilet hedefi. İzin listesi kapalıdır: tek dosya indirme, üç ZIP, dört PDF (iş yükü PDF'i tek POST hedefidir, gövde zorunlu). ADR-0013.
@Freezed()
abstract class DownloadTicketRequest with _$DownloadTicketRequest {
  const factory DownloadTicketRequest({
    required DownloadTicketRequestMethod method,

    /// Göreli yol + ham sorgu dizesi (ör. `/v1/files/{id}/download`).
    required String path,

    /// Yalnız POST hedefinde zorunlu JSON nesnesi (≤ 64 KiB); GET hedefinde gönderilmez.
    dynamic body,
  }) = _DownloadTicketRequest;

  factory DownloadTicketRequest.fromJson(Map<String, Object?> json) =>
      _$DownloadTicketRequestFromJson(json);
}
