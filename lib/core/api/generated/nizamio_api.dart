// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/platform_client.dart';
import 'clients/identity_client.dart';
import 'clients/organization_client.dart';
import 'clients/program_client.dart';
import 'clients/work_client.dart';
import 'clients/collaboration_client.dart';
import 'clients/records_client.dart';
import 'clients/notifications_client.dart';
import 'clients/reporting_client.dart';
import 'clients/assistant_client.dart';

/// NIZAM.IO API `vv1`.
///
/// Bütün rota tablosu: sağlık/keşif ve kurulum profili, kimlik, organizasyon ve.
/// yönetici hesapları, program ve aktarım, görev (work), dosya ve arşiv.
/// (records), mesaj ve toplantı (collaboration), bildirim (notifications) ve.
/// rapor (reporting) ve YZ asistanı (assistant; yalnız özellik bayrağı açıkken kayıtlı) uçları.
/// Spec işlem kümesi rota tablosuyla iki yönlü eşittir.
///
/// - Ana sürüm yol segmentindedir (`/v1`); `info.version` = `NIZAMIO_API_VERSION` varsayılanı.
/// - Kapsam sınıfı her işlemde `x-nizamio-scope-class` (S0–S3) ile yazılır ve rota tablosuyla eşittir.
/// - Her hata `ErrorEnvelope` döner; `x-nizamio-error-codes` o durumda dönebilecek kodlardır.
///   (katalog: `docs/api/error-codes.json`).
/// - Tarih-saat alanları UTC'dir; birim belirtilmeyen tamsayı zaman damgaları Unix saniyesidir.
/// - Yanıtlar `Content-Security-Policy: default-src 'none'; frame-ancestors 'none'` ve.
///   `Cache-Control: no-store` taşır; açık origin https ise `Strict-Transport-Security` da gönderilir.
/// - Gövdeyi platform (httpguard) çözücüsüyle çözen uçlarda: katı çözücü (bilinmeyen alan.
///   reddi) bilinmeyen alanda ve bozuk JSON'da `platform.body_unknown_field` döner (iki.
///   hatayı ayırmaz); gövde sınırının çözüm sırasında aşılması ve tek JSON belgesinden.
///   sonra artakalan gövde katı çözücüde de `platform.body_invalid`'dir. Bilinmeyen alanı.
///   yok sayan çözücüde her çözüm hatası `platform.body_invalid`'dir. Kendi çözücüsünü.
///   kullanan uçlarda gövde hatası modül kodudur: collaboration uçlarında.
///   `collaboration.input_invalid`, dosya yeniden adlandırmada `records.input_invalid`.
/// - Uç başına `x-nizamio-error-codes` ortak kenar kodlarını da taşır; modüle özgü kodların.
///   uç başına listesi ilgili modül README'sinin §4 tablosuyla aynıdır.
/// - Olay türleri: `docs/api/events.md`.
/// - **Ekip programa göredir** (ADR-0023; bu revizyon `v0.4.0-api` etiketiyle yayımlanır,.
///   önceki etiketle kırıcıdır): departman programdan bağımsız bir katalog kaydıdır; ekip.
///   satırı (üyelik) ve rolü `(program, departman, hesap)` üçlüsüne aittir. Her rol, görev,.
///   dosya, toplantı, mesaj, rapor ve bildirim yetkisi seçili programdaki ekip satırından.
///   hesaplanır; bir programdaki koordinatörlük ya da üyelik başka programda yetki vermez.
///   Ekip uçları (`/v1/departments/{id}/memberships…`, `/coordinator…`, `/members`,.
///   `/assignable`, `/task-summary`) S2'dir. Departmanın her programda ayrı adı vardır.
///   (`display_name`; katalog adı bağ kurulurken kopyalanır).
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
  WorkClient? _work;
  CollaborationClient? _collaboration;
  RecordsClient? _records;
  NotificationsClient? _notifications;
  ReportingClient? _reporting;
  AssistantClient? _assistant;

  PlatformClient get platform =>
      _platform ??= PlatformClient(_dio, baseUrl: _baseUrl);

  IdentityClient get identity =>
      _identity ??= IdentityClient(_dio, baseUrl: _baseUrl);

  OrganizationClient get organization =>
      _organization ??= OrganizationClient(_dio, baseUrl: _baseUrl);

  ProgramClient get program =>
      _program ??= ProgramClient(_dio, baseUrl: _baseUrl);

  WorkClient get work => _work ??= WorkClient(_dio, baseUrl: _baseUrl);

  CollaborationClient get collaboration =>
      _collaboration ??= CollaborationClient(_dio, baseUrl: _baseUrl);

  RecordsClient get records =>
      _records ??= RecordsClient(_dio, baseUrl: _baseUrl);

  NotificationsClient get notifications =>
      _notifications ??= NotificationsClient(_dio, baseUrl: _baseUrl);

  ReportingClient get reporting =>
      _reporting ??= ReportingClient(_dio, baseUrl: _baseUrl);

  AssistantClient get assistant =>
      _assistant ??= AssistantClient(_dio, baseUrl: _baseUrl);
}
