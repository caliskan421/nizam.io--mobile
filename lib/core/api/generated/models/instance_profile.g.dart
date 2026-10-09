// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InstanceProfile _$InstanceProfileFromJson(Map<String, dynamic> json) =>
    _InstanceProfile(
      displayName: json['display_name'] as String,
      brandColor: json['brand_color'] as String,
      timezone: json['timezone'] as String,
      apiVersion: json['api_version'] as String,
      minimumMobileVersion: json['minimum_mobile_version'] as String,
    );

Map<String, dynamic> _$InstanceProfileToJson(_InstanceProfile instance) =>
    <String, dynamic>{
      'display_name': instance.displayName,
      'brand_color': instance.brandColor,
      'timezone': instance.timezone,
      'api_version': instance.apiVersion,
      'minimum_mobile_version': instance.minimumMobileVersion,
    };
