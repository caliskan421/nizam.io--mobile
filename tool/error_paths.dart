// Hata yolu kapsam kapısı. Kullanım: `dart run tool/check_error_paths.dart` (make boundaries).
//
// lib/ altındaki el yazımı her Dart dosyasında, beklenmeyen hatayı YUTAN ya da başka bir
// hataya ÇEVİREN sözdizimsel yolları bulur ve her biri için şunlardan birini ister:
//   - hata, `catch` GİRİŞİNDE koşulsuz olarak rapor cephesine (aşağıdaki [facadeErrorArg] ya da
//     aynı dosyada onu doğru parametreden çağıran yerel yardımcıya) YAKALANAN HATA DEĞİŞKENİYLE
//     HATA konumunda verilir; ya da
//   - hata olduğu gibi, girişte koşulsuz yeniden fırlatılır (`rethrow`, `throw e`,
//     `Error.throwWithStackTrace(e …)`); ya da
//   - yakalanan tür, aynı dosyada `implements ExpectedFailure` taşıyan bir sınıftır
//     (beklenen alan sonucu işareti; tür adına/`_` önekine güvenilmez); ya da
//   - yol [errorPathExceptions] listesinde GERÇEK gerekçeyle (dosya + fonksiyon + tür) durur.
//
// `on ApiError` KAYNAĞINDA raporlanmış sayılmaz (tür adına güvenilmez): ApiError da girişte
// politika yardımcısından geçer (beklenen kod 0 rapor, tekrar tek rapor).
//
// Kapsanan yollar (tür): catch, onError, catchError, handleError, AsyncValue.guard,
// AsyncError/AsyncValue.error kurma, ham Dio isteği; ayrıca `apiCall` takma adı ve sahte rapor
// cephesi bildirimi (E6) yasaktır. Tip çözümlemesi YOKTUR (yalnız ayrıştırma); çözümleme
// kuralları ve sınırları tool/error_path_flow.dart'tadır, atlatma biçimleri
// `test/tool/error_paths_test.dart` negatif fixture'larında kanıtlıdır.
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'boundaries.dart' show Violation;
import 'error_path_exceptions.dart';
import 'error_path_flow.dart';

/// Envanter satırı: bir hata yolunun (dosya + işlev + tür) sahibi. Satır numarası YOKTUR.
/// Sahip: `rapor`, `iletilir`, `denetim akışı` ya da `istisna`.
class ErrorPathEntry {
  const ErrorPathEntry(this.path, this.enclosing, this.kind, this.owner);
  final String path;
  final String enclosing;
  final String kind;
  final String owner;
}

/// Rapor altyapısının kendisi: raporlayıcı kendi hatasını raporlayamaz (döngü).
bool _isTelemetry(String libPath) =>
    libPath.startsWith('core/telemetry/') ||
    libPath.startsWith('app/telemetry/');

bool _isGenerated(String libPath) =>
    libPath.startsWith('core/api/generated/') ||
    libPath.startsWith('core/i18n/generated/') ||
    libPath.endsWith('.g.dart') ||
    libPath.endsWith('.freezed.dart') ||
    libPath.endsWith('.gen.dart');

const _rawDioMethods = {
  'get',
  'post',
  'put',
  'patch',
  'delete',
  'head',
  'request',
  'download',
  'fetch',
  'getUri',
  'postUri',
};

/// [libPath]: `lib/` göreli yol. [exceptions]: testte sentetik liste verilebilir.
/// Dönüş: ihlaller (yetkili listede karşılığı olmayan her yol bir ihlaldir) ve kullanılan
/// istisna anahtarlarının sayımı ([usage]).
List<Violation> checkErrorPaths(
  String libPath,
  String content, {
  Map<String, ErrorPathException>? exceptions,
  Map<String, int>? usage,
  List<ErrorPathEntry>? inventory,
}) {
  if (_isGenerated(libPath) || _isTelemetry(libPath)) return const [];
  final table = exceptions ?? errorPathExceptions;
  final unit = parseString(
    content: content,
    path: '/lib/$libPath',
    throwIfDiagnostics: false,
  ).unit;
  final flow = FlowContext(libPath, unit);
  final v = _Visitor(libPath, unit, flow, table, usage ?? {}, inventory);
  unit.accept(v);
  for (final spoof in flow.spoofs) {
    v.out.add(
      Violation(
        'E6',
        'lib/$libPath',
        unit.lineInfo.getLocation(spoof.node.offset).lineNumber,
        '${spoof.name}: rapor cephesi adı yerel olarak yeniden bildiriliyor (gölgeleme/sahte cephe)',
      ),
    );
  }
  return v.out;
}

class _Visitor extends RecursiveAstVisitor<void> {
  _Visitor(
    this.libPath,
    this.unit,
    this.flow,
    this.table,
    this.usage,
    this.inventory,
  );

