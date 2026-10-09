// Üretilmiş Dart dosyalarının metni (saf fonksiyonlar). Çıktı `dart format` ile biçimlenir.
import 'sources.dart';

String emitOperations(SpecSummary spec, String source) {
  final b = StringBuffer()
    ..write(generatedHeader(source))
    ..writeln()
    ..writeln("import '../api_meta.dart';")
    ..writeln()
    ..writeln(
      '/// Spec `info.version`; sunucunun bildirdiği `api_version` bununla eşit olmalı.',
    )
    ..writeln('const apiVersion = ${dartString(spec.apiVersion)};')
    ..writeln()
    ..writeln(
      '/// operationId → kapsam sınıfı, CSRF, kapsam başlıkları, kimlik (x-nizamio-scope-class).',
    )
    ..writeln('const apiOperations = <String, ApiOperation>{');
  for (final o in spec.operations) {
    b.writeln(
      '  ${dartString(o.operationId)}: ApiOperation('
      'operationId: ${dartString(o.operationId)}, '
      'method: ${dartString(o.method)}, '
      'path: ${dartString(o.path)}, '
      'scope: ScopeClass.${o.scope.toLowerCase()}, '
      'csrf: ${o.csrf}, '
      'programHeader: ${o.programHeader}, '
      'departmentHeader: ${o.departmentHeader}, '
      'auth: ${o.auth}),',
    );
  }
  b.writeln('};');
  return b.toString();
}

String emitErrorCatalog(Catalog catalog, String source) {
  final b = StringBuffer()
    ..write(generatedHeader(source))
    ..writeln()
    ..writeln("import '../api_meta.dart';")
    ..writeln()
    ..writeln('const errorCatalogVersion = ${catalog.version};')
    ..writeln()
    ..writeln(
      '/// Sunucu hata kodu → HTTP durum(lar)ı, alan kodları, mesaj anahtarı.',
    )
    ..writeln('const errorCatalog = <String, ErrorCatalogEntry>{');
  for (final e in catalog.entries) {
    b.writeln(
      '  ${dartString(e.code)}: ErrorCatalogEntry('
      'statuses: [${e.statuses.join(', ')}], '
      'fields: [${e.fields.map(dartString).join(', ')}], '
      'messageKey: ${dartString(e.messageKey)}),',
    );
  }
  b.writeln('};');
  return b.toString();
}

String _camel(String code) {
  final k = arbKey(code).substring(3);
  return k[0].toLowerCase() + k.substring(1);
}

String emitClientErrorCodes(Map<String, String> client, String source) {
  final codes = client.keys.toList()..sort();
  final b = StringBuffer()
    ..write(generatedHeader(source))
    ..writeln()
    ..writeln(
      "/// İstemcinin ürettiği kararlı hata kodları ('client.' önekli; sunucu kataloğunda yok).",
    )
    ..writeln('abstract final class ClientErrorCode {');
  for (final c in codes) {
    final name = _camel(c.substring('client.'.length));
    b.writeln('  static const $name = ${dartString(c)};');
  }
  b
    ..writeln()
    ..writeln('  static const all = <String>{')
    ..writeln(
      codes
          .map((c) => '    ${_camel(c.substring('client.'.length))},')
          .join('\n'),
    )
    ..writeln('  };')
    ..writeln('}');
  return b.toString();
}

String emitErrorMessages(Map<String, String> messages, String source) {
  final b = StringBuffer()
    ..write(generatedHeader(source))
    ..writeln()
    ..writeln("import 'app_localizations.dart';")
    ..writeln()
    ..writeln(
      '/// Metni olan bütün hata kodları (sunucu kataloğu ∪ alan kodları ∪ istemci kodları).',
    )
    ..writeln('const localizedErrorCodes = <String>{')
    ..writeln(messages.keys.map((c) => '  ${dartString(c)},').join('\n'))
    ..writeln('};')
    ..writeln()
    ..writeln('/// Hata kodu → yerelleştirilmiş metin; bilinmeyen kod `null`.')
    ..writeln('String? localizedErrorText(AppLocalizations l, String code) {')
    ..writeln('  switch (code) {');
  for (final code in messages.keys) {
    b
      ..writeln('    case ${dartString(code)}:')
      ..writeln('      return l.${arbKey(code)};');
  }
  b
    ..writeln('  }')
    ..writeln('  return null;')
    ..writeln('}');
  return b.toString();
}

String _hexColor(String hex) => 'Color(0xFF${hex.substring(1).toUpperCase()})';

String _ident(String prefix, String key) {
  final cleaned = key.replaceAll(RegExp('[^A-Za-z0-9]'), '');
  return prefix + cleaned[0].toUpperCase() + cleaned.substring(1);
}

