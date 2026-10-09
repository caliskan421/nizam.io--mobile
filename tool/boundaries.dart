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
//   D2  features/** içinde `dart:convert` importu ve `Map<String, …>` tip açıklaması yasak
//       (elle JSON gövdesi kurmanın iki kaçış yolu).
//   S1  flutter_secure_storage yalnız `lib/core/storage/**` içinde.
//   S2  `badCertificateCallback`, `HttpOverrides` hiçbir yerde (TLS hatası yutulmaz).
//   S3  `debugPrint` ve `dart:developer` yalnız `lib/core/logging/**` içinde (log tek yoldan
//       ve redaksiyonla; `print` ayrıca avoid_print ile yasak).
//   S4  domain katmanı Flutter/dio/Riverpod import etmez (saf Dart).
//   G1  `package:get_it` yalnız `lib/app/**` ve `features/<f>/<f>_module.dart` içinde
//       (ADR-0001, D-0182: get_it = bileşim kökü; core ve feature katmanları servis bulucu
//       kullanmaz, bağımlılık yapıcıdan gelir).
//   G2  `features/<f>/<f>_module.dart` (modül kayıt fonksiyonu) yalnız `lib/app/di/**`
//       tarafından import edilir.
//   A1  Üretilmiş API kodu (`lib/core/api/generated/**`: DTO'lar, enum'lar, istemciler)
//       features içinde yalnız `data` katmanında ve `<f>_module.dart`'ta (istemci kurulumu)
//       import edilir. data DTO'yu domain varlığına eşler; presentation/application/domain
//       ve açık yüz sözleşme tiplerini görmez (backend alan değişikliği UI'a sızmaz).
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

/// Paket adı (pubspec `name`).
const packageName = 'nizamio';

/// Üretilmiş API kodu (DTO yalnız burada).
const generatedApiDir = 'core/api/generated/';

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
List<Violation> checkSource(String libPath, String content) {
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

  final generated = libPath.startsWith(generatedApiDir);

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
    if (directive is! NamespaceDirective) continue;
    final uri = directive.uri.stringValue;
    if (uri == null) continue;
    _checkUri(here, uri, (rule, msg) => add(rule, directive, msg), generated);
  }

  unit.accept(_Visitor(here, generated, add));
  return out;
}

void _checkUri(
  _Place here,
  String uri,
  void Function(String rule, String msg) add,
  bool generated,
) {
  String? target; // lib göreli hedef
  if (uri.startsWith('package:$packageName/')) {
    target = uri.substring('package:$packageName/'.length);
  } else if (!uri.contains(':')) {
    target = p.posix.normalize(p.posix.join(p.posix.dirname(here.path), uri));
    if (target.startsWith('..')) target = null;
  }

  // Paket kuralları.
  if (uri.startsWith('package:flutter_secure_storage/') &&
      !here.path.startsWith('core/storage/')) {
    add(
      'S1',
      'flutter_secure_storage yalnız lib/core/storage/ içinde import edilir',
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
  if (here.area == 'feature' && here.layer == 'domain') {
    for (final banned in const [
      'package:flutter/',
      'package:dio/',
      'package:flutter_riverpod/',
      'package:riverpod',
    ]) {
      if (uri.startsWith(banned)) {
        add('S4', 'domain katmanı saf Dart olmalı: $uri');
      }
    }
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
  if (here.area == 'feature' &&
      target.startsWith(generatedApiDir) &&
      here.layer != 'data' &&
      here.layer != 'module') {
    add(
      'A1',
      'üretilmiş API kodu features içinde yalnız data katmanında ve <f>_module.dart\'ta: $uri (domain varlığına eşleyin)',
    );
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
  _Visitor(this.here, this.generated, this.add);

  final _Place here;
  final bool generated;
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

  @override
  void visitNamedType(NamedType node) {
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
