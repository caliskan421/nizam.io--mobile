// Üretim kaynaklarının saf (dosya/süreç erişimsiz) dönüşümleri. tool/gen.dart bunları
// çağırır; test/tool/gen_test.dart negatif durumlarıyla sınar.
import 'dart:convert';

import 'package:yaml/yaml.dart';

/// Üretilmiş dosya başlığı.
String generatedHeader(String what) =>
    '// BU DOSYA ÜRETİLMİŞTİR — elle düzenlenmez. `make gen` (tool/gen.dart) ile yeniden üretilir.\n'
    '// Kaynak: $what\n';

/// Dart dizesi değişmezi (tek tırnak; kaçışlı).
String dartString(String s) {
  final escaped = s
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll(r'$', r'\$')
      .replaceAll('\n', r'\n');
  return "'$escaped'";
}

// ---------------------------------------------------------------- hata kataloğu

class CatalogEntry {
  CatalogEntry(this.code, this.statuses, this.fields, this.messageKey);
  final String code;
  final List<int> statuses;
  final List<String> fields;
  final String messageKey;
}

class Catalog {
  Catalog(this.version, this.entries);
  final int version;
  final List<CatalogEntry> entries;

  /// Zarf kodları ∪ alan (fields[]) kodları — her birinin TR metni olmalı.
  Set<String> get allCodes => {
    for (final e in entries) ...[e.code, ...e.fields],
  };
}

Catalog parseCatalog(String text) {
  final root = jsonDecode(text) as Map<String, Object?>;
  final version = root['catalog_version'];
  final codes = root['codes'];
  if (version is! int || codes is! Map<String, Object?>) {
    throw const FormatException('error-codes.json: catalog_version/codes yok');
  }
  final entries = <CatalogEntry>[];
  for (final code in codes.keys.toList()..sort()) {
    final e = codes[code];
    if (e is! Map<String, Object?>) {
      throw FormatException('katalog: $code nesne değil');
    }
    final status = e['status'];
    final statuses = status is int
        ? [status]
        : (status as List<Object?>).map((s) => s! as int).toList();
    final fields =
        (e['fields'] as List<Object?>).map((f) => f! as String).toList()
          ..sort();
    final key = e['message_key'];
    if (key != 'errors.$code') {
      throw FormatException(
        'katalog: $code message_key "errors.$code" değil: $key',
      );
    }
    entries.add(CatalogEntry(code, statuses, fields, key! as String));
  }
  return Catalog(version, entries);
}

// ---------------------------------------------------------------- web TR metinleri

final _entry = RegExp(
  r"'([a-z0-9_]+(?:\.[a-z0-9_]+)+)':\s*'((?:[^'\\\n]|\\.)*)'\s*,",
);

/// Web `src/shared/i18n/tr/errors.ts` içindeki `trErrors` nesnesini KATI okur: nesne
/// gövdesinde yorum ve `'kod': 'metin',` girdileri dışında hiçbir şey kalmamalıdır (biçim
/// değişirse üretim düşer; sessizce eksik okuma olmaz).
Map<String, String> parseWebTrErrors(String source) {
  const open = 'export const trErrors: Record<string, string> = {';
  final start = source.indexOf(open);
  if (start < 0) {
    throw const FormatException('web TR: trErrors bildirimi bulunamadı');
  }
  final end = source.indexOf('\n}', start);
  if (end < 0) {
    throw const FormatException('web TR: trErrors kapanışı bulunamadı');
  }
  final body = source
      .substring(start + open.length, end)
      .split('\n')
      .map((l) => l.trimLeft().startsWith('//') ? '' : l)
      .join('\n');
  final out = <String, String>{};
  for (final m in _entry.allMatches(body)) {
    final code = m.group(1)!;
    if (out.containsKey(code)) {
      throw FormatException('web TR: yinelenen kod $code');
    }
    out[code] = m
        .group(2)!
        .replaceAllMapped(RegExp(r'\\(.)'), (x) => x.group(1)!);
  }
  final leftover = body.replaceAll(_entry, '').trim();
  if (leftover.isNotEmpty) {
    throw FormatException(
      'web TR: tanınmayan içerik: ${leftover.split('\n').first}',
    );
  }
  return out;
}

/// `client_errors.tr.json` → kod → metin.
Map<String, String> parseClientErrors(String text) {
  final root = jsonDecode(text) as Map<String, Object?>;
  final codes = root['codes'] as Map<String, Object?>;
  final out = <String, String>{};
  for (final MapEntry(:key, :value) in codes.entries) {
    if (!RegExp(r'^client\.[a-z0-9_]+$').hasMatch(key)) {
      throw FormatException('istemci kodu "client." önekli değil: $key');
    }
    out[key] = value! as String;
  }
  return out;
}

