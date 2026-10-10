// Açık API yüzeyi denetimi (sınır kuralı A2/A3). tool/boundaries.dart'ın sözdizimsel
// kurallarından farklı olarak TİP ÇÖZÜMLEMESİ yapar (package:analyzer element modeli):
// çıkarımlı tipler, typedef zincirleri, kalıtılan üyeler ve önekli importlar gerçek
// elementlerine çözülür; ad benzerliği değil elementin tanımlandığı kütüphane sayılır.
//
//   A2  features `data` katmanındaki her kütüphanenin AÇIK API'si (genel sınıf/mixin/enum/
//       extension type: üst tipler, kalıtılanlar dahil genel üyeler, genel yapıcılar;
//       extension: genişletilen tip ve üyeler; genel typedef, üst düzey işlev/değişken/
//       getter/setter) `lib/core/api/generated/**`'da tanımlanmış bir tipi içermez.
//       DTO yalnız gövdelerde ve özel (`_`) bildirimlerde kalır; dışarıya domain varlığı
//       döner.
//   A0  Denetim kendisi fail-closed'dır: çözümlenemeyen kütüphane, derleme hatası, sahibi
//       taranmamış part, bulunamayan SDK veya boş hedef kümesi ihlaldir (sessiz "temiz" yok).
//   A3  Aynı yüzey kuralı `lib/core/**` (üretilmiş kodun kendisi hariç) için de geçerlidir:
//       features'ın serbestçe import ettiği core, üretilmiş tipi dolaylı taşıyamaz.
//
//   A4  Yalıtılmış SDK ve ham tercih portu (`package:shared_preferences`, `package:firebase_*`,
//       `core/storage/preference_store.dart`, `shared_preference_store.dart`) hiçbir
//       kütüphanenin açık API'sinde görünmez (getter, fabrika, typedef, kalıtım dahil) —
//       yalnız ham depo dosyaları ve `lib/app/di/**` muaf; diğer her yerde (AppPreferences
//       dahil) yalnız YAPICI GİRDİSİ olarak görünebilir (içeri akış). S5/S6/S7 (tool/boundaries.dart) doğrudan import/export'u, A4 açık API ile
//       dolaylı taşımayı kapatır. Bütün kütüphaneler (presentation dahil) taranır.
//   A5  Bağdaştırıcı dosyaları (ham tercih deposu, `AppPreferences`, telemetri — S5/S6/S7'nin
//       kesin dosya listesi; `app/di` hariç) açık API'de tipi SİLİNMİŞ değer veremez:
//       `dynamic`, `Object`, işlev tipi (geri çağrı) dönüş/parametre/alan olarak yasak (iç
//       içe tip argümanları dahil). SDK nesnesi böylece adlandırılmış güvenli tip dışında
//       taşınamaz (CX-r3-Ö-04). `Object` üyeleri (`==`, `toString`…) sayılmaz.
//
// A1 (tool/boundaries.dart) üretilmiş koda doğrudan erişimi data + modül dosyasıyla sınırlar;
// A2/A3 kalan dolaylı yolu (açık API'de tip olarak sızma) kapatır.
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;

import 'boundaries.dart';

const _generatedUri = 'package:$packageName/$generatedApiDir';