  final String libPath;
  final CompilationUnit unit;
  final FlowContext flow;
  final Map<String, ErrorPathException> table;
  final Map<String, int> usage;
  final List<ErrorPathEntry>? inventory;
  final out = <Violation>[];
  final _scope = <String>[];

  String get _enclosing => _scope.isEmpty ? '<top>' : _scope.join('.');

  void _note(String kind, String owner) =>
      inventory?.add(ErrorPathEntry(libPath, _enclosing, kind, owner));

  void _flag(String rule, AstNode node, String kind, String message) {
    final key = '$libPath::$_enclosing#$kind';
    final allowed = table[key];
    if (allowed != null) {
      final n = usage[key] = (usage[key] ?? 0) + 1;
      if (n <= allowed.max) {
        _note(kind, 'istisna');
        return;
      }
      out.add(
        Violation(
          rule,
          'lib/$libPath',
          unit.lineInfo.getLocation(node.offset).lineNumber,
          '$message — istisna sınırı aşıldı ($key en çok ${allowed.max})',
        ),
      );
      return;
    }
    out.add(
      Violation(
        rule,
        'lib/$libPath',
        unit.lineInfo.getLocation(node.offset).lineNumber,
        '$message (anahtar: $key)',
      ),
    );
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _scope.add(node.namePart.typeName.lexeme);
    super.visitClassDeclaration(node);
    _scope.removeLast();
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    _scope.add(node.name?.lexeme ?? '<ext>');
    super.visitExtensionDeclaration(node);
    _scope.removeLast();
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    _scope.add(node.name.lexeme);
    super.visitMixinDeclaration(node);
    _scope.removeLast();
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    // Yalnız üst düzey işlevler kapsam adıdır; iç içe işlevler dıştakine aittir.
    final top = node.parent is CompilationUnit;
    if (top) _scope.add(node.name.lexeme);
    super.visitFunctionDeclaration(node);
    if (top) _scope.removeLast();
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    _scope.add(node.name.lexeme);
    super.visitMethodDeclaration(node);
    _scope.removeLast();
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    _scope.add(node.name?.lexeme ?? '<new>');
    super.visitConstructorDeclaration(node);
    _scope.removeLast();
  }

  /// Yakalanan tür, aynı dosyada `implements ExpectedFailure` taşıyan sınıf mı. Tür adına ya da
  /// `_` önekine güvenilmez: açık işaret şarttır.
  bool _isExpectedMarker(TypeAnnotation? type) {
    if (type is! NamedType) return false;
    final name = type.name.lexeme;
    return unit.declarations.any(
      (d) =>
          d is ClassDeclaration &&
          d.namePart.typeName.lexeme == name &&
          (d.implementsClause?.interfaces.any(
                (i) => i.name.lexeme == 'ExpectedFailure',
              ) ??
              false),
    );
  }

  @override
  void visitCatchClause(CatchClause node) {
    final errVar = node.exceptionParameter?.name.lexeme;
    final owner = _isExpectedMarker(node.exceptionType)
        ? 'denetim akışı'
        : flow.ownerOf(node.body.statements, errVar);
    if (owner != null) {
      _note('catch', owner);
    } else {
      _flag(
        'E1',
        node,
        'catch',
        'catch hatayı girişte koşulsuz raporlamıyor/yeniden fırlatmıyor '
            '(reportUnexpected / toReportedApiError ile yakalanan değişkeni HATA konumunda, '
            'önceki return/if-çıkışı olmadan verin; ApiError dahil)',
      );
    }
    super.visitCatchClause(node);
  }

  /// Geri çağrılı yutma yolu: [e] FunctionExpression ise gövdesi birinci parametreyi girişte
  /// cepheye vermeli; yardımcı adı (tear-off) ise yardımcı birinci parametreyi cepheye aktarmalı.
  bool _handlerReports(Expression? e) {
    if (e is FunctionExpression) return flow.callbackReports(e);
    if (e is SimpleIdentifier) {
      return flow.helperKeys(e.name)?.contains(0) ?? false;
    }
    return false;
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final name = node.methodName.name;
    final args = node.argumentList.arguments;
    final target = node.target;
    // Çözümlemesiz ayrıştırmada `AsyncError(…)` / `AsyncValue.error(…)` çağrı görünür.
    if ((name == 'AsyncError' && target == null) ||
        (name == 'error' &&
            target is SimpleIdentifier &&
            target.name == 'AsyncValue')) {
      _flag('E2', node, 'asyncError', 'AsyncError doğrudan kuruluyor');
    }
    // E5: client.invalid_response üretimi ham `ApiError(...)` ile yapılıyorsa rapor atlanır;
    // `invalidResponseError()` (raporlu) kullanılmalı ya da yol gerekçeli istisna olmalı.
    if (name == 'ApiError' && target == null && args.isNotEmpty) {
      final first = args.first.argumentExpression;
      final isInvalid =
          (first is PrefixedIdentifier &&
              first.prefix.name == 'ClientErrorCode' &&
              first.identifier.name == 'invalidResponse') ||
          (first is SimpleStringLiteral &&
              first.value == 'client.invalid_response');
      if (isInvalid) {
        _flag(
          'E5',
          node,
          'invalidResponse',
          'client.invalid_response ham ApiError ile kuruluyor (invalidResponseError() kullanın)',
        );
      }
    }
    switch (name) {
      case 'catchError':
      case 'handleError':
        if (args.isEmpty || !_handlerReports(args.first.argumentExpression)) {
          _flag('E2', node, name, '$name hatayı raporlamadan yutuyor');
        } else {
          _note(name, 'rapor');
        }
      case 'guard':
        final t = node.target;
        if (t is SimpleIdentifier && t.name == 'AsyncValue') {
          final cb = args.isEmpty ? null : args.first.argumentExpression;
          if (cb == null || !_guardReports(cb)) {
            _flag(
              'E2',
              node,
              'guard',
              'AsyncValue.guard hatayı AsyncError durumuna çeviriyor (raporlanmıyor)',
            );
          } else {
            _note('guard', 'rapor');
          }
        }
    }
    if (_rawDioMethods.contains(name) && !libPath.startsWith('core/http/')) {
      final t = node.target?.toSource() ?? '';
      if (RegExp(r'(^|\.)_?(dio|http)$', caseSensitive: false).hasMatch(t)) {
        _flag(
          'E3',
          node,
          'rawDio',
          'ham Dio isteği apiCall kapsamı dışında (operationId bağlamı yok)',
        );
      }
    }
    super.visitMethodInvocation(node);
  }

