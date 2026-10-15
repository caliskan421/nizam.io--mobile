// Katman / sınır kuralı (F14 MOB-0 kapsam 2). AST tabanlıdır (package:analyzer), metin
// araması değildir: yorum veya dize içindeki sözcükler ihlal sayılmaz, takma adlı (`as`)
// importlar ve göreli yollar çözülür.
//
// Kurallar (kimlikler hata çıktısında ve testlerde kullanılır):
//   B1  core → features/app yasak. `lib/core/**` yalnız core'u ve paketleri import eder.
//   B2  features → app yasak.
//   B3  Bir feature başka feature'ın İÇ katmanını import etmez; yalnız açık yüzü
//       `features/<g>/<g>.dart` kullanılabilir.
//   B4  Feature içi katman yönü: presentation → {application, domain};
//       application → {domain, data}; data → {domain}; domain → {}.
//   B5  `features/<f>/` altında yalnız presentation/application/domain/data katmanları ve
//       `<f>.dart` açık yüzü bulunur; `lib/` kökünde yalnız main*.dart.
//   D1  Elle DTO yasak (üretilmiş `lib/core/api/generated/**` dışı): json_annotation importu,
//       Json* açıklamaları, fromJson/toJson adlı her bildirim.
//   D2  features/** içinde `dart:convert` importu, `Map<String, …>` tip açıklaması ve
//       dize anahtarlı Map literal (`{'k': v}`, `<String, X>{…}`) yasak (elle JSON gövdesi
//       kurmanın kaçış yolları).
//   S1  flutter_secure_storage yalnız `lib/core/storage/**` içinde; oradan bile `export`
//       edilemez (barrel ile taşıma yok).
//   S2  `badCertificateCallback`, `HttpOverrides` (ifade ve tip konumu: typedef, extends)
//       hiçbir yerde (TLS hatası yutulmaz).
//   S3  `debugPrint` ve `dart:developer` yalnız `lib/core/logging/**` içinde (log tek yoldan
//       ve redaksiyonla; `print` ayrıca avoid_print ile yasak).
//   S4  domain katmanı Flutter/dio/Riverpod import etmez (saf Dart); hiçbir dosya bu
//       paketleri `export` edemez (core barrel'ı ile domain'e transitif sızma yok).
//   S5  shared_preferences YALNIZ `lib/core/storage/shared_preference_store.dart` içinde
//       (kesin dosya; aynı dizinde ikinci bir bağdaştırıcı yok — gizli veri SecureStore'a, S1).
//   S6  firebase_* yalnız `lib/app/**` ve `lib/core/telemetry/telemetry.dart` içinde (kesin
//       dosya; başlatma ve telemetri tek yerden).
//   S7  Ham tercih deposu (`core/storage/preference_store.dart`,
//       `shared_preference_store.dart`) yalnız bu iki dosya,
//       `core/preferences/app_preferences.dart` ve `lib/app/di/**` tarafından import edilir
//       (kesin dosya listesi — tip silme/geri çağrı ile taşıyan facade yazılamaz; A5):
//       serbest anahtarla yazma yalnız tipli `AppPreferences` içinden (gizli veri kaçmasın).
//       Ham depo ve S5/S6 paketleri hiçbir yerden `export` edilemez (barrel ile taşıma yok).
//   U1  Boşluk için `SizedBox` yasak, standart `Gap` (package:gap): çocuksuz
//       `SizedBox(width/height)`, `SizedBox.square`, `SizedBox.fromSize`. Çocuklu SizedBox
//       (boyut kısıtı) ve `SizedBox.shrink/expand` serbest. `SizedBox.new(...)`, yapıcı
//       tear-off'u (`SizedBox.new`, `SizedBox.square`) ve `typedef X = SizedBox` de yakalanır; dosya kendi `SizedBox` sınıfını tanımlıyorsa
//       (Flutter'ınki değil) kural uygulanmaz.
//   U2  Ham renk yasak: `Color(…)`, `Color.from/fromARGB/fromRGBO/new`, `Colors.<x>`,
//       `CupertinoColors.<x>` (ADR-0003 Ek A). İzinli: `lib/core/ui/theme/**`,
//       `lib/core/theme/generated/**`, `lib/core/security/privacy_mask.dart` (kesin dosya).
//       Takma adlı importlar ve `typedef` takma adları yakalanır.
//   U3  Ham metin stili yasak: `TextStyle(…)` yalnız `lib/core/ui/theme/**`;
//       `package:google_fonts` importu `lib/core/ui/theme/**`, `lib/app/bootstrap.dart` içinde.
//       `copyWith` her yerde serbest.
//   U4  `MediaQuery.of` / `MediaQuery.maybeOf` (ve tear-off'ları) yasak; `sizeOf`,
//       `paddingOf`, `maybeSizeOf` … serbest.
//   U5  `.extension<…>()` ve `ThemeData.extensions` erişimi yalnız
//       `lib/core/ui/extensions/context_ext.dart` içinde (`ThemeData(extensions: …)` kurulum,
//       erişim değil).
//   U6  `Scaffold` / `CupertinoPageScaffold` yapıcısı `lib/features/**/presentation/**` içinde
//       yasak (sayfa kabuğu `NzPage`).
//   U1–U6 ayrıca TİP ÇÖZÜMLEMELİ koşar (tool/api_surface.dart `checkUiResolved`, Codex 6):
//       bu dosyadaki ad tabanlı denetim `typedef C = Color` + `C(...)`, yerel `SizedBox`
//       sınıfı yanında önekli Flutter `SizedBox` ve örtük `extensions` erişimini göremez;
//       çözümlenmiş element görür. Politika (izinli yollar) `uiPolicyFor` ile ortaktır.
//   G3  Sunum katmanında `*Service`/`*Repository` yapıcı çağrısı yasak: TİP ÇÖZÜMLEMELİ,
//       tool/api_surface.dart'tadır (`checkServiceConstruction`).
//   N1  Gezinme kimlik kuralı (ADR-0003 karar 21): `lib/features/**` ve `lib/app/**`
//       (`lib/app/router/**` hariç) içinde go_router `context.go/push/pushReplacement/replace/
//       goNamed/pushNamed/pushReplacementNamed/replaceNamed`, `extra:` argümanı ve
//       `GoRouterState.extra` yasak; tipli rota `.go/.push(context)` serbest. TİP
//       ÇÖZÜMLEMELİ, tool/api_surface.dart'tadır (`checkNavigation`).
//   G1  `package:get_it` yalnız `lib/app/**` ve `features/<f>/<f>_module.dart` içinde
//       (ADR-0001, D-0182: get_it = bileşim kökü; core ve feature katmanları servis bulucu
//       kullanmaz, bağımlılık yapıcıdan gelir).
//   G2  `features/<f>/<f>_module.dart` (modül kayıt fonksiyonu) yalnız `lib/app/di/**`
//       tarafından import edilir.
//   A1  Üretilmiş API kodu (`lib/core/api/generated/**`: DTO'lar, enum'lar, istemciler)
//       features içinde yalnız `data` katmanında ve `<f>_module.dart`'ta (istemci kurulumu)
//       import edilir. data DTO'yu domain varlığına eşler; presentation/application/domain
//       ve açık yüz sözleşme tiplerini görmez (backend alan değişikliği UI'a sızmaz).
//       Üretilmiş kod yalnız üretilmiş koddan `export` edilir (barrel üzerinden transitif
//       sızma kapalı). Koşullu import/export URI'leri ve `part` yönergeleri de denetlenir;
//       `package:` yolları normalize edilir (`..` ile kaçış).
//   A2/A3  Açık API yüzeyinde üretilmiş tip yok (data katmanı ve core): TİP ÇÖZÜMLEMESİ
//       gerektirdiği için tool/api_surface.dart'tadır.
//   B9  Yalnız `dart:`, `package:` ve göreli URI: `file:`/`http:`/mutlak yol import, export
//       ve part'ı yasak (yol tabanlı B1–B4, G1/G2, A1, S7 kontrollerini çözümsüz
//       bırakıp aşmasın). Fail-closed: B8 gibi başka kurala girmeden ihlaldir.
//   B8  URI kanonik olmalı: yüzde-kodlama (`g%65nerated`, `get%5Fit`), `.`/`..` yol
//       bileşeni, ters eğik çizgi ve büyük harfli şema (`PACKAGE:`) yasak — derleyici bunları çözer, ham dize karşılaştırması aşılırdı.
//       Fail-closed: kanonik olmayan URI başka kurallara hiç girmeden ihlaldir.
//   B7  Koşullu import/export (`if (dart.library.io) '…'`) üretilmiş kod dışında yasak: tip
//       çözümlemeli A2/A3 denetimi tek yapılandırmayı çözümler, dallar arası farklı tip
//       seçimi denetimden kaçardı.
//   B6  `part` / `part of` yalnız aynı dizindeki dosyayı gösterir (katmanlar arası part
//       tüneli ve kütüphane adıyla `part of` yasak).
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

