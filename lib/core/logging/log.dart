import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Tek log yolu (sınır kuralı S3). Her ileti [redact]'ten geçer: belirteç, parola ve
/// Authorization değeri log'a yazılmaz (F14 kapsam 9). Yayın derlemesinde varsayılan çıkış
/// yoktur; hata ayıklamada `dart:developer`.
abstract final class Log {
  static void Function(String line) _sink = _defaultSink;
  static final Set<String> _secrets = {};

  /// Çıkış değiştirilir (testler, entegrasyon testleri, ileride yerel günlük dosyası).
  /// Değiştirilen çıkış da yalnız redaksiyondan geçmiş satırları alır.
  static set sink(void Function(String line) value) => _sink = value;

  static void resetSink() => _sink = _defaultSink;

  /// Bilinen gizli değerler (o anki belirteçler) birebir maskelenir — biçim bağımsız güvence.
  static void registerSecret(String value) {
    if (value.length >= 8) _secrets.add(value);
  }

  static void forgetSecret(String value) => _secrets.remove(value);

  static void info(String message) => _emit('I', message);
  static void warn(String message) => _emit('W', message);

  static void _emit(String level, String message) =>
      _sink('[$level] ${redact(message)}');

  static void _defaultSink(String line) {
    if (kDebugMode) developer.log(line, name: 'nizamio');
  }

  static final _bearer = RegExp(
    r'Bearer\s+[A-Za-z0-9\-._~+/]+=*',
    caseSensitive: false,
  );
  static final _jsonSecret = RegExp(
    r'"(access_token|refresh_token|token|password|current_password|new_password|captcha_token)"\s*:\s*"[^"]*"',
  );
  static final _kvSecret = RegExp(
    r'\b(access_token|refresh_token|token|password|authorization)\s*[=:]\s*[^\s,;&}]+',
    caseSensitive: false,
  );
  static final _jwt = RegExp(
    r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]*',
  );

  /// Gizli değerleri maskeler.
  static String redact(String input) {
    var out = input;
    for (final s in _secrets) {
      out = out.replaceAll(s, '***');
    }
    return out
        .replaceAll(_bearer, 'Bearer ***')
        .replaceAllMapped(_jsonSecret, (m) => '"${m.group(1)}":"***"')
        .replaceAllMapped(_kvSecret, (m) => '${m.group(1)}=***')
        .replaceAll(_jwt, '***');
  }
}
