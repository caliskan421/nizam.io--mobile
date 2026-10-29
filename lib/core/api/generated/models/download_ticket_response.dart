// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_ticket_response.freezed.dart';
part 'download_ticket_response.g.dart';

@Freezed()
abstract class DownloadTicketResponse with _$DownloadTicketResponse {
  const factory DownloadTicketResponse({
    /// 256 bit, base64url; 60 sn ömürlü, tek kullanımlık.
    required String ticket,

    /// Göreli tüketme yolu (`/v1/downloads/{ticket}`).
    required String url,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _DownloadTicketResponse;

  factory DownloadTicketResponse.fromJson(Map<String, Object?> json) =>
      _$DownloadTicketResponseFromJson(json);
}