  /// `AsyncValue.guard` geri çağrısının TÜM gövdesi tek bir `try` ise ve her `catch` kolu hatayı
  /// girişte raporluyor (ya da beklenen-alan işaretli) ve hepsini yakalayan bir `catch` raporluyorsa
  /// kapalı sayılır. Kapanış içinde yan yana duran rapor çağrısı sahiplik DEĞİLDİR.
  bool _guardReports(Expression cb) {
    if (cb is! FunctionExpression) return false;
    final body = cb.body;
    if (body is! BlockFunctionBody) return false;
    final stmts = body.block.statements;
    if (stmts.length != 1) return false;
    final t = stmts.single;
    if (t is! TryStatement) return false;
    // `finally` bloğu rapor sahipliğini denetlenemez kılar (yeni raporsuz hata üretebilir):
    // konservatif red.
    if (t.finallyBlock != null) return false;
    var catchAll = false;
    for (final c in t.catchClauses) {
      final owner = _isExpectedMarker(c.exceptionType)
          ? 'denetim akışı'
          : flow.ownerOf(c.body.statements, c.exceptionParameter?.name.lexeme);
      if (owner != 'rapor' && owner != 'denetim akışı') return false;
      final type = c.exceptionType;
      final all =
          type == null ||
          (type is NamedType &&
              (type.name.lexeme == 'Object' || type.name.lexeme == 'dynamic') &&
              !flow.declared.any((d) => d.name == type.name.lexeme));
      if (owner == 'rapor' && all) catchAll = true;
    }
    return catchAll;
  }

  /// `onError:` / `handleError:` adlı geri çağrılar (listen, then, fromHandlers, kendi
  /// API'miz …) hangi çağrıda olursa olsun: gövde parametreyi girişte cepheye vermeli.
  @override
  void visitArgumentList(ArgumentList node) {
    for (final a in node.arguments) {
      if (a is! NamedArgument) continue;
      final n = a.name.lexeme;
      if (n != 'onError' && n != 'handleError') continue;
      // Yalnız geri çağrı değerleri (kapanış ya da ad); `onError: c.onDanger` gibi alan/renk
      // değerleri geri çağrı değildir.
      final e = a.argumentExpression;
      if (e is! FunctionExpression && e is! SimpleIdentifier) continue;
      if (_handlerReports(e)) {
        _note(n, 'rapor');
      } else {
        _flag('E2', a, n, '$n: geri çağrısı hatayı raporlamadan yutuyor');
      }
    }
    super.visitArgumentList(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final t = node.constructorName.type.name.lexeme;
    final named = node.constructorName.name?.name;
    if (t == 'AsyncError' || (t == 'AsyncValue' && named == 'error')) {
      _flag('E2', node, 'asyncError', 'AsyncError doğrudan kuruluyor');
    }
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    // `apiCall` yalnız doğrudan çağrılır: takma ad/işlev değeri olarak geçirilirse işlem
    // bağlamı (ApiCallScope) ve çağrı yolu denetlenemez.
    if (node.name == 'apiCall') {
      final p = node.parent;
      final isCall = p is MethodInvocation && identical(p.methodName, node);
      if (!isCall &&
          p is! Combinator &&
          node.thisOrAncestorOfType<CommentReference>() == null) {
        _flag(
          'E4',
          node,
          'apiCallAlias',
          'apiCall doğrudan çağrılmıyor (takma ad)',
        );
      }
    }
    super.visitSimpleIdentifier(node);
  }
}
