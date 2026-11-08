// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_pins.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatPins _$ChatPinsFromJson(Map<String, dynamic> json) => _ChatPins(
  items: (json['items'] as List<dynamic>)
      .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
      .toList(),
  truncated: json['truncated'] as bool,
);

Map<String, dynamic> _$ChatPinsToJson(_ChatPins instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'truncated': instance.truncated,
};