/// Paket adı (pubspec `name`).
const packageName = 'nizamio';

/// Üretilmiş API kodu (DTO yalnız burada).
const generatedApiDir = 'core/api/generated/';

/// Üretilmiş i18n kodu (ADR-0003 Ek A): api/generated ile aynı muafiyet kapsamı.
const generatedI18nDir = 'core/i18n/generated/';

const _layers = {'presentation', 'application', 'domain', 'data'};

const _allowedLayerDeps = <String, Set<String>>{
  'presentation': {'presentation', 'application', 'domain'},
  'application': {'application', 'domain', 'data'},
  'data': {'data', 'domain'},
  'domain': {'domain'},
};

const _jsonAnnotations = {
  'JsonSerializable',
  'JsonKey',
  'JsonValue',
  'JsonEnum',
  'JsonConverter',
  'JsonLiteral',
};

const _domainBanned = [
  'package:flutter/',
  'package:dio/',
  'package:flutter_riverpod/',
  'package:riverpod',
];

final _jsonMember = RegExp(r'(from|to)json$', caseSensitive: false);

/// Tek ihlal.
class Violation {
  Violation(this.rule, this.path, this.line, this.message);

  final String rule;
  final String path;
  final int line;
  final String message;

  @override
  String toString() => '$path:$line [$rule] $message';
}

