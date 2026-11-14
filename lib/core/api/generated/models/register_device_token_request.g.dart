// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_device_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterDeviceTokenRequest _$RegisterDeviceTokenRequestFromJson(
  Map<String, dynamic> json,
) => _RegisterDeviceTokenRequest(
  token: json['token'] as String,
  platform: RegisterDeviceTokenRequestPlatform.fromJson(
    json['platform'] as String,
  ),
);

Map<String, dynamic> _$RegisterDeviceTokenRequestToJson(
  _RegisterDeviceTokenRequest instance,
) => <String, dynamic>{
  'token': instance.token,
  'platform': _$RegisterDeviceTokenRequestPlatformEnumMap[instance.platform]!,
};

const _$RegisterDeviceTokenRequestPlatformEnumMap = {
  RegisterDeviceTokenRequestPlatform.ios: 'ios',
  RegisterDeviceTokenRequestPlatform.android: 'android',
  RegisterDeviceTokenRequestPlatform.$unknown: r'$unknown',
};
