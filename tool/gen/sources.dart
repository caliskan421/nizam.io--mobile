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
  final parts = code.split(RegExp(r'[._]')).where((p) => p.isNotEmpty).toList();
  String cap(String p) => p[0].toUpperCase() + p.substring(1);
  // UI metinleri: `ui.common.retry` → `uiCommonRetry` ("err" öneki yalnız hata kodlarında).
  if (parts.first == 'ui') {
    return 'ui${parts.skip(1).map(cap).join()}';
  }
  return 'err${parts.map(cap).join()}';
}

/// `i18n/ui/<grup>.tr.json` dosyaları (dosya adı → içerik) → tam anahtar → metin.
/// Anahtar `ui.<grup>.<ad>` olmalı (grup = dosya adı); yinelenen anahtar, boş metin, ICU özel
/// karakteri ve ARB anahtar çakışması düşer. Sunucu/istemci hata kodlarıyla çakışma
/// [checkUiAgainstErrors] ile denetlenir.
Map<String, String> parseUiTexts(Map<String, String> filesByName) {
  final out = <String, String>{};
  final arb = <String, String>{};
  for (final name in filesByName.keys.toList()..sort()) {
    final m = RegExp(r'^([a-z][a-z0-9_]*)\.tr\.json$').firstMatch(name);
    if (m == null) {
      throw FormatException(
        'UI metin dosyası adı <grup>.tr.json olmalı: $name',
      );
    }
    final group = m.group(1)!;
    // jsonDecode yinelenen anahtarı sessizce ezer; ham metinde ayrıca sayılır.
    final seen = <String>{};
    for (final k in RegExp(
      r'"(ui\.[^"]*)"\s*:',
    ).allMatches(filesByName[name]!)) {
      if (!seen.add(k.group(1)!)) {
        throw FormatException('$name: yinelenen UI anahtarı: ${k.group(1)}');
      }
    }
    final root = jsonDecode(filesByName[name]!) as Map<String, Object?>;
    final texts = root['texts'];
    if (texts is! Map<String, Object?>) {
      throw FormatException('$name: "texts" nesnesi yok');
    }
    final keyRe = RegExp(
      '^ui\\.$group\\.[a-z][a-z0-9_]*(\\.[a-z][a-z0-9_]*)*\$',
    );
    for (final MapEntry(:key, :value) in texts.entries) {
      if (!keyRe.hasMatch(key)) {
        throw FormatException(
          '$name: anahtar "ui.$group." önekli değil/geçersiz: $key',
        );
      }
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$name: metin boş ya da dize değil: $key');
      }
      if (RegExp(r'[{}]').hasMatch(value)) {
        throw FormatException(
          '$name: metinde ICU özel karakteri ({ }) var: $key',
        );
      }
      if (out.containsKey(key)) {
        throw FormatException('yinelenen UI anahtarı: $key');
      }
      final k = arbKey(key);
      final prev = arb[k];
      if (prev != null) {
        throw FormatException('ARB anahtar çakışması: $prev ve $key → $k');
      }
      arb[k] = key;
      out[key] = value;
    }
  }
  return out;
}