/// `lib/` göreli yolun yerleşimi.
class _Place {
  _Place(this.path) {
    final parts = path.split('/');
    if (parts.first == 'core') {
      area = 'core';
    } else if (parts.first == 'app') {
      area = 'app';
    } else if (parts.first == 'features' && parts.length >= 3) {
      area = 'feature';
      feature = parts[1];
      if (parts.length == 3 && parts[2] == '${parts[1]}.dart') {
        layer = 'facade';
      } else if (parts.length == 3 && parts[2] == '${parts[1]}_module.dart') {
        layer = 'module';
      } else if (parts.length >= 4 && _layers.contains(parts[2])) {
        layer = parts[2];
      } else {
        layer = 'unknown';
      }
    } else if (parts.length == 1) {
      area = 'root';
    } else {
      area = 'unknown';
    }
  }

  final String path;
  late final String area;
  String? feature;
  String? layer;
}

/// [libPath]: `lib/` göreli yol (ör. `features/identity/data/x.dart`).
/// [allowances]: false ise U2–U6'nın izinli yolları devre dışı (ham ölçüm; yalnız testler).
List<Violation> checkSource(
  String libPath,
  String content, {
  bool allowances = true,
}) {
  final unit = parseString(
    content: content,
    path: '/lib/$libPath',
    throwIfDiagnostics: false,
  ).unit;
  final lineInfo = unit.lineInfo;
  final here = _Place(libPath);
  final out = <Violation>[];
  void add(String rule, AstNode node, String message) {
    out.add(
      Violation(
        rule,
        'lib/$libPath',
        lineInfo.getLocation(node.offset).lineNumber,
        message,
      ),
    );
  }

  final generated =
      libPath.startsWith(generatedApiDir) ||
      libPath.startsWith(generatedI18nDir);

  // B5 — yerleşim.
  if (here.area == 'root' &&
      !RegExp(r'^main(_\w+)?\.dart$').hasMatch(libPath)) {
    out.add(
      Violation('B5', 'lib/$libPath', 1, 'lib/ kökünde yalnız main*.dart olur'),
    );
  }
  if (here.area == 'unknown') {
    out.add(
      Violation(
        'B5',
        'lib/$libPath',
        1,
        'lib/ altında yalnız app/, core/, features/ olur',
      ),
    );
  }
  if (here.area == 'feature' && here.layer == 'unknown') {
    out.add(
      Violation(
        'B5',
        'lib/$libPath',
        1,
        'features/<f>/ altında yalnız presentation|application|domain|data, <f>.dart ve <f>_module.dart olur',
      ),
    );
  }

  for (final directive in unit.directives) {
    // B6 — part tüneli.
    if (directive is PartDirective || directive is PartOfDirective) {
      final uri = directive is PartDirective
          ? directive.uri.stringValue
          : (directive as PartOfDirective).uri?.stringValue;
      final target = uri == null || !_canonical(uri)
          ? null
          : _resolve(here.path, uri);
      if (target == null ||
          p.posix.dirname(target) != p.posix.dirname(here.path)) {
        add(
          'B6',
          directive,
          'part/part of yalnız aynı dizindeki dosyayı URI ile gösterir: ${uri ?? 'kütüphane adı'}',
        );
      }
    }
    if (directive is! NamespaceDirective && directive is! PartDirective) {
      continue;
    }
    if (!generated &&
        directive is NamespaceDirective &&
        directive.configurations.isNotEmpty) {
      add(
        'B7',
        directive,
        'koşullu import/export yasak (A2/A3 tek yapılandırmayı çözümler)',
      );
    }
    final uris = [
      (directive as UriBasedDirective).uri.stringValue,
      // Koşullu import/export (`if (dart.library.io) '…'`) her dalı ayrıca denetlenir.
      if (directive is NamespaceDirective)
        for (final c in directive.configurations) c.uri.stringValue,
    ];
    for (final uri in uris) {
      if (uri == null) continue;
      if (!_canonical(uri)) {
        add(
          'B8',
          directive,
          'kanonik olmayan URI (yüzde-kodlama veya ./..): $uri',
        );
        continue;
      }
      if (_nonLocalScheme(uri)) {
        add(
          'B9',
          directive,
          'yalnız dart:, package: ve göreli URI (file:/mutlak yol yol denetimlerini aşar): $uri',
        );
        continue;
      }
      _checkUri(
        here,
        uri,
        (rule, msg) => add(rule, directive, msg),
        generated,
        isExport: directive is ExportDirective,
        googleFontsAllowed:
            allowances &&
            (here.path.startsWith('core/ui/theme/') ||
                here.path == 'app/bootstrap.dart'),
      );
    }
  }

  // Dosya kendi SizedBox'ını tanımlıyorsa U1 Flutter'ınkini değil onu görür.
  final ownSizedBox = unit.declarations.any(
    (d) => d is ClassDeclaration && d.namePart.typeName.lexeme == 'SizedBox',
  );
  unit.accept(_Visitor(here, generated, add, ownSizedBox: ownSizedBox));
  if (!generated) {
    final policy = uiPolicyFor(libPath, allowances: allowances);
    unit.accept(
      _UiVisitor(
        add,
        bans: policy.bans,
        wildcard: policy.wildcard,
        extensionBanned: policy.extensionBanned,
      ),
    );
  }

  return out;
}

