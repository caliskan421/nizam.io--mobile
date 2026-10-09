// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/platform_client.dart';
import 'clients/identity_client.dart';
import 'clients/organization_client.dart';
import 'clients/program_client.dart';

/// NIZAM.IO API `vv1`.
///
/// İlk dilim: kimlik, kurulum profili, sağlık/keşif, program, organizasyon ve.
/// yönetici kullanıcı uçları (32 uç). Diğer uçlar istemci fazlarından önce ek.
/// commit'le eklenir.
///
/// - Ana sürüm yol segmentindedir (`/v1`); `info.version` = `NIZAMIO_API_VERSION` varsayılanı.
/// - Kapsam sınıfı her işlemde `x-nizamio-scope-class` (S0–S3) ile yazılır ve rota tablosuyla eşittir.
/// - Her hata `ErrorEnvelope` döner; `x-nizamio-error-codes` o durumda dönebilecek kodlardır.
///   (katalog: `docs/api/error-codes.json`).
/// - Tarih-saat alanları UTC'dir; birim belirtilmeyen tamsayı zaman damgaları Unix saniyesidir.
/// - Yanıtlar `Content-Security-Policy: default-src 'none'; frame-ancestors 'none'` taşır;.
///   açık origin https ise `Strict-Transport-Security` da gönderilir.
///
class NizamioApi {
  NizamioApi(Dio dio, {String? baseUrl}) : _dio = dio, _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => 'v1';

  PlatformClient? _platform;
  IdentityClient? _identity;
  OrganizationClient? _organization;
  ProgramClient? _program;

  PlatformClient get platform =>
      _platform ??= PlatformClient(_dio, baseUrl: _baseUrl);

  IdentityClient get identity =>
      _identity ??= IdentityClient(_dio, baseUrl: _baseUrl);

  OrganizationClient get organization =>
      _organization ??= OrganizationClient(_dio, baseUrl: _baseUrl);

  ProgramClient get program =>
      _program ??= ProgramClient(_dio, baseUrl: _baseUrl);
}
