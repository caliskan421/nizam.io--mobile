import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' show DioException;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../api/generated/error_catalog.gen.dart';
import '../api/generated/operations.gen.dart';
import '../i18n/generated/client_error_codes.gen.dart';
import 'report_message.dart';
import 'report_source.dart';
import 'stack_sanitizer.dart';

/// Hata raporunun ait olduğu işlem. KAPALI küme: dinamik rota, sağlayıcı adı ya da serbest
/// metin işlem kodu olamaz; rapora yalnız [code] sabiti girer.
enum ReportOperation {
  none('none'),
  startup('startup'),
  login('login'),
  sessionRefresh('session_refresh'),
  taskWrite('task_write'),
  fileUpload('file_upload'),
  fileDownload('file_download'),
  chatSend('chat_send'),
  chatStream('chat_stream'),
  assistantChat('assistant_chat'),
  localStorage('local_storage');

  const ReportOperation(this.code);
  final String code;
}

/// Raporun sınıfı. Beklenen durumlar (doğrulama, yanlış parola, yetki reddi, iptal,
/// çevrimdışı) HİÇ rapor üretmez; yalnız beklenmeyen sınıflar vardır.
enum ReportKind {
  /// 2xx ya da şemaya uymayan yanıt gövdesi ayrıştırılamadı.
  invalidResponse('invalid_response'),

  /// Sunucu 5xx döndü (yoğun hız sınırı altında).
  serverError('server_error'),

  /// HTTP 2xx akış içinde sunucunun bildirdiği TEKNİK hata olayı (ör. SSE `hata`: katalogda
  /// 5xx olan kod). Gerçek HTTP durumu yoktur; durum sınıfı raporlanmaz.
  streamServerError('stream_server_error'),

  /// Yerel depolama/dosya sistemi arızası.
  storage('storage'),

  /// Yerel serileştirme/ayrıştırma arızası.
  serialization('serialization'),

  /// Sınıflandırılamayan beklenmeyen istisna (kod hatası göstergesi).
  unexpected('unexpected'),

  /// Flutter çerçevesi hatası ([FlutterError.onError]).
  framework('framework'),

  /// Yakalanmamış eşzamansız hata ([PlatformDispatcher.onError]).
  uncaughtAsync('uncaught_async'),

  /// Açılış başarısız.
  startup('startup');

  const ReportKind(this.code);
  final String code;
}

/// Hata türü: ham `runtimeType`/`toString` YERİNE kapalı küme (yayın derlemesinde
/// karartılmış ad sızmaz, ileti metni hiç taşınmaz).
enum ReportErrorType {
  typeError('type_error'),
  formatException('format_exception'),
  stateError('state_error'),
  argumentError('argument_error'),
  rangeError('range_error'),
  unsupportedError('unsupported_error'),
  assertionError('assertion_error'),
  fileSystem('file_system'),
  platform('platform'),
  timeout('timeout'),
  http('http'),
  other('other');

  const ReportErrorType(this.code);
  final String code;

  static ReportErrorType of(Object? error) => switch (error) {
    TypeError() => typeError,
    FormatException() => formatException,
    StateError() => stateError,
    RangeError() => rangeError, // ArgumentError alt sınıfı: önce gelmeli
    ArgumentError() => argumentError,
    UnsupportedError() => unsupportedError,
    AssertionError() => assertionError,
    FileSystemException() => fileSystem,
    PlatformException() => platform,
    TimeoutException() => timeout,
    HttpException() || SocketException() || DioException() => http,
    _ => other,
  };
}

bool _allowedCode(String code) =>
    errorCatalog.containsKey(code) || ClientErrorCode.all.contains(code);

String? _statusClass(int? status) {
  if (status == null || status < 200 || status > 599) return null;
  return '${status ~/ 100}xx';
}