/// U2–U6 politikası: [libPath] için geçerli yasaklar. Sözdizimsel ([checkSource]) ve tip
/// çözümlemeli (`checkUiResolved`, tool/api_surface.dart) denetim AYNI politikayı kullanır.
class UiPolicy {
  const UiPolicy(this.bans, this.wildcard, this.extensionBanned);

  final List<UiBan> bans;
  final Set<String> wildcard;
  final bool extensionBanned;
}

UiPolicy uiPolicyFor(String libPath, {bool allowances = true}) {
  final here = _Place(libPath);
  final colorOk =
      allowances &&
      (libPath.startsWith('core/ui/theme/') ||
          libPath.startsWith('core/theme/generated/') ||
          libPath == 'core/security/privacy_mask.dart');
  return UiPolicy(
    [
      if (!colorOk) _colorBan,
      if (!(allowances && libPath.startsWith('core/ui/theme/'))) _textStyleBan,
      _mediaQueryBan,
      if (here.area == 'feature' && here.layer == 'presentation') ...[
        _scaffoldBan,
        _cupertinoScaffoldBan,
      ],
    ],
    colorOk ? const {} : _colorNamespaces,
    !(allowances && libPath == 'core/ui/extensions/context_ext.dart'),
  );
}

/// Üretilmiş kod (api + i18n): U/S kurallarının muaf kapsamı.
bool isGeneratedPath(String libPath) =>
    libPath.startsWith(generatedApiDir) || libPath.startsWith(generatedI18nDir);

/// Paket/SDK URI'sinde yüzde-kodlama ve `.`/`..` bileşeni yok; göreli URI'de yüzde-kodlama
/// yok (göreli `..` meşrudur ve normalize edilir).
bool _canonical(String uri) {
  if (uri.contains('%') || uri.contains('\\')) return false;
  if (uri.contains(':')) {
    // Şema büyük/küçük harf duyarsızdır (`PACKAGE:get_it/…` derleyicide geçerlidir);
    // ham dize karşılaştırmaları küçük harfle yazıldığından büyük harfli şema kanonik değil.
    final scheme = uri.substring(0, uri.indexOf(':'));
    if (scheme != scheme.toLowerCase()) return false;
    final segments = uri.substring(uri.indexOf(':') + 1).split('/');
    if (segments.any((s) => s == '.' || s == '..')) return false;
  }
  return true;
}

/// `dart:`/`package:` dışı şema ya da mutlak yol (`file:`, `http:`, `/x`, `//h/x`): yol
/// tabanlı denetimler (B1–B4, G1/G2, A1, S7) bunları çözemez; lib içinde yasak.
bool _nonLocalScheme(String uri) {
  if (uri.startsWith('/')) return true;
  final i = uri.indexOf(':');
  if (i < 0) return false;
  final scheme = uri.substring(0, i);
  return scheme != 'dart' && scheme != 'package';
}

