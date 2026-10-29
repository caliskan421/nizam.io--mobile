// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_ticket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DownloadTicketResponse _$DownloadTicketResponseFromJson(
  Map<String, dynamic> json,
) => _DownloadTicketResponse(
  ticket: json['ticket'] as String,
  url: json['url'] as String,
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$DownloadTicketResponseToJson(
  _DownloadTicketResponse instance,
) => <String, dynamic>{
  'ticket': instance.ticket,
  'url': instance.url,
  'expires_at': instance.expiresAt.toIso8601String(),
};
