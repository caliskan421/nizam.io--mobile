// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_public_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushPublicKey _$PushPublicKeyFromJson(Map<String, dynamic> json) =>
    _PushPublicKey(
      publicKey: json['public_key'] as String,
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$PushPublicKeyToJson(_PushPublicKey instance) =>
    <String, dynamic>{
      'public_key': instance.publicKey,
      'enabled': instance.enabled,
    };