/// Gönderilmesine İZİN verilen teknik alanların tamamı. Ham hata iletisi, sunucu gövdesi,
/// URL, kimlik, kullanıcı içeriği, dosya adı/yolu bu modelde YER ALMAZ (alan yok).
@immutable
final class ErrorReport {
  const ErrorReport._({
    required this.operation,
    required this.source,
    required this.apiOperationId,
    required this.kind,
    required this.errorType,
    required this.stack,
    required this.apiCode,
    required this.statusClass,
    required this.fatal,
  });

  /// TEK kurma yolu: serbest metin kabul etmez. [apiCode] yalnız sunucu hata kataloğundan
  /// ya da istemci kodlarından biriyse girer (aksi halde düşer); [status] yalnız durum
  /// SINIFINA (`2xx`…`5xx`) indirgenir; [stack] yalnız [sanitizeStack] çıktısı olabilir.
  factory ErrorReport.create({
    required ReportOperation operation,
    required ReportKind kind,
    required ReportErrorType errorType,
    required SanitizedStackTrace stack,
    ReportSource source = ReportSource.unknown,
    String? apiOperationId,
    String? apiCode,
    int? status,
    bool fatal = false,
  }) => ErrorReport._(
    operation: operation,
    source: source,
    apiOperationId:
        apiOperationId != null && apiOperations.containsKey(apiOperationId)
        ? apiOperationId
        : null,
    kind: kind,
    errorType: errorType,
    stack: stack,
    apiCode: apiCode != null && _allowedCode(apiCode) ? apiCode : null,
    statusClass: _statusClass(status),
    fatal: fatal,
  );

  final ReportOperation operation;

  /// Hatanın yakalandığı alan (kapalı küme); bkz. [ReportSource].
  final ReportSource source;

  /// Üretilmiş `apiOperations` listesinde doğrulanmış API işlem kimliği ya da `null`
  /// (kesin tek işlem belirlenemediyse). İstek adresi/parametresi değildir.
  final String? apiOperationId;
  final ReportKind kind;
  final ReportErrorType errorType;

  /// Katalog/istemci kodu (beyaz liste) ya da `null`.
  final String? apiCode;

  /// `2xx`/`3xx`/`4xx`/`5xx` ya da `null` (tam durum kodu ve yol yok).
  final String? statusClass;

  /// Temizlenmiş yığın; yalnız tanınan çerçeve yapıları.
  final SanitizedStackTrace stack;
  final bool fatal;

  /// Sabit Türkçe teknik açıklama; kapalı kümelerden türetilir, ham hata iletisi içermez.
  String get message =>
      reportMessage(kind: kind, errorType: errorType, apiCode: apiCode);

  /// Gruplama ve konsolda okunur kısa etiket; ham veri içermez.
  String get label =>
      'kind=${kind.code} op=${operation.code} src=${source.code}'
      '${apiOperationId == null ? '' : ' api=$apiOperationId'}'
      ' type=${errorType.code}'
      '${apiCode == null ? '' : ' code=$apiCode'}'
      '${statusClass == null ? '' : ' status=$statusClass'}';
}

/// Çalışan işlemin bağlamı. Zone değeriyle taşınır: eşzamanlı iki işlem birbirinin
/// bağlamını EZMEZ (global "son işlem" değişkeni yoktur) ve `await` boyunca korunur.
abstract final class ReportContext {
  static const _key = #nizamioReportOperation;

  static ReportOperation get current =>
      Zone.current[_key] as ReportOperation? ?? ReportOperation.none;

  /// [body]'yi [operation] bağlamında çalıştırır. Yeni bir hata bölgesi AÇMAZ
  /// (yakalanmamış hatalar üst bölgeye/`PlatformDispatcher`'a olduğu gibi gider).
  static R run<R>(ReportOperation operation, R Function() body) =>
      runZoned(body, zoneValues: {_key: operation});

  /// Dıştaki bağlam zaten varsa (ör. dosya yükleme görev yazmasının içinde) onu korur.
  static R runIfNone<R>(ReportOperation operation, R Function() body) =>
      current == ReportOperation.none ? run(operation, body) : body();
}