/// Hata kodu → ARB anahtarı (gen-l10n Dart tanımlayıcısı ister): `identity.credentials_invalid`
/// → `errIdentityCredentialsInvalid`.
String arbKey(String code) {
  final parts = code.split(RegExp(r'[._]')).where((p) => p.isNotEmpty);
  return 'err${parts.map((p) => p[0].toUpperCase() + p.substring(1)).join()}';
}

/// ARB'ye girecek TR metinleri: sunucu kodları (katalog ∪ fields) web metninden, istemci
/// kodları mobil dosyasından. Eksik metin, fazla web metni değil — eksik metin üretimi düşürür.
Map<String, String> buildTrMessages(
  Catalog catalog,
  Map<String, String> webTr,
  Map<String, String> client,
) {
  final missing = catalog.allCodes.where((c) => !webTr.containsKey(c)).toList()
    ..sort();
  if (missing.isNotEmpty) {
    throw FormatException('web TR metni eksik kodlar: ${missing.join(', ')}');
  }
  final out = <String, String>{
    for (final c in catalog.allCodes.toList()..sort()) c: webTr[c]!,
    for (final c in client.keys.toList()..sort()) c: client[c]!,
  };
  final keys = <String, String>{};
  for (final code in out.keys) {
    final text = out[code]!;
    if (text.trim().isEmpty) throw FormatException('boş metin: $code');
    if (RegExp(r'[{}]').hasMatch(text)) {
      throw FormatException('metinde ICU özel karakteri ({ }) var: $code');
    }
    final k = arbKey(code);
    final prev = keys[k];
    if (prev != null) {
      throw FormatException('ARB anahtar çakışması: $prev ve $code → $k');
    }
    keys[k] = code;
  }
  return out;
}

String buildArb(Map<String, String> messages, String sourceNote) {
  final m = <String, Object?>{
    '@@locale': 'tr',
    '@@x-generated': sourceNote,
    for (final MapEntry(:key, :value) in messages.entries) ...{
      arbKey(key): value,
      '@${arbKey(key)}': {'description': key},
    },
  };
  return '${const JsonEncoder.withIndent('  ').convert(m)}\n';
}

// ---------------------------------------------------------------- operasyonlar

class OperationMeta {
  OperationMeta({
    required this.operationId,
    required this.method,
    required this.path,
    required this.scope,
    required this.csrf,
    required this.programHeader,
    required this.departmentHeader,
    required this.auth,
  });
  final String operationId;
  final String method;
  final String path;
  final String scope;
  final bool csrf;
  final bool programHeader;
  final bool departmentHeader;
  final bool auth;
}

class SpecSummary {
  SpecSummary(this.apiVersion, this.operations);
  final String apiVersion;
  final List<OperationMeta> operations;
}

SpecSummary summarizeSpec(String specText) {
  final spec = loadYaml(specText) as YamlMap;
  final version = (spec['info'] as YamlMap)['version'] as String;
  final paths = spec['paths'] as YamlMap;
  final ops = <OperationMeta>[];
  const methods = ['get', 'post', 'put', 'patch', 'delete'];
  String ref(String name) => '#/components/parameters/$name';
  for (final path in paths.keys.cast<String>().toList()..sort()) {
    final item = paths[path] as YamlMap;
    for (final method in methods) {
      final op = item[method] as YamlMap?;
      if (op == null) continue;
      final id = op['operationId'] as String?;
      final scope = op['x-nizamio-scope-class'] as String?;
      if (id == null || scope == null || !RegExp(r'^S[0-3]$').hasMatch(scope)) {
        throw FormatException(
          'spec: $method $path operationId/x-nizamio-scope-class eksik',
        );
      }
      final params = ((op['parameters'] as YamlList?) ?? YamlList())
          .map((p) => ((p as YamlMap)[r'$ref'] ?? p['name']) as String)
          .toList();
      final security = op['security'];
      ops.add(
        OperationMeta(
          operationId: id,
          method: method.toUpperCase(),
          path: path,
          scope: scope,
          csrf: params.contains(ref('CsrfHeader')),
          programHeader: params.contains(ref('ProgramScope')),
          departmentHeader: params.contains(ref('DepartmentScope')),
          auth: !(security is YamlList && security.isEmpty),
        ),
      );
    }
  }
  final ids = <String>{};
  for (final o in ops) {
    if (!ids.add(o.operationId)) {
      throw FormatException('spec: yinelenen operationId ${o.operationId}');
    }
    // Spec ilkesi (backend docs/api/README.md): S2/S3 ↔ kapsam başlığı, yazma ↔ CSRF.
    if ((o.scope == 'S2' || o.scope == 'S3') != o.programHeader) {
      throw FormatException(
        'spec: ${o.operationId} kapsam sınıfı/program başlığı tutarsız',
      );
    }
    if ((o.scope == 'S3') != o.departmentHeader) {
      throw FormatException(
        'spec: ${o.operationId} S3/departman başlığı tutarsız',
      );
    }
    if ((o.method != 'GET') != o.csrf) {
      throw FormatException(
        'spec: ${o.operationId} yazma/CSRF başlığı tutarsız',
      );
    }
  }
  return SpecSummary(version, ops);
}

