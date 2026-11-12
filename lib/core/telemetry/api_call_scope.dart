import 'dart:async';

import 'package:dio/dio.dart' show RequestOptions;

import '../api/generated/operations.gen.dart';

/// `apiCall` süresince çalışan istekten doğrulanmış API işlem kimliğini (operationId)
/// toplar. Zone değeriyle taşınır: iç içe ve eşzamanlı `apiCall`'lar kendi kapsamına
/// yazar, birbirinin bağlamını ezmez. Kimlik YALNIZ üretilmiş [apiOperations] listesinde
/// varsa kabul edilir (URL, parametre, gövde bu yoldan geçmez).
final class ApiCallScope {
  static const _key = #nizamioApiCallScope;

  String? _id;
  bool _ambiguous = false;

  /// Kapsamda TEK işlem kimliği görüldüyse o; hiç ya da birden çok farklı (ör. paralel
  /// istekler) görüldüyse `null` — sahte kesinlik yok.
  String? get operationId => _ambiguous ? null : _id;

  /// Çalışan kapsamda (varsa) [id]'yi kaydeder. Dio koruyucusu, kimliği doğruladıktan sonra
  /// çağırır.
  static void note(String id) {
    final scope = Zone.current[_key] as ApiCallScope?;
    if (scope == null || !apiOperations.containsKey(id)) return;
    if (scope._id != null && scope._id != id) scope._ambiguous = true;
    scope._id = id;
  }

  /// Hata taşıyan isteğin üretilmiş istemci metaverisindeki işlem kimliği (doğrulanmış).
  static String? ofRequest(RequestOptions options) {
    final openapi = options.extra['openapi'];
    final id = openapi is Map ? openapi['operationId'] : null;
    return id is String && apiOperations.containsKey(id) ? id : null;
  }

  /// [body]'yi yeni bir kapsamda çalıştırır; kapsam, çağırana dönüşte okunabilir kalır.
  static R run<R>(ApiCallScope scope, R Function() body) =>
      runZoned(body, zoneValues: {_key: scope});
}