/// [root]: depo kökü (mutlak). [overlays]: `lib/` göreli yol → içerik (testler; diskte
/// olmayan kütüphaneler eklenir veya mevcutlar gölgelenir). [only]: yalnız bu `lib/`
/// göreli yolları denetle (verilmezse A2/A3 kapsamındaki bütün kütüphaneler).
Future<List<Violation>> checkApiSurface(
  String root, {
  Map<String, String> overlays = const {},
  Iterable<String>? only,
}) async {
  root = p.normalize(p.absolute(root));
  final lib = p.join(root, 'lib');
  final provider = OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);
  for (final MapEntry(key: rel, value: content) in overlays.entries) {
    provider.setOverlay(
      p.join(lib, rel),
      content: content,
      modificationStamp: 0,
    );
  }
  final sdk = _sdkPath();
  if (sdk == null) {
    return [
      Violation('A0', 'lib', 1, 'Dart SDK bulunamadı; denetim koşulamadı'),
    ];
  }
  final collection = AnalysisContextCollection(
    includedPaths: [lib],
    resourceProvider: provider,
    sdkPath: sdk,
  );
  final session = collection.contextFor(lib).currentSession;

  final targets =
      (only ??
              [
                ...Directory(lib)
                    .listSync(recursive: true)
                    .whereType<File>()
                    .map((f) => p.relative(f.path, from: lib)),
                ...overlays.keys,
              ])
          .map((r) => r.replaceAll(r'\', '/'))
          .toSet()
          .where(_scanned)
          .toList()
        ..sort();

  final out = <Violation>[];
  if (targets.isEmpty) {
    return [
      Violation('A0', 'lib', 1, 'denetlenecek kütüphane yok (yanlış kök?)'),
    ];
  }
  final scanned = <String>{};
  final parts = <String>[];
  for (final rel in targets) {
    final result = await session.getResolvedLibrary(p.join(lib, rel));
    if (result is NotLibraryButPartResult) {
      parts.add(rel); // sahibi aşağıda doğrulanır
      continue;
    }
    if (result is! ResolvedLibraryResult) {
      out.add(
        Violation('A0', 'lib/$rel', 1, 'çözümlenemedi: ${result.runtimeType}'),
      );
      continue;
    }
    scanned.add(rel);
    final errors = [
      for (final unit in result.units)
        for (final d in unit.diagnostics)
          if (d.severity == Severity.error)
            (p.relative(unit.path, from: root), unit.lineInfo, d),
    ];
    if (errors.isNotEmpty) {
      // Çözümlenemeyen tip InvalidType olur ve sızıntı görünmez: derleme hatası ihlaldir.
      for (final (path, lineInfo, d) in errors) {
        out.add(
          Violation(
            'A0',
            path,
            lineInfo.getLocation(d.offset).lineNumber,
            'derleme hatası, açık API denetlenemez: ${d.message}',
          ),
        );
      }
      continue;
    }
    final surface = _publicSurface(result.element).toList();
    void check(
      String rule,
      bool Function(Element) match,
      String message, {
      bool inboundOk = false,
    }) {
      final reported =
          <String>{}; // alanın getter/setter'ı, değişken + getter tekrarı
      for (final (element, what, type) in surface) {
        // Yönsel muafiyet: yapıcı girdisi içeri akıştır (çağıranın nesneye zaten sahip olması
        // gerekir); dönüş, alan, getter, tip sınırı dışarı akıştır.
        if (inboundOk && element is ConstructorElement) continue;
        final leaked = _typeIn(type, match, <DartType>{});
        if (leaked == null || !reported.add(what)) continue;
        out.add(
          Violation(
            rule,
            'lib/$rel',
            _line(result, element),
            '$message: $what → $leaked',
          ),
        );
      }
    }

    if (_dtoScope(rel)) {
      check(
        rel.startsWith('core/') ? 'A3' : 'A2',
        _isGenerated,
        'açık API üretilmiş tip taşıyor (domain varlığı döndürün; DTO yalnız '
        'gövdede/özel bildirimde)',
      );
    }
    if (_adapters.contains(rel)) {
      final reported = <String>{};
      for (final (element, what, type) in surface) {
        if (element.library?.isDartCore ?? false) continue; // Object üyeleri
        if (element.name == '==') continue;
        // Örtük `Object` üst tipi taşıma değildir.
        if (element is InterfaceElement &&
            type is InterfaceType &&
            type.isDartCoreObject) {
          continue;
        }
        final types = switch (element) {
          final ExecutableElement e => [
            e.returnType,
            for (final f in e.formalParameters) f.type,
          ],
          _ => [type],
        };
        final erased = types.map(_erased).nonNulls.firstOrNull;
        if (erased == null || !reported.add(what)) continue;
        out.add(
          Violation(
            'A5',
            'lib/$rel',
            _line(result, element),
            'bağdaştırıcı açık API tipi silinmiş değer veriyor: $what → $erased',
          ),
        );
      }
    }
    if (!_sensitiveAllowed(rel)) {
      check(
        'A4',
        _isSensitive,
        'açık API yalıtılmış SDK/ham tercih tipi taşıyor (yalnız ham depo dosyaları ve '
            'app/di; diğerlerinde yalnız yapıcı girdisi)',
        inboundOk: true,
      );
    }
  }
  // Part dosyasının açık bildirimleri sahibi kütüphanenin yüzeyindedir; sahibi taranmadıysa
  // (kapsam dışı ya da yok) yüzey denetlenmemiştir.
  for (final rel in parts) {
    final owner = await session.getResolvedLibraryContaining(p.join(lib, rel));
    final ownerRel = owner is ResolvedLibraryResult
        ? p
              .relative(owner.element.firstFragment.source.fullName, from: lib)
              .replaceAll(r'\', '/')
        : null;
    if (ownerRel == null || !scanned.contains(ownerRel)) {
      out.add(
        Violation(
          'A0',
          'lib/$rel',
          1,
          'part dosyasının sahibi taranmadı: ${ownerRel ?? owner.runtimeType}',
        ),
      );
    }
  }
  return out;
}

/// Taranan kütüphaneler: üretilmiş API dizini dışındaki her `.dart` (sonekle DARALTILMAZ —
/// `.g.dart` kökü ile kaçış yok, CX-a-Ö-04).
bool _scanned(String rel) =>
    rel.endsWith('.dart') && !rel.startsWith(generatedApiDir);

/// A2/A3 kapsamı: core ve features/*/data.
bool _dtoScope(String rel) {
  if (rel.startsWith('core/')) return true;
  final parts = rel.split('/');
  return parts.length >= 4 && parts[0] == 'features' && parts[2] == 'data';
}

const _rawPrefs = {
  'core/storage/preference_store.dart',
  'core/storage/shared_preference_store.dart',
};

/// A5 kapsamı: S5/S6/S7 kesin dosya listesindeki bağdaştırıcılar (`app/di` hariç).
const _adapters = {
  ..._rawPrefs,
  'core/preferences/app_preferences.dart',
  'core/telemetry/telemetry.dart',
};

/// `dynamic`, `Object`/`Object?` veya işlev tipi (iç içe dahil) varsa açıklaması.
String? _erased(DartType t, [Set<DartType>? seen]) {
  seen ??= {};
  if (!seen.add(t)) return null;
  if (t is DynamicType) return 'dynamic';
  if (t is InvalidType) return 'çözümlenemeyen tip';
  if (t is FunctionType) return 'işlev tipi (geri çağrı)';
  if (t is InterfaceType) {
    if (t.isDartCoreObject) return 'Object';
    if (t.isDartCoreFunction) return 'Function';
    for (final a in t.typeArguments) {
      if (_erased(a, seen) case final e?) return e;
    }
  }
  if (t is RecordType) {
    for (final f in [...t.positionalFields, ...t.namedFields]) {
      if (_erased(f.type, seen) case final e?) return e;
    }
  }
  return null;
}

/// A4 muafları: ham port/SDK tipini açık API'de taşıyabilecek tek yerler.
bool _sensitiveAllowed(String rel) =>
    _rawPrefs.contains(rel) || rel.startsWith('app/di/');

bool _isSensitive(Element element) {
  final uri = element.library?.uri.toString() ?? '';
  return uri.startsWith('package:shared_preferences/') ||
      uri.startsWith('package:firebase_') ||
      _rawPrefs.any((r) => uri == 'package:$packageName/$r');
}

/// `flutter test` altında çalıştırılabilir dart değil flutter_tester'dır; SDK yolu
/// FLUTTER_ROOT'tan, yoksa `dart` çalıştırılabilirinin konumundan bulunur.
String? _sdkPath() {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    final sdk = p.join(flutterRoot, 'bin', 'cache', 'dart-sdk');
    if (Directory(sdk).existsSync()) return sdk;
  }
  final exe = Platform.resolvedExecutable;
  if (p.basenameWithoutExtension(exe) == 'dart') {
    return p.dirname(p.dirname(exe));
  }
  return null;
}

int _line(ResolvedLibraryResult result, Element element) {
  final fragment = element.firstFragment;
  final offset = fragment.nameOffset ?? fragment.offset;
  for (final unit in result.units) {
    if (unit.path == fragment.libraryFragment?.source.fullName) {
      return unit.lineInfo.getLocation(offset).lineNumber;
    }
  }
  return 1;
}

/// Kütüphanenin açık yüzeyindeki (element, açıklama, tip) üçlüleri.
Iterable<(Element, String, DartType)> _publicSurface(
  LibraryElement library,
) sync* {
  Iterable<(Element, String, DartType)> typeParams(
    Element owner,
    String name,
    List<TypeParameterElement> params,
  ) sync* {
    for (final tp in params) {
      if (tp.bound case final b?) yield (owner, '$name<${tp.name}>', b);
    }
  }

  final interfaces = <InterfaceElement>[
    ...library.classes,
    ...library.enums,
    ...library.mixins,
    ...library.extensionTypes,
  ];
  for (final e in interfaces) {
    if (!e.isPublic) continue;
    final name = e.name ?? '?';
    yield* typeParams(e, name, e.typeParameters);
    for (final s in e.allSupertypes) {
      yield (e, '$name üst tipi', s);
    }
    if (e is ExtensionTypeElement) {
      yield (e, '$name temsil tipi', e.representation.type);
    }
    for (final c in e.constructors) {
      if (!c.isPublic) continue;
      final ctor = c.name == null || c.name == 'new' ? name : '$name.${c.name}';
      yield (c, '$ctor() yapıcısı', c.type);
    }
    // Kalıtılanlar dahil arayüz üyeleri (özel adlar Name'de kütüphaneye bağlıdır).
    for (final m in e.interfaceMembers.values) {
      if (!m.isPublic) continue;
      yield (m, '$name.${m.displayName}', m.type);
    }
    for (final f in e.fields) {
      if (f.isPublic && f.isStatic) yield (f, '$name.${f.displayName}', f.type);
    }
    for (final m in [...e.methods, ...e.getters, ...e.setters]) {
      if (m.isPublic && m.isStatic) yield (m, '$name.${m.displayName}', m.type);
    }
  }
  for (final e in library.extensions) {
    if (!e.isPublic) continue; // adsız extension kütüphaneye özeldir
    final name = e.name ?? '?';
    yield (e, '$name genişletilen tip', e.extendedType);
    yield* typeParams(e, name, e.typeParameters);
    for (final m in [...e.methods, ...e.getters, ...e.setters]) {
      if (m.isPublic) yield (m, '$name.${m.displayName}', m.type);
    }
    for (final f in e.fields) {
      if (f.isPublic) yield (f, '$name.${f.displayName}', f.type);
    }
  }
  for (final e in library.typeAliases) {
    if (!e.isPublic) continue;
    yield* typeParams(e, e.name ?? '?', e.typeParameters);
    yield (e, 'typedef ${e.name}', e.aliasedType);
  }
  for (final e in library.topLevelFunctions) {
    if (e.isPublic) yield (e, '${e.name}()', e.type);
  }
  for (final e in library.topLevelVariables) {
    if (e.isPublic) yield (e, e.displayName, e.type);
  }
  for (final e in [...library.getters, ...library.setters]) {
    if (e.isPublic) yield (e, e.displayName, e.type);
  }
}

/// [type] içinde [match]'e uyan bir tip/typedef varsa adı, yoksa null.
String? _typeIn(
  DartType type,
  bool Function(Element) match,
  Set<DartType> seen,
) {
  if (!seen.add(type)) return null;
  if (type.alias case final alias?) {
    if (match(alias.element)) return alias.element.name;
    for (final a in alias.typeArguments) {
      if (_typeIn(a, match, seen) case final n?) return n;
    }
  }
  switch (type) {
    case InterfaceType():
      if (match(type.element)) return type.element.name;
      for (final a in type.typeArguments) {
        if (_typeIn(a, match, seen) case final n?) return n;
      }
    case FunctionType():
      if (_typeIn(type.returnType, match, seen) case final n?) return n;
      for (final f in type.formalParameters) {
        if (_typeIn(f.type, match, seen) case final n?) return n;
      }
      for (final tp in type.typeParameters) {
        if (tp.bound case final b?) {
          if (_typeIn(b, match, seen) case final n?) return n;
        }
      }
    case RecordType():
      for (final f in [...type.positionalFields, ...type.namedFields]) {
        if (_typeIn(f.type, match, seen) case final n?) return n;
      }
    default:
  }
  return null;
}

bool _isGenerated(Element element) =>
    element.library?.uri.toString().startsWith(_generatedUri) ?? false;