// ---------------------------------------------------------------- tasarım token'ları

class ResolvedTokens {
  ResolvedTokens({
    required this.palette,
    required this.light,
    required this.dark,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.lineHeight,
    required this.spacing,
    required this.radius,
  });
  final Map<String, Map<String, String>> palette;
  final Map<String, String> light;
  final Map<String, String> dark;
  final Map<String, List<String>> fontFamily;
  final Map<String, num> fontSize;
  final Map<String, int> fontWeight;
  final Map<String, num> lineHeight;
  final Map<String, num> spacing;
  final Map<String, num> radius;
}

final _hex = RegExp(r'^#[0-9a-fA-F]{6}$');

ResolvedTokens resolveTokens(String text) {
  final t = jsonDecode(text) as Map<String, Object?>;
  if (t['version'] != 1) {
    throw FormatException('tokens: desteklenmeyen sürüm ${t['version']}');
  }
  final palette = <String, Map<String, String>>{};
  for (final MapEntry(:key, :value)
      in (t['palette']! as Map<String, Object?>).entries) {
    final scale = <String, String>{};
    for (final MapEntry(key: tone, value: hex)
        in (value! as Map<String, Object?>).entries) {
      if (hex is! String || !_hex.hasMatch(hex)) {
        throw FormatException('tokens: palette.$key.$tone hex değil: $hex');
      }
      scale[tone] = hex;
    }
    palette[key] = scale;
  }
  Map<String, String> mode(String name) {
    final m =
        (t['modes']! as Map<String, Object?>)[name]! as Map<String, Object?>;
    return {
      for (final MapEntry(:key, :value) in m.entries)
        key: () {
          final match = RegExp(r'^\{([a-z]+)\.(\d+)\}$')
              .firstMatch(value! as String);
          final hex = match == null
              ? null
              : palette[match.group(1)]?[match.group(2)];
          if (hex == null) {
            throw FormatException(
              'tokens: modes.$name.$key çözülemedi: $value',
            );
          }
          return hex;
        }(),
    };
  }

  final light = mode('light');
  final dark = mode('dark');
  if ((light.keys.toList()..sort()).join() !=
      (dark.keys.toList()..sort()).join()) {
    throw const FormatException('tokens: light/dark rol kümeleri farklı');
  }
  final typo = t['typography']! as Map<String, Object?>;
  Map<String, V> mapOf<V>(Object? m) =>
      (m! as Map<String, Object?>).map((k, v) => MapEntry(k, v as V));
  return ResolvedTokens(
    palette: palette,
    light: light,
    dark: dark,
    fontFamily: (typo['fontFamily']! as Map<String, Object?>).map(
      (k, v) => MapEntry(k, (v! as List<Object?>).cast<String>()),
    ),
    fontSize: mapOf<num>(typo['fontSize']),
    fontWeight: mapOf<int>(typo['fontWeight']),
    lineHeight: mapOf<num>(typo['lineHeight']),
    spacing: mapOf<num>(t['spacing']),
    radius: mapOf<num>(t['radius']),
  );
}

// ---------------------------------------------------------------- uygulama sürümü

/// pubspec `version: 1.2.3+4` → `1.2.3`.
String appVersionFromPubspec(String pubspec) {
  final v = (loadYaml(pubspec) as YamlMap)['version']?.toString();
  final m = v == null
      ? null
      : RegExp(r'^(\d+\.\d+\.\d+)(\+\d+)?$').firstMatch(v);
  if (m == null) {
    throw FormatException(
      'pubspec version MAJOR.MINOR.PATCH(+build) değil: $v',
    );
  }
  return m.group(1)!;
}
