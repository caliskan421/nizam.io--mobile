// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/health_response.dart';
import '../models/instance_profile.dart';
import '../models/system_info.dart';

part 'platform_client.g.dart';

@RestApi()
abstract class PlatformClient {
  factory PlatformClient(Dio dio, {String? baseUrl}) = _PlatformClient;

  static const Map<String, dynamic> healthLiveOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["platform"],
      'operationId': "healthLive",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> healthReadyOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["platform"],
          'operationId': "healthReady",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> systemInfoOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["platform"],
      'operationId': "systemInfo",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> instanceProfileOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["platform"],
          'operationId': "instanceProfile",
          'externalDocsUrl': null,
        },
      };

  /// Süreç ayakta mı (bağımlılık denetlemez).
  @GET('/healthz/live')
  Future<HealthResponse> healthLive({
    @Extras()
    Map<String, dynamic>? extras = PlatformClient.healthLiveOpenapiExtras,
  });

  /// Bağımlılıklar erişilebilir mi.
  @GET('/healthz/ready')
  Future<HealthResponse> healthReady({
    @Extras()
    Map<String, dynamic>? extras = PlatformClient.healthReadyOpenapiExtras,
  });

  /// Açık sistem bilgi (keşif) ucu.
  @GET('/.well-known/nizamio-instance')
  Future<SystemInfo> systemInfo({
    @Extras()
    Map<String, dynamic>? extras = PlatformClient.systemInfoOpenapiExtras,
  });

  /// Kurulum profili: yalnız yapılandırma alanları.
  @GET('/v1/instance/profile')
  Future<InstanceProfile> instanceProfile({
    @Extras()
    Map<String, dynamic>? extras = PlatformClient.instanceProfileOpenapiExtras,
  });
}
