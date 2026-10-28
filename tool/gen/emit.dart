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

String _argb(int v) =>
    'Color(0x${v.toRadixString(16).padLeft(8, '0').toUpperCase()})';

String _num(double v) => v.toString();

String _cap(String s) => s[0].toUpperCase() + s.substring(1);

/// Mod bağımlı alanlar için ThemeExtension sınıfı (renk ya da gölge).
void _emitExtension(
  StringBuffer b, {
  required String name,
  required String doc,
  required String type,
  required List<String> fields,
  required Map<String, String> light,
  required Map<String, String> dark,
  required String Function(String a, String b) lerp,
}) {
  b
    ..writeln('/// $doc')
    ..writeln('@immutable')
    ..writeln('class $name extends ThemeExtension<$name> {')
    ..writeln('  const $name({')
    ..writeln(fields.map((r) => '    required this.$r,').join('\n'))
    ..writeln('  });')
    ..writeln()
    ..writeln(fields.map((r) => '  final $type $r;').join('\n'))
    ..writeln()
    ..writeln('  static const light = $name(')
    ..writeln(fields.map((r) => '    $r: ${light[r]},').join('\n'))
    ..writeln('  );')
    ..writeln()
    ..writeln('  static const dark = $name(')
    ..writeln(fields.map((r) => '    $r: ${dark[r]},').join('\n'))
    ..writeln('  );')
    ..writeln()
    ..writeln('  @override')
    ..writeln('  $name copyWith({')
    ..writeln(fields.map((r) => '    $type? $r,').join('\n'))
    ..writeln('  }) {')
    ..writeln('    return $name(')
    ..writeln(fields.map((r) => '      $r: $r ?? this.$r,').join('\n'))
    ..writeln('    );')
    ..writeln('  }')
    ..writeln()
    ..writeln('  @override')
    ..writeln('  $name lerp($name? other, double t) {')
    ..writeln('    if (other == null) return this;')
    ..writeln('    return $name(')
    ..writeln(fields.map((r) => '      $r: ${lerp(r, 'other.$r')},').join('\n'))
    ..writeln('    );')
    ..writeln('  }')
    ..writeln('}')
    ..writeln();
}

String _shadow(ShadowSpec s) =>
    '[BoxShadow(color: ${_argb(s.argb)}, offset: Offset(${_num(s.dx)}, ${_num(s.dy)}), '
    'blurRadius: ${_num(s.blur)}, spreadRadius: ${_num(s.spread)})]';

void _emitScalars(
  StringBuffer b,
  String cls,
  String doc,
  Map<String, double> values, [
  String prefix = '',
]) {
  b
    ..writeln('/// $doc')
    ..writeln('abstract final class $cls {');
  for (final MapEntry(:key, :value) in values.entries) {
    final id = prefix.isEmpty ? key : '$prefix$key';
    b.writeln('  static const double $id = ${_num(value)};');
  }
  b
    ..writeln('}')
    ..writeln();
}