/// `lib/` göreli kaynak yolundan URI'nin `lib/` göreli hedefi; paket dışı veya `lib/`
/// dışına kaçan yolda null.
String? _resolve(String fromPath, String uri) {
  String target;
  if (uri.startsWith('package:$packageName/')) {
    target = p.posix.normalize(uri.substring('package:$packageName/'.length));
  } else if (!uri.contains(':')) {
    target = p.posix.normalize(p.posix.join(p.posix.dirname(fromPath), uri));
  } else {
    return null;
  }
  return target.startsWith('..') ? null : target;
}

void _checkUri(
  _Place here,
  String uri,
  void Function(String rule, String msg) add,
  bool generated, {
  bool isExport = false,
  required bool googleFontsAllowed,
}) {
  final target = _resolve(here.path, uri); // lib göreli hedef

  // Paket kuralları.
  if (uri.startsWith('package:flutter_secure_storage/') &&
      (!here.path.startsWith('core/storage/') || isExport)) {
    add(
      'S1',
      'flutter_secure_storage yalnız lib/core/storage/ içinde import edilir '
          've dışa verilemez (barrel ile taşıma yasak)',
    );
  }
  if (isExport &&
      (uri.startsWith('package:shared_preferences/') ||
          uri.startsWith('package:firebase_'))) {
    add('S7', 'SDK paketi dışa verilemez (barrel ile taşıma yasak): $uri');
  }
  if (uri.startsWith('package:shared_preferences/') &&
      here.path != 'core/storage/shared_preference_store.dart') {
    add(
      'S5',
      'shared_preferences yalnız lib/core/storage/shared_preference_store.dart içinde',
    );
  }
  if (uri.startsWith('package:firebase_') &&
      here.area != 'app' &&
      here.path != 'core/telemetry/telemetry.dart') {
    add(
      'S6',
      'firebase yalnız lib/app/** ve lib/core/telemetry/telemetry.dart içinde',
    );
  }
  if (uri == 'dart:developer' && !here.path.startsWith('core/logging/')) {
    add(
      'S3',
      'dart:developer yalnız lib/core/logging/ içinde (log redaksiyonu tek yoldan)',
    );
  }
  if (!generated && uri.startsWith('package:json_annotation/')) {
    add('D1', 'elle DTO yasak: json_annotation yalnız üretilmiş API kodunda');
  }
  if (here.area == 'feature' && uri == 'dart:convert') {
    add(
      'D2',
      'features/** içinde dart:convert yasak (JSON yalnız üretilmiş tiplerle)',
    );
  }
  if (isExport && !generated && _domainBanned.any(uri.startsWith)) {
    // Hiçbir dosya Flutter/dio/Riverpod'u dışa veremez: domain katmanı core/açık yüz
    // barrel'ından saf-Dart sınırını aşmadan alamaz (Codex 7).
    add(
      'S4',
      'Flutter/dio/Riverpod dışa verilemez (barrel ile taşıma yasak): $uri',
    );
  } else if (here.area == 'feature' && here.layer == 'domain') {
    for (final banned in _domainBanned) {
      if (uri.startsWith(banned)) {
        add('S4', 'domain katmanı saf Dart olmalı: $uri');
      }
    }
  }

  if (uri.startsWith('package:google_fonts/') && !googleFontsAllowed) {
    add(
      'U3',
      'google_fonts yalnız lib/core/ui/theme/** ve lib/app/bootstrap.dart içinde '
          '(GoogleFonts.*() ham TextStyle döndürür): $uri',
    );
  }

  if (uri.startsWith('package:get_it/') &&
      here.area != 'app' &&
      !(here.area == 'feature' && here.layer == 'module')) {
    add(
      'G1',
      'get_it yalnız lib/app/** ve features/<f>/<f>_module.dart içinde (bileşim kökü; servis bulucu yok)',
    );
  }

  if (target == null) return;
  final there = _Place(target);
  final rawPrefs =
      target == 'core/storage/preference_store.dart' ||
      target == 'core/storage/shared_preference_store.dart';
  if (rawPrefs && isExport) {
    add(
      'S7',
      'ham tercih deposu dışa verilemez (barrel ile taşıma yasak): $uri',
    );
  } else if (rawPrefs &&
      here.path != 'core/storage/preference_store.dart' &&
      here.path != 'core/storage/shared_preference_store.dart' &&
      here.path != 'core/preferences/app_preferences.dart' &&
      !here.path.startsWith('app/di/')) {
    add(
      'S7',
      'ham tercih deposu yalnız AppPreferences ve bileşim kökünden kullanılır: $uri',
    );
  }
  if (target.startsWith(generatedApiDir) && !generated) {
    if (isExport) {
      add(
        'A1',
        'üretilmiş API kodu yalnız üretilmiş koddan dışa verilir (barrel ile sızma): $uri',
      );
    } else if (here.area == 'feature' &&
        here.layer != 'data' &&
        here.layer != 'module') {
      add(
        'A1',
        'üretilmiş API kodu features içinde yalnız data katmanında ve <f>_module.dart\'ta: $uri (domain varlığına eşleyin)',
      );
    }
  }
  if (there.area == 'feature' &&
      there.layer == 'module' &&
      !here.path.startsWith('app/di/')) {
    add(
      'G2',
      'modül kayıt fonksiyonu yalnız lib/app/di/ tarafından import edilir: $uri',
    );
  }

  switch (here.area) {
    case 'core':
      if (there.area == 'feature' || there.area == 'app') {
        add(
          'B1',
          'core, ${there.area == 'app' ? 'app' : 'features'} katmanına bağımlı olamaz: $uri',
        );
      }
    case 'feature':
      if (there.area == 'app') {
        add('B2', 'features, app katmanını import edemez: $uri');
      } else if (there.area == 'feature') {
        if (there.feature != here.feature) {
          if (there.layer != 'facade' && there.layer != 'module') {
            add(
              'B3',
              "başka feature'ın iç katmanı: $uri (yalnız features/${there.feature}/${there.feature}.dart)",
            );
          }
        } else if (here.layer != 'facade' &&
            here.layer != 'module' &&
            here.layer != 'unknown' &&
            there.layer != 'module') {
          final allowed = _allowedLayerDeps[here.layer]!;
          if (there.layer == 'facade' || !allowed.contains(there.layer)) {
            add(
              'B4',
              'katman yönü ihlali: ${here.layer} → ${there.layer} ($uri)',
            );
          }
        }
      }
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  _Visitor(this.here, this.generated, this.add, {this.ownSizedBox = false});

  final _Place here;
  final bool generated;
  final bool ownSizedBox;
  final void Function(String rule, AstNode node, String message) add;

  void _member(AstNode node, String name) {
    if (!generated && _jsonMember.hasMatch(name)) {
      add(
        'D1',
        node,
        'elle DTO yasak: "$name" bildirimi (JSON yalnız üretilmiş tiplerde)',
      );
    }
  }

  @override
  void visitAnnotation(Annotation node) {
    final name = node.name.name.split('.').last;
    if (!generated && _jsonAnnotations.contains(name)) {
      add('D1', node, 'elle DTO yasak: @$name');
    }
    super.visitAnnotation(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    _member(node, node.name.lexeme);
    super.visitMethodDeclaration(node);
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    final name = node.name?.lexeme;
    if (name != null) _member(node, name);
    super.visitConstructorDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _member(node, node.name.lexeme);
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    _member(node, node.name.lexeme);
    super.visitVariableDeclaration(node);
  }

  // D2 — `Map` adı geçmeyen Map literalleri: `{'password': p}` (çıkarımlı) ve
  // `<String, Object?>{…}` (tipli). Kapsam `Map<String, …>` açıklamasıyla aynıdır: features/**.
  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    if (here.area == 'feature') {
      final args = node.typeArguments?.arguments;
      final typed =
          args != null &&
          args.length == 2 &&
          args.first is NamedType &&
          (args.first as NamedType).name.lexeme == 'String';
      if (typed || node.elements.any(_stringKeyed)) {
        add(
          'D2',
          node,
          'features/** içinde dize anahtarlı Map literal yasak (elle JSON gövdesi)',
        );
      }
    }
    super.visitSetOrMapLiteral(node);
  }

  static bool _stringKeyed(CollectionElement e) => switch (e) {
    MapLiteralEntry(:final key) => key is StringLiteral,
    IfElement(:final thenElement, :final elseElement) =>
      _stringKeyed(thenElement) ||
          (elseElement != null && _stringKeyed(elseElement)),
    ForElement(:final body) => _stringKeyed(body),
    _ => false,
  };

  @override
  void visitNamedType(NamedType node) {
    // S2 — tip konumu (`typedef O = HttpOverrides`, `extends`, önekli `io.HttpOverrides`).
    if (node.name.lexeme == 'HttpOverrides') {
      add(
        'S2',
        node,
        'HttpOverrides yasak: TLS/HTTP doğrulaması asla gevşetilmez',
      );
    }
    if (here.area == 'feature' && node.name.lexeme == 'Map') {
      final args = node.typeArguments?.arguments;
      if (args != null &&
          args.isNotEmpty &&
          args.first is NamedType &&
          (args.first as NamedType).name.lexeme == 'String') {
        add(
          'D2',
          node,
          'features/** içinde Map<String, …> yasak (elle JSON gövdesi)',
        );
      }
    }
    super.visitNamedType(node);
  }

  // U1 — `const SizedBox(...)` InstanceCreationExpression, `SizedBox(...)` (const/new'siz)
  // çözümlenmemiş AST'de MethodInvocation olarak gelir; ikisi de denetlenir.
  void _spacer(AstNode node, String? ctor, ArgumentList args) {
    if (generated || ownSizedBox) return;
    if (ctor == 'new') ctor = null;
    if (ctor != null && ctor != 'square' && ctor != 'fromSize') return;
    final hasChild = args.arguments.any(
      (a) => a is NamedArgument && a.name.lexeme == 'child',
    );
    if (!hasChild) {
      add('U1', node, 'boşluk için SizedBox yerine Gap (package:gap) kullanın');
    }
  }

  // Yapıcı tear-off'u (`final f = SizedBox.new; f(height: 8)`) argümanı görünmeden çağrılır:
  // boşluk yapıcılarının tear-off'u koşulsuz yasak. Çağrı biçimi MethodInvocation olarak
  // ayrı denetlenir; burada yalnız çağrılmayan başvuru gelir.
  // Çağrılan biçim (`SizedBox.new(...)`) MethodInvocation olarak gelir; PrefixedIdentifier /
  // PropertyAccess ise çağrılmayan başvurudur (tear-off).
  static const _spacerCtors = {'new', 'square', 'fromSize'};

  void _tearOff(AstNode node) {
    if (!generated && !ownSizedBox) {
      add(
        'U1',
        node,
        'SizedBox yapıcı tear-off yasak (U1 atlatma); Gap kullanın',
      );
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.prefix.name == 'SizedBox' &&
        _spacerCtors.contains(node.identifier.name)) {
      _tearOff(node);
    }
    super.visitPrefixedIdentifier(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    final t = node.target;
    if (t is PrefixedIdentifier &&
        t.identifier.name == 'SizedBox' &&
        _spacerCtors.contains(node.propertyName.name)) {
      _tearOff(node); // m.SizedBox.new
    }
    super.visitPropertyAccess(node);
  }

  @override
  void visitConstructorReference(ConstructorReference node) {
    final c = node.constructorName;
    if (!generated &&
        !ownSizedBox &&
        c.type.name.lexeme == 'SizedBox' &&
        const {null, 'new', 'square', 'fromSize'}.contains(c.name?.name)) {
      add(
        'U1',
        node,
        'SizedBox yapıcı tear-off yasak (U1 atlatma); Gap kullanın',
      );
    }
    super.visitConstructorReference(node);
  }

  @override
  void visitGenericTypeAlias(GenericTypeAlias node) {
    final t = node.type;
    if (!generated &&
        !ownSizedBox &&
        t is NamedType &&
        t.name.lexeme == 'SizedBox') {
      add('U1', node, 'SizedBox takma adı yasak (U1 atlatma); Gap kullanın');
    }
    super.visitGenericTypeAlias(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final type = node.constructorName.type;
    if (type.name.lexeme == 'SizedBox') {
      _spacer(node, node.constructorName.name?.name, node.argumentList);
    } else if (type.importPrefix?.name.lexeme == 'SizedBox' &&
        node.constructorName.name == null) {
      // Çözümsüz AST `const SizedBox.square(…)`'ı önek.Tip olarak ayrıştırır.
      _spacer(node, type.name.lexeme, node.argumentList);
    }
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final target = node.target;
    if (target == null && node.methodName.name == 'SizedBox') {
      _spacer(node, null, node.argumentList);
    } else if (target is SimpleIdentifier && target.name == 'SizedBox') {
      _spacer(node, node.methodName.name, node.argumentList);
    } else if (target is PrefixedIdentifier &&
        target.identifier.name == 'SizedBox') {
      _spacer(node, node.methodName.name, node.argumentList);
    } else if (target is SimpleIdentifier &&
        node.methodName.name == 'SizedBox') {
      _spacer(node, null, node.argumentList); // önekli: m.SizedBox(...)
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    final name = node.name;
    if (name == 'badCertificateCallback' || name == 'HttpOverrides') {
      add('S2', node, '$name yasak: TLS/HTTP doğrulaması asla gevşetilmez');
    }
    if (name == 'debugPrint' && !here.path.startsWith('core/logging/')) {
      add('S3', node, 'debugPrint yalnız lib/core/logging/ içinde');
    }
    super.visitSimpleIdentifier(node);
  }
}

/// U2–U6 için yasak başvuru: [cls] sınıfının [members] üyeleri (`null` = yapıcı).
class UiBan {
  const UiBan(this.rule, this.cls, this.members, this.message);

  final String rule;
  final String cls;
  final Set<String?> members;
  final String message;
}

const _colorBan = UiBan('U2', 'Color', {
  null,
  'new',
  'from',
  'fromARGB',
  'fromRGBO',
}, 'ham renk yasak; tema token\'ı kullanın (context.colors.*)');
const _textStyleBan = UiBan('U3', 'TextStyle', {
  null,
  'new',
}, 'ham TextStyle yasak; context.text.* kullanın (copyWith serbest)');
const _mediaQueryBan = UiBan(
  'U4',
  'MediaQuery',
  {'of', 'maybeOf'},
  'MediaQuery.of/maybeOf yasak; sizeOf/paddingOf/… ya da context.layout kullanın',
);
const _scaffoldBan = UiBan('U6', 'Scaffold', {
  null,
  'new',
}, 'Scaffold sunumda yasak; NzPage kullanın');
const _cupertinoScaffoldBan = UiBan('U6', 'CupertinoPageScaffold', {
  null,
  'new',
}, 'CupertinoPageScaffold sunumda yasak; NzPage kullanın');

/// Üyesi ne olursa olsun yasak olan ad alanları (U2).
const _colorNamespaces = {'Colors', 'CupertinoColors'};

/// U2–U6 — sözdizimsel; takma adlı import (`m.Colors.red`), `typedef` takma adı ve
/// yapıcı tear-off'u yakalanır (U1 ile aynı yöntem; çözümleme gerekmez).
class _UiVisitor extends RecursiveAstVisitor<void> {
  _UiVisitor(
    this.add, {
    required this.bans,
    required this.wildcard,
    required this.extensionBanned,
  });

  final List<UiBan> bans;
  final Set<String> wildcard;
  final bool extensionBanned;
  final void Function(String rule, AstNode node, String message) add;

  void _hit(AstNode node, String cls, String? member) {
    for (final b in bans) {
      if (b.cls == cls && b.members.contains(member)) {
        add(b.rule, node, b.message);
        return;
      }
    }
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (wildcard.contains(node.name)) {
      add('U2', node, 'ham renk yasak: ${node.name}; tema token\'ı kullanın');
    }
    super.visitSimpleIdentifier(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final type = node.constructorName.type;
    final ctor = node.constructorName.name?.name;
    _hit(node, type.name.lexeme, ctor);
    // Çözümsüz AST `const Color.fromARGB(…)`'ı önek.Tip olarak ayrıştırır.
    if (ctor == null && type.importPrefix != null) {
      _hit(node, type.importPrefix!.name.lexeme, type.name.lexeme);
    }
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final target = node.target;
    final name = node.methodName.name;
    _hit(node, name, null); // Color(…) ve m.Color(…)
    if (target != null) {
      if (target is SimpleIdentifier) _hit(node, target.name, name);
      if (target is PrefixedIdentifier) {
        _hit(node, target.identifier.name, name); // m.MediaQuery.of(…)
      }
    }
    // Hedefli `t.extension<T>()` ve `extension ThemeData` içindeki örtük-this
    // `extension<T>()` çağrısı aynı ihlaldir.
    if (extensionBanned && name == 'extension') {
      add('U5', node, _extMessage);
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    _hit(node, node.prefix.name, node.identifier.name); // tear-off: Color.new
    if (extensionBanned && _extMembers.contains(node.identifier.name)) {
      add('U5', node, _extMessage);
    }
    super.visitPrefixedIdentifier(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    final t = node.target;
    final name = node.propertyName.name;
    if (t is PrefixedIdentifier) {
      _hit(node, t.identifier.name, name); // m.Color.new
    }
    if (extensionBanned && _extMembers.contains(name)) {
      add('U5', node, _extMessage);
    }
    super.visitPropertyAccess(node);
  }

  @override
  void visitConstructorReference(ConstructorReference node) {
    final c = node.constructorName;
    _hit(node, c.type.name.lexeme, c.name?.name);
    super.visitConstructorReference(node);
  }

  void _alias(AstNode node, NamedType type) {
    final n = type.name.lexeme;
    if (wildcard.contains(n) || bans.any((b) => b.cls == n)) {
      add(
        bans.where((b) => b.cls == n).firstOrNull?.rule ?? 'U2',
        node,
        '$n takma adı yasak (atlatma)',
      );
    }
  }

  @override
  void visitGenericTypeAlias(GenericTypeAlias node) {
    final t = node.type;
    if (t is NamedType) _alias(node, t);
    super.visitGenericTypeAlias(node);
  }

  @override
  void visitExtendsClause(ExtendsClause node) {
    final n = node.superclass.name.lexeme;
    for (final b in bans) {
      if (b.cls == n && b.members.contains(null)) {
        add(b.rule, node, '$n alt sınıflanamaz (yapıcı yasağının atlatması)');
      }
    }
    super.visitExtendsClause(node);
  }
}

const _extMembers = {'extension', 'extensions'};
const _extMessage =
    'tema uzantısına yalnız lib/core/ui/extensions/context_ext.dart erişir '
    '(context.colors / context.text kullanın)';