/// `ui.*` anahtarları sunucu/istemci hata kodlarıyla (ve ARB anahtarlarıyla) çakışmamalı.
void checkUiAgainstErrors(Map<String, String> ui, Iterable<String> errorCodes) {
  final codes = errorCodes.toSet();
  final errArb = {for (final c in codes) arbKey(c): c};
  for (final key in ui.keys) {
    if (codes.contains(key)) {
      throw FormatException('UI anahtarı hata koduyla çakışıyor: $key');
    }
    final hit = errArb[arbKey(key)];
    if (hit != null) {
      throw FormatException(
        'UI anahtarı ARB anahtarında hata koduyla çakışıyor: $key ve $hit',
      );
    }
  }
  final stray = codes.where((c) => c.startsWith('ui.')).toList()..sort();
  if (stray.isNotEmpty) {
    throw FormatException(
      'hata kodu "ui." ad alanını kullanıyor: ${stray.join(', ')}',
    );
  }
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

String buildArb(
  Map<String, String> messages,
  String sourceNote, [
  Map<String, String> ui = const {},
]) {
  final m = <String, Object?>{
    '@@locale': 'tr',
    '@@x-generated': sourceNote,
    for (final MapEntry(:key, :value) in <MapEntry<String, String>>[
      ...messages.entries,
      ...ui.entries,
    ]) ...{
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
//
// İki girdi (ADR-0003 karar 24): tasarım sisteminin `tokens.json`'u (değerlerin tek kaynağı) ve
// mobil eşleme dosyası `design/mobile-tokens.json` (anlamsal rol → tasarım token adı; tasarımda
// karşılığı olmayan mobil değerler). Renkler ARGB tamsayısına çevrilir: CSS `#RRGGBBAA` →
// `0xAARRGGBB`.

/// Çözülmüş gölge (CSS `x y blur [spread] renk`).
class ShadowSpec {
  ShadowSpec(this.dx, this.dy, this.blur, this.spread, this.argb);
  final double dx;
  final double dy;
  final double blur;
  final double spread;
  final int argb;
}

/// Tasarım metin stili (px ve em birimleriyle, kaynaktaki gibi).
class TypeSpec {
  TypeSpec({
    required this.family,
    required this.size,
    required this.lineHeight,
    required this.weight,
    required this.letterSpacingEm,
  });

  /// `families` anahtarı (`sans`, `display`, `mono`).
  final String family;
  final double size;
  final double lineHeight;
  final int weight;
  final double letterSpacingEm;
}

class ResolvedTokens {
  ResolvedTokens({
    required this.roles,
    required this.light,
    required this.dark,
    required this.families,
    required this.typeStyles,
    required this.spacingScale,
    required this.spacing,
    required this.radius,
    required this.size,
    required this.blur,
    required this.metrics,
    required this.shadowsLight,
    required this.shadowsDark,
  });

  /// Rol adları (mobil eşleme sırası).
  final List<String> roles;
  final Map<String, int> light;
  final Map<String, int> dark;

  /// Aile anahtarı → [birincil ad, ...yedekler].
  final Map<String, List<String>> families;

  /// Dart tanımlayıcısı (`m-h1-detail` → `h1Detail`) → stil.
  final Map<String, TypeSpec> typeStyles;
  final Map<String, double> spacingScale;
  final Map<String, double> spacing;
  final Map<String, double> radius;
  final Map<String, double> size;
  final Map<String, double> blur;
  final Map<String, double> metrics;
  final Map<String, ShadowSpec> shadowsLight;
  final Map<String, ShadowSpec> shadowsDark;
}

/// Tasarım token adı → Dart tanımlayıcısı: `m-` / `m-r-` / `m-sh-` / `m-blur-` öneki atılır,
/// kalan kebab-case camelCase olur (`m-gap-xs` → `gapXs`).
String tokenIdent(String name, [String prefix = 'm-']) {
  if (!name.startsWith(prefix)) {
    throw FormatException('tokens: "$name" "$prefix" önekli değil');
  }
  final parts = name.substring(prefix.length).split('-');
  if (parts.any((p) => !RegExp(r'^[a-z0-9]+$').hasMatch(p))) {
    throw FormatException('tokens: geçersiz ad: $name');
  }
  return parts.first +
      parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
}

final _hex6 = RegExp(r'^#([0-9a-fA-F]{6})$');
final _hex8 = RegExp(r'^#([0-9a-fA-F]{6})([0-9a-fA-F]{2})$');
final _rgba = RegExp(
  r'^rgba\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(0|1|0?\.\d+|1\.0+)\s*\)$',
);

/// CSS renk değeri → ARGB. Desteklenen: `#RRGGBB`, `#RRGGBBAA` (CSS sırası; alfa SONDA),
/// `rgba(r, g, b, a)`. Başka biçim düşer (sessiz yanlış renk olmaz).
int cssColorToArgb(String v) {
  final s = v.trim();
  final m6 = _hex6.firstMatch(s);
  if (m6 != null) return 0xFF000000 | int.parse(m6.group(1)!, radix: 16);
  final m8 = _hex8.firstMatch(s);
  if (m8 != null) {
    final alpha = int.parse(m8.group(2)!, radix: 16);
    return (alpha << 24) | int.parse(m8.group(1)!, radix: 16);
  }
  final m = _rgba.firstMatch(s);
  if (m != null) {
    final c = [for (var i = 1; i <= 3; i++) int.parse(m.group(i)!)];
    if (c.any((x) => x > 255)) {
      throw FormatException('tokens: rgba kanalı 255 üstü: $v');
    }
    final a = (double.parse(m.group(4)!) * 255).round();
    return (a << 24) | (c[0] << 16) | (c[1] << 8) | c[2];
  }
  throw FormatException('tokens: desteklenmeyen renk biçimi: $v');
}

double _px(String v, String where) {
  final m = RegExp(r'^(-?\d+(?:\.\d+)?)(px)?$').firstMatch(v.trim());
  if (m == null || (m.group(2) == null && double.parse(m.group(1)!) != 0)) {
    throw FormatException('tokens: $where px değil: $v');
  }
  return double.parse(m.group(1)!);
}

/// CSS gölgesi: `x y blur [spread] renk` (tek katman).
ShadowSpec parseShadow(String v, String where) {
  final m = RegExp(
    r'^(-?[\d.]+(?:px)?)\s+(-?[\d.]+(?:px)?)\s+([\d.]+(?:px)?)(?:\s+(-?[\d.]+(?:px)?))?\s+(\S.*)$',
  ).firstMatch(v.trim());
  if (m == null) throw FormatException('tokens: $where gölge değil: $v');
  return ShadowSpec(
    _px(m.group(1)!, where),
    _px(m.group(2)!, where),
    _px(m.group(3)!, where),
    m.group(4) == null ? 0 : _px(m.group(4)!, where),
    cssColorToArgb(m.group(5)!),
  );
}

/// CSS font yığını → [birincil, ...yedekler] (tırnaklar atılır).
List<String> parseFontStack(String v) {
  final out = [
    for (final p in v.split(',')) p.trim().replaceAll(RegExp('^"|"\$'), ''),
  ];
  if (out.isEmpty || out.first.isEmpty) {
    throw FormatException('tokens: boş font yığını: $v');
  }
  return out;
}

ResolvedTokens resolveTokens(String designText, String mobileText) {
  final d = jsonDecode(designText) as Map<String, Object?>;
  final mob = jsonDecode(mobileText) as Map<String, Object?>;
  if (d['version'] != 1) {
    throw FormatException(
      'tokens: desteklenmeyen tasarım sürümü ${d['version']}',
    );
  }
  if (mob['version'] != 1) {
    throw FormatException(
      'mobile-tokens: desteklenmeyen sürüm ${mob['version']}',
    );
  }
  List<Map<String, Object?>> list(Object? section, String name) {
    final s = section is Map<String, Object?> ? section['tokens'] : null;
    if (s is! List<Object?>) throw FormatException('tokens: $name.tokens yok');
    return s.cast<Map<String, Object?>>();
  }

  // Renkler: tema kimlikleri tam olarak dark + light.
  final color = d['color'] as Map<String, Object?>?;
  final themes = ((color?['themes'] as List<Object?>?) ?? [])
      .map((t) => (t! as Map<String, Object?>)['id'])
      .toSet();
  if (themes.length != 2 || !themes.containsAll({'dark', 'light'})) {
    throw FormatException('tokens: temalar dark/light değil: $themes');
  }
  final raw = <String, Map<String, String>>{};
  for (final t in list(color, 'color')) {
    final name = t['name']! as String;
    final v = t['value'];
    if (raw.containsKey(name)) {
      throw FormatException('tokens: yinelenen renk $name');
    }
    raw[name] = v is String
        ? {'dark': v, 'light': v}
        : (v! as Map<String, Object?>).map((k, x) => MapEntry(k, x! as String));
    if (!raw[name]!.keys.toSet().containsAll({'dark', 'light'})) {
      throw FormatException('tokens: $name iki temada tanımlı değil');
    }
  }
  int colorOf(String name, String mode, [int depth = 0]) {
    final v = raw[name]?[mode];
    if (v == null) throw FormatException('tokens: renk yok: $name');
    final ref = RegExp(r'^\{([a-z0-9-]+)\}$').firstMatch(v);
    if (ref == null) return cssColorToArgb(v);
    if (depth > 4) throw FormatException('tokens: döngülü başvuru: $name');
    return colorOf(ref.group(1)!, mode, depth + 1);
  }

  final mapping = mob['colors'];
  if (mapping is! Map<String, Object?> || mapping.isEmpty) {
    throw const FormatException('mobile-tokens: "colors" eşlemesi yok');
  }
  final roles = <String>[];
  final light = <String, int>{};
  final dark = <String, int>{};
  for (final MapEntry(key: role, value: target) in mapping.entries) {
    if (!RegExp(r'^[a-z][A-Za-z0-9]*$').hasMatch(role)) {
      throw FormatException('mobile-tokens: geçersiz rol adı: $role');
    }
    if (target is! String || !raw.containsKey(target)) {
      throw FormatException(
        'mobile-tokens: $role → tasarımda olmayan token: $target',
      );
    }
    roles.add(role);
    light[role] = colorOf(target, 'light');
    dark[role] = colorOf(target, 'dark');
  }

  // Tipografi.
  final type = d['type'] as Map<String, Object?>?;
  final families = <String, List<String>>{
    for (final MapEntry(:key, :value)
        in ((type?['families'] as Map<String, Object?>?) ?? {}).entries)
      key: parseFontStack(value! as String),
  };
  final typeStyles = <String, TypeSpec>{};
  for (final g
      in ((type?['groups'] as List<Object?>?) ?? [])
          .cast<Map<String, Object?>>()) {
    final family = g['family']! as String;
    if (!families.containsKey(family)) {
      throw FormatException('tokens: ${g['name']} bilinmeyen aile: $family');
    }
    for (final s
        in (g['styles']! as List<Object?>).cast<Map<String, Object?>>()) {
      final name = s['name']! as String;
      final id = tokenIdent(name);
      if (typeStyles.containsKey(id)) {
        throw FormatException('tokens: yinelenen stil $name');
      }
      final ls = s['letterSpacing'] as String?;
      final lsMatch = ls == null
          ? null
          : RegExp(r'^(-?\d*\.?\d+)em$').firstMatch(ls);
      if (ls != null && lsMatch == null) {
        throw FormatException('tokens: $name letterSpacing em değil: $ls');
      }
      final weight = s['fontWeight'];
      if (weight is! int || weight % 100 != 0 || weight < 100 || weight > 900) {
        throw FormatException('tokens: $name fontWeight geçersiz: $weight');
      }
      typeStyles[id] = TypeSpec(
        family: family,
        size: _px(s['fontSize']! as String, name),
        lineHeight: _px(s['lineHeight']! as String, name),
        weight: weight,
        letterSpacingEm: lsMatch == null ? 0 : double.parse(lsMatch.group(1)!),
      );
    }
  }
  if (typeStyles.isEmpty) {
    throw const FormatException('tokens: metin stili yok');
  }

  Map<String, double> scalars(String section, String prefix) {
    final out = <String, double>{};
    for (final t in list(d[section], section)) {
      final id = tokenIdent(t['name']! as String, prefix);
      if (out.containsKey(id)) {
        throw FormatException('tokens: yinelenen $section $id');
      }
      out[id] = _px(t['value']! as String, '$section.${t['name']}');
    }
    return out;
  }

  final shadowsLight = <String, ShadowSpec>{};
  final shadowsDark = <String, ShadowSpec>{};
  for (final t in list(d['shadow'], 'shadow')) {
    final name = t['name']! as String;
    final id = tokenIdent(name, 'm-sh-');
    final v = t['value'];
    final byMode = v is String
        ? {'dark': v, 'light': v}
        : (v! as Map<String, Object?>).map((k, x) => MapEntry(k, x! as String));
    if (byMode['dark'] == null || byMode['light'] == null) {
      throw FormatException('tokens: gölge $name iki temada tanımlı değil');
    }
    shadowsDark[id] = parseShadow(byMode['dark']!, name);
    shadowsLight[id] = parseShadow(byMode['light']!, name);
  }

  Map<String, double> mobileNums(String key) {
    final m = mob[key];
    if (m is! Map<String, Object?>) {
      throw FormatException('mobile-tokens: "$key" yok');
    }
    return {
      for (final MapEntry(key: k, value: v) in m.entries)
        if (!k.startsWith(r'$'))
          k: v is num
              ? v.toDouble()
              : throw FormatException('mobile-tokens: $key.$k sayı değil'),
    };
  }

  final spacingScale = mobileNums('spacingScale');
  if (spacingScale.keys.any((k) => int.tryParse(k) == null)) {
    throw const FormatException(
      'mobile-tokens: spacingScale anahtarı tamsayı olmalı',
    );
  }
  final size = scalars('size', 'm-');
  final metrics = mobileNums('metrics');
  final clash = metrics.keys.toSet().intersection(size.keys.toSet());
  if (clash.isNotEmpty) {
    throw FormatException(
      'mobile-tokens: metrics tasarım size adıyla çakışıyor: $clash',
    );
  }

  return ResolvedTokens(
    roles: roles,
    light: light,
    dark: dark,
    families: families,
    typeStyles: typeStyles,
    spacingScale: spacingScale,
    spacing: scalars('spacing', 'm-'),
    radius: scalars('radius', 'm-r-'),
    size: size,
    blur: scalars('blur', 'm-blur-'),
    metrics: metrics,
    shadowsLight: shadowsLight,
    shadowsDark: shadowsDark,
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
