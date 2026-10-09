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
          .where(_inScope)
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
    final rule = rel.startsWith('core/') ? 'A3' : 'A2';
    final reported =
        <String>{}; // alanın getter/setter'ı, değişken + getter tekrarı
    for (final (element, what, type) in _publicSurface(result.element)) {
      final leaked = _generatedIn(type, <DartType>{});
      if (leaked == null || !reported.add(what)) continue;
      out.add(
        Violation(
          rule,
          'lib/$rel',
          _line(result, element),
          'açık API üretilmiş tip taşıyor: $what → $leaked '
              '(domain varlığı döndürün; DTO yalnız gövdede/özel bildirimde)',
        ),
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

/// Kapsam dosya sonekine göre DARALTILMAZ (`.g.dart` kökü ile kaçış yok, CX-a-Ö-04);
/// yalnız üretilmiş API dizini muaftır.
bool _inScope(String rel) {
  if (!rel.endsWith('.dart')) return false;
  if (rel.startsWith(generatedApiDir)) return false;
  if (rel.startsWith('core/')) return true;
  final parts = rel.split('/');
  return parts.length >= 4 && parts[0] == 'features' && parts[2] == 'data';
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

/// [type] içinde üretilmiş kodda tanımlı bir tip/typedef varsa adı, yoksa null.
String? _generatedIn(DartType type, Set<DartType> seen) {
  if (!seen.add(type)) return null;
  if (type.alias case final alias?) {
    if (_isGenerated(alias.element)) return alias.element.name;
    for (final a in alias.typeArguments) {
      if (_generatedIn(a, seen) case final n?) return n;
    }
  }
  switch (type) {
    case InterfaceType():
      if (_isGenerated(type.element)) return type.element.name;
      for (final a in type.typeArguments) {
        if (_generatedIn(a, seen) case final n?) return n;
      }
    case FunctionType():
      if (_generatedIn(type.returnType, seen) case final n?) return n;
      for (final f in type.formalParameters) {
        if (_generatedIn(f.type, seen) case final n?) return n;
      }
      for (final tp in type.typeParameters) {
        if (tp.bound case final b?) {
          if (_generatedIn(b, seen) case final n?) return n;
        }
      }
    case RecordType():
      for (final f in [...type.positionalFields, ...type.namedFields]) {
        if (_generatedIn(f.type, seen) case final n?) return n;
      }
    default:
  }
  return null;
}

bool _isGenerated(Element element) =>
    element.library?.uri.toString().startsWith(_generatedUri) ?? false;
