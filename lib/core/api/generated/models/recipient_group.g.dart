// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipient_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipientGroup _$RecipientGroupFromJson(Map<String, dynamic> json) =>
    _RecipientGroup(
      key: json['key'] as String,
      recipients: (json['recipients'] as List<dynamic>)
          .map((e) => Recipient.fromJson(e as Map<String, dynamic>))
          .toList(),
      truncated: json['truncated'] as bool,
    );

Map<String, dynamic> _$RecipientGroupToJson(_RecipientGroup instance) =>
    <String, dynamic>{
      'key': instance.key,
      'recipients': instance.recipients.map((e) => e.toJson()).toList(),
      'truncated': instance.truncated,
    };