String emitTokens(ResolvedTokens t, String source) {
  final b = StringBuffer()
    ..write(generatedHeader(source))
    ..writeln('//')
    ..writeln(
      '// Değerler tasarım sistemi tokens.json\'dan; rol eşlemesi ve mobil değerler design/mobile-tokens.json\'dan.',
    )
    ..writeln()
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln();
  _emitExtension(
    b,
    name: 'NizamioColors',
    doc: 'Anlamsal renk rolleri — Material temasına ThemeExtension olarak eklenir.',
    type: 'Color',
    fields: t.roles,
    light: {for (final r in t.roles) r: _argb(t.light[r]!)},
    dark: {for (final r in t.roles) r: _argb(t.dark[r]!)},
    lerp: (a, o) => 'Color.lerp($a, $o, t)!',
  );
  final shadows = t.shadowsLight.keys.toList();
  _emitExtension(
    b,
    name: 'NizamioShadows',
    doc: 'Gölgeler (CSS blur değeri `blurRadius` olarak taşınır) — ThemeExtension.',
    type: 'List<BoxShadow>',
    fields: shadows,
    light: {for (final s in shadows) s: _shadow(t.shadowsLight[s]!)},
    dark: {for (final s in shadows) s: _shadow(t.shadowsDark[s]!)},
    lerp: (a, o) => 'BoxShadow.lerpList($a, $o, t)!',
  );

  final scale = t.spacingScale.keys.toList()
    ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
  _emitScalars(
    b,
    'NizamioSpacing',
    'Boşluk (mantıksal piksel): 4 pt ızgara `spaceN` (mobil) + tasarımın anlamsal boşlukları.',
    {for (final k in scale) 'space$k': t.spacingScale[k]!, ...t.spacing},
  );
  _emitScalars(
    b,
    'NizamioRadius',
    'Köşe yarıçapları (mantıksal piksel).',
    t.radius,
  );
  _emitScalars(
    b,
    'NizamioSize',
    'Sabit ölçüler: dokunma hedefi, çubuk yükseklikleri; ikon ve çizgi kalınlıkları (mobil).',
    {...t.size, ...t.metrics},
  );
  _emitScalars(
    b,
    'NizamioBlur',
    'Arka plan bulanıklığı (backdrop) yarıçapları.',
    t.blur,
  );

  b
    ..writeln(
      '/// Tasarım metin stili (kaynak birimleri: px, em). `NzTextStyles` rollere çevirir.',
    )
    ..writeln('@immutable')
    ..writeln('class NizamioTypeSpec {')
    ..writeln('  const NizamioTypeSpec({')
    ..writeln('    required this.family,')
    ..writeln('    required this.size,')
    ..writeln('    required this.lineHeight,')
    ..writeln('    required this.weight,')
    ..writeln('    required this.letterSpacingEm,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  final String family;')
    ..writeln('  final double size;')
    ..writeln('  final double lineHeight;')
    ..writeln('  final FontWeight weight;')
    ..writeln('  final double letterSpacingEm;')
    ..writeln('}')
    ..writeln()
    ..writeln(
      '/// Tipografi: aileler (birincil ad + yedek yığın) ve tasarım metin stilleri.',
    )
    ..writeln('abstract final class NizamioTypography {');
  for (final MapEntry(:key, :value) in t.families.entries) {
    b
      ..writeln(
        '  static const family${_cap(key)} = ${dartString(value.first)};',
      )
      ..writeln(
        '  static const family${_cap(key)}Fallback = <String>[${value.skip(1).map(dartString).join(', ')}];',
      );
  }
  for (final MapEntry(:key, :value) in t.typeStyles.entries) {
    b
      ..writeln('  static const $key = NizamioTypeSpec(')
      ..writeln('    family: family${_cap(value.family)},')
      ..writeln('    size: ${_num(value.size)},')
      ..writeln('    lineHeight: ${_num(value.lineHeight)},')
      ..writeln('    weight: FontWeight.w${value.weight},')
      ..writeln('    letterSpacingEm: ${_num(value.letterSpacingEm)},')
      ..writeln('  );');
  }
  b
    ..writeln()
    ..writeln(
      '  /// Bütün tasarım stilleri (ad → stil); dağıtılan yazı tipi ağırlıkları buradan denetlenir.',
    )
    ..writeln('  static const styles = <String, NizamioTypeSpec>{')
    ..writeln(
      t.typeStyles.keys.map((k) => '    ${dartString(k)}: $k,').join('\n'),
    )
    ..writeln('  };')
    ..writeln('}');
  return b.toString();
}

String emitAppVersion(String version) =>
    '${generatedHeader('pubspec.yaml version')}\n'
    '/// Uygulama sürümü (MAJOR.MINOR.PATCH); sunucunun `minimum_mobile_version` değeriyle\n'
    '/// karşılaştırılır (K-11).\n'
    'const appVersion = ${dartString(version)};\n';
