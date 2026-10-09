// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SystemInfo _$SystemInfoFromJson(Map<String, dynamic> json) => _SystemInfo(
  productId: json['product_id'] as String,
  instanceId: json['instance_id'] as String,
  companyDisplayName: json['company_display_name'] as String,
  serverVersion: json['server_version'] as String,
  apiVersion: json['api_version'] as String,
  minimumMobileVersion: json['minimum_mobile_version'] as String,
  capabilities: (json['capabilities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SystemInfoToJson(_SystemInfo instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'instance_id': instance.instanceId,
      'company_display_name': instance.companyDisplayName,
      'server_version': instance.serverVersion,
      'api_version': instance.apiVersion,
      'minimum_mobile_version': instance.minimumMobileVersion,
      'capabilities': ?instance.capabilities,
    };
