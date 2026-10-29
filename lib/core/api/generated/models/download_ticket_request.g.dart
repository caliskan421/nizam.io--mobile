// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_ticket_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DownloadTicketRequest _$DownloadTicketRequestFromJson(
  Map<String, dynamic> json,
) => _DownloadTicketRequest(
  method: DownloadTicketRequestMethod.fromJson(json['method'] as String),
  path: json['path'] as String,
  body: json['body'],
);

Map<String, dynamic> _$DownloadTicketRequestToJson(
  _DownloadTicketRequest instance,
) => <String, dynamic>{
  'method': _$DownloadTicketRequestMethodEnumMap[instance.method]!,
  'path': instance.path,
  'body': ?instance.body,
};

const _$DownloadTicketRequestMethodEnumMap = {
  DownloadTicketRequestMethod.valueGet: 'GET',
  DownloadTicketRequestMethod.post: 'POST',
  DownloadTicketRequestMethod.$unknown: r'$unknown',
};