String emitTokens(ResolvedTokens t, String source) {
  final roles = t.light.keys.toList()..sort();
  final b = StringBuffer()
    ..write(generatedHeader(source))
    ..writeln('//')
    ..writeln(
      '// Değerler YER TUTUCUDUR (F14 kapsam 8); ürün tasarımı sonra gelir. Web ile tek kaynak.',
    )
    ..writeln()
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln()
    ..writeln('/// Palet (açık/koyu rollerin başvurduğu tonlar).')
    ..writeln('abstract final class NizamioPalette {');
  for (final MapEntry(key: name, value: scale) in t.palette.entries) {
    final tones = scale.keys.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    for (final tone in tones) {
      b.writeln('  static const $name$tone = ${_hexColor(scale[tone]!)};');
    }
  }
  b
    ..writeln('}')
    ..writeln()
    ..writeln(
      '/// Mod rolleri — Material temasına ThemeExtension olarak eklenir.',
    )
    ..writeln('@immutable')
    ..writeln('class NizamioColors extends ThemeExtension<NizamioColors> {')
    ..writeln('  const NizamioColors({')
    ..writeln(roles.map((r) => '    required this.$r,').join('\n'))
    ..writeln('  });')
    ..writeln()
    ..writeln(roles.map((r) => '  final Color $r;').join('\n'))
    ..writeln()
    ..writeln('  static const light = NizamioColors(')
    ..writeln(roles.map((r) => '    $r: ${_hexColor(t.light[r]!)},').join('\n'))
    ..writeln('  );')
    ..writeln()
    ..writeln('  static const dark = NizamioColors(')
    ..writeln(roles.map((r) => '    $r: ${_hexColor(t.dark[r]!)},').join('\n'))
    ..writeln('  );')
    ..writeln()
    ..writeln('  @override')
    ..writeln('  NizamioColors copyWith({')
    ..writeln(roles.map((r) => '    Color? $r,').join('\n'))
    ..writeln('  }) {')
    ..writeln('    return NizamioColors(')
    ..writeln(roles.map((r) => '      $r: $r ?? this.$r,').join('\n'))
    ..writeln('    );')
    ..writeln('  }')
    ..writeln()
    ..writeln('  @override')
    ..writeln('  NizamioColors lerp(NizamioColors? other, double t) {')
    ..writeln('    if (other == null) return this;')
    ..writeln('    return NizamioColors(')
    ..writeln(
      roles.map((r) => '      $r: Color.lerp($r, other.$r, t)!,').join('\n'),
    )
    ..writeln('    );')
    ..writeln('  }')
    ..writeln('}')
    ..writeln()
    ..writeln('/// Boşluk ölçeği (mantıksal piksel).')
    ..writeln('abstract final class NizamioSpacing {');
  final spacing = t.spacing.keys.toList()
    ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
  for (final k in spacing) {
    b.writeln('  static const double space$k = ${t.spacing[k]!.toDouble()};');
  }
  b
    ..writeln('}')
    ..writeln()
    ..writeln('/// Köşe yarıçapları (mantıksal piksel).')
    ..writeln('abstract final class NizamioRadius {');
  for (final MapEntry(:key, :value) in t.radius.entries) {
    b.writeln(
      '  static const double ${_ident('radius', key)} = ${value.toDouble()};',
    );
  }
  b
    ..writeln('}')
    ..writeln()
    ..writeln('/// Tipografi.')
    ..writeln('abstract final class NizamioTypography {');
  for (final MapEntry(:key, :value) in t.fontFamily.entries) {
    b
      ..writeln(
        '  static const ${_ident('family', key)} = ${dartString(value.first)};',
      )
      ..writeln(
        '  static const ${_ident('family', key)}Fallback = <String>[${value.skip(1).map(dartString).join(', ')}];',
      );
  }
  for (final MapEntry(:key, :value) in t.fontSize.entries) {
    b.writeln(
      '  static const double ${_ident('size', key)} = ${value.toDouble()};',
    );
  }
  for (final MapEntry(:key, :value) in t.fontWeight.entries) {
    b.writeln('  static const ${_ident('weight', key)} = FontWeight.w$value;');
  }
  for (final MapEntry(:key, :value) in t.lineHeight.entries) {
    b.writeln(
      '  static const double ${_ident('lineHeight', key)} = ${value.toDouble()};',
    );
  }
  b.writeln('}');
  return b.toString();
}

String emitAppVersion(String version) =>
    '${generatedHeader('pubspec.yaml version')}\n'
    '/// Uygulama sürümü (MAJOR.MINOR.PATCH); sunucunun `minimum_mobile_version` değeriyle\n'
    '/// karşılaştırılır (K-11).\n'
    'const appVersion = ${dartString(version)};\n';
