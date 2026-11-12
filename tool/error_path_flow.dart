// Hata yolu kapısının akış/çözümleme yardımcıları (tool/error_paths.dart kullanır).
//
// Tip çözümlemesi YOKTUR; ama ad üzerinden çalışan eski kapının üç açığı kapatılır:
//   1. SAHTE rapor cephesi: dosyada `reportUnexpected` vb. adıyla yerel işlev/değişken/parametre
//      bildirmek (gölgeleme) ya da cepheyi `başka.reportUnexpected(...)` biçiminde çağırmak
//      cephe sayılmaz. Güvenilir çağrı: bildirimsiz çıplak ad, güvenilir `import … as p` önekiyle
//      `p.ad` ya da dosya düzeyi `final takma = cephe;` takma adı.
//   2. YANLIŞ HATA: cepheye yakalanan değişken, cephenin HATA bağımsız değişken konumunda
//      (`reportUnexpected` ilk konumsal, `invalidResponseError` `cause:`) verilmelidir; başka
//      adlandırılmış bağımsız değişkende geçmek yetmez. Yardımcı yalnız hatayı kendi parametresinden
//      cepheye aktarıyorsa sayılır.
//   3. KOŞULLU/ERİŞİLEMEZ yol: rapor ya da iletme `catch` GİRİŞİNDE koşulsuz çalışmalıdır: önceki
//      hiçbir deyim çıkamaz (return/throw/rethrow/break/continue), rapor `if`/`?:`/`&&`/`||`/`??`/
//      kapanış/döngü/anahtar içinde değildir. Bu tek yol-kanıtıdır; genel akış çözümlemesi değildir.
//      Karmaşık bilinçli yollar tool/error_path_exceptions.dart'ta dar gerekçeyle durur.
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

/// Rapor cephesi işlevleri ve HATA bağımsız değişken konumu: konumsal indeks ya da adlandırılmış ad.
const facadeErrorArg = <String, Object>{
  'reportUnexpected': 0,
  'toReportedApiError': 0,
  'reportApiFailure': 0,
  'streamApiError': 0,
  'invalidResponseError': 'cause',
  'ErrorReporting.report': 0,
};

/// Cephenin tanımlandığı (gölgeleme denetiminden muaf) tek dosya.
const facadeHome = <String, String>{
  'reportUnexpected': 'core/telemetry/unexpected_error.dart',
  'toReportedApiError': 'core/telemetry/unexpected_error.dart',
  'reportApiFailure': 'core/errors/api_error.dart',
  'invalidResponseError': 'core/errors/api_error.dart',
  'streamApiError': 'core/http/sse.dart',
};

/// Güvenilir kütüphaneler: `lib/` göreli TAM yol. İçe aktarma `package:nizamio/…` tam yolu ya da
/// normalleştirilmiş gerçek depo-göreli hedefle bu kümeye düşmeli; sonek eşleşmesi yetmez.
const _trustedLibs = {
  'core/telemetry/unexpected_error.dart',
  'core/errors/api_error.dart',
  'core/http/sse.dart',
  'core/telemetry/error_reporting.dart',
};

/// [uri] (dosya [libPath]'ten) güvenilir bir kütüphaneye çözülüyor mu.
bool _isTrustedImport(String libPath, String uri) {
  final String target;
  if (uri.startsWith('package:nizamio/')) {
    target = Uri.parse(uri).path.substring('nizamio/'.length);
  } else if (uri.contains(':')) {
    return false; // başka paket / dart: / sahte şema
  } else {
    final resolved = Uri(path: '/lib/$libPath').resolve(uri).path;
    if (!resolved.startsWith('/lib/')) return false;
    target = resolved.substring('/lib/'.length);
  }
  return _trustedLibs.contains(target);
}

/// Bir bildirim: ad + düğüm (E6 satırı için).
typedef Declared = ({String name, AstNode node});

class FlowContext {
  FlowContext(this.libPath, CompilationUnit unit) {
    final v = _DeclVisitor(declared);
    unit.accept(v);
    for (final d in unit.directives.whereType<ImportDirective>()) {
      final uri = d.uri.stringValue ?? '';
      final prefix = d.prefix?.name;
      // Önek dosyada başka bir bildirimle (parametre/yerel/işlev) gölgelenmişse güvenilmez.
      if (prefix != null &&
          _isTrustedImport(libPath, uri) &&
          !declared.any((x) => x.name == prefix)) {
        prefixes.add(prefix);
      }
    }
    // Dosya düzeyi `final takma = cephe;` takma adları (tek bildirim, değişmez).
    for (final decl
        in unit.declarations.whereType<TopLevelVariableDeclaration>()) {
      final list = decl.variables;
      if (!(list.isFinal || list.isConst)) continue;
      for (final variable in list.variables) {
        final init = variable.initializer;
        final target = init is SimpleIdentifier
            ? init.name
            : init is PrefixedIdentifier && prefixes.contains(init.prefix.name)
            ? init.identifier.name
            : null;
        if (target != null &&
            facadeErrorArg.containsKey(target) &&
            _trustedName(target)) {
          final name = variable.name.lexeme;
          if (declared.where((d) => d.name == name).length == 1) {
            aliases[name] = target;
          }
        }
      }
    }
    _collectHelpers(unit);
  }

  final String libPath;
  final declared = <Declared>[];
  final prefixes = <String>{};
  final aliases = <String, String>{};

  /// Yardımcı ad → hatayı koşulsuz cepheye aktaran parametreler (konumsal indeks ya da ad).
  final helpers = <String, Set<Object>>{};

  bool _trustedName(String name) {
    if (name == 'ErrorReporting.report') {
      return !declared.any((d) => d.name == 'ErrorReporting');
    }
    return facadeHome[name] == libPath || !declared.any((d) => d.name == name);
  }

  /// Cephe adını çözer: `reportUnexpected(…)`, `p.reportUnexpected(…)`, takma ad ya da
  /// `ErrorReporting.report(…)`; değilse null.
  String? facadeOf(MethodInvocation m) {
    final name = m.methodName.name;
    final t = m.target;
    if (t == null) {
      if (aliases.containsKey(name)) return aliases[name];
      if (facadeErrorArg.containsKey(name) &&
          !name.contains('.') &&
          _trustedName(name)) {
        return name;
      }
      return null;
    }
    if (t is SimpleIdentifier &&
        prefixes.contains(t.name) &&
        facadeErrorArg.containsKey(name)) {
      return name;
    }
    if (name == 'report' && _trustedName('ErrorReporting.report')) {
      if (t is SimpleIdentifier && t.name == 'ErrorReporting') {
        return 'ErrorReporting.report';
      }
      if (t is PrefixedIdentifier &&
          prefixes.contains(t.prefix.name) &&
          t.identifier.name == 'ErrorReporting') {
        return 'ErrorReporting.report';
      }
    }
    return null;
  }

  /// Bildirilmiş cephe adları (home dışında): sahte cephe kanıtı (E6).
  Iterable<Declared> get spoofs => declared.where((d) {
    if (aliases.containsKey(d.name)) return false;
    return facadeErrorArg.containsKey(d.name) &&
        !d.name.contains('.') &&
        facadeHome[d.name] != libPath;
  });

  // ---- hata bağımsız değişkeni ------------------------------------------------------

  /// İfade yakalanan [v] hatasını aynen taşıyor mu: `v`, `(v)`, `v as T`; tek özel şekil
  /// `v.error ?? v` (sol işlenen `v.error`). Genel `başka ?? v` taşıyıcı DEĞİLDİR.
  static bool isErrorArg(Expression? e, String v) {
    if (e == null) return false;
    if (e is ParenthesizedExpression) return isErrorArg(e.expression, v);
    if (e is AsExpression) return isErrorArg(e.expression, v);
    if (e is SimpleIdentifier) return e.name == v;
    if (e is BinaryExpression &&
        e.operator.type == TokenType.QUESTION_QUESTION) {
      return _isErrorField(e.leftOperand, v) && isErrorArg(e.rightOperand, v);
    }
    return false;
  }

  static bool _isErrorField(Expression e, String v) {
    if (e is PrefixedIdentifier) {
      return e.prefix.name == v && e.identifier.name == 'error';
    }
    if (e is PropertyAccess) {
      final t = e.target;
      return !e.isNullAware &&
          t is SimpleIdentifier &&
          t.name == v &&
          e.propertyName.name == 'error';
    }
    return false;
  }

  /// İfade yan etkisiz ve fırlatamaz sayılır mı: yalnız ad/sabit değer/üye okuma biçimleri.
  /// Çağrı, `throw`, `await`, atama, kademe ve const olmayan kurucu YAN ETKİLİDİR.
  static bool isPure(AstNode? e) {
    switch (e) {
      case null:
        return true;
      case NamedArgument():
        return isPure(e.argumentExpression);
      case ParenthesizedExpression():
        return isPure(e.expression);
      case AsExpression():
        return isPure(e.expression);
      case SimpleIdentifier() ||
          PrefixedIdentifier() ||
          ThisExpression() ||
          SimpleStringLiteral() ||
          BooleanLiteral() ||
          IntegerLiteral() ||
          DoubleLiteral() ||
          NullLiteral():
        return true;
      case PropertyAccess():
        return isPure(e.target);
      case BinaryExpression()
          when e.operator.type == TokenType.QUESTION_QUESTION:
        return isPure(e.leftOperand) && isPure(e.rightOperand);
      case StringInterpolation():
        return e.elements.whereType<InterpolationExpression>().every(
          (x) => isPure(x.expression),
        );
      case InstanceCreationExpression() when e.isConst:
        return e.argumentList.arguments.every(isPure);
      default:
        return false;
    }
  }

  static bool _argsPure(ArgumentList list) => list.arguments.every(isPure);

  Expression? _argAt(ArgumentList list, Object key) {
    if (key is int) {
      var i = 0;
      for (final a in list.arguments) {
        if (a is NamedArgument) continue;
        if (i == key) return a.argumentExpression;
        i++;
      }
      return null;
    }
    for (final a in list.arguments) {
      if (a is NamedArgument && a.name.lexeme == key) {
        return a.argumentExpression;
      }
    }
    return null;
  }

  /// [n] çağrısı [v] hatasını cepheye (ya da hatayı cepheye aktaran yardımcıya) verir mi.
  bool reportsCall(AstNode n, String v) {
    // Bütün bağımsız değişkenler yan etkisiz olmalı: başka bir bağımsız değişken fırlatırsa
    // çağrı hiç çalışmaz (rapor yok).
    if (n is MethodInvocation) {
      final facade = facadeOf(n);
      if (facade != null) {
        return _argsPure(n.argumentList) &&
            isErrorArg(_argAt(n.argumentList, facadeErrorArg[facade]!), v);
      }
      final t = n.target;
      if (t == null || t is ThisExpression) {
        final keys = helperKeys(n.methodName.name);
        if (keys != null) {
          return _argsPure(n.argumentList) &&
              keys.any((k) => isErrorArg(_argAt(n.argumentList, k), v));
        }
      }
    }
    if (n is FunctionExpressionInvocation) {
      final f = n.function;
      if (f is SimpleIdentifier && aliases.containsKey(f.name)) {
        return _argsPure(n.argumentList) &&
            isErrorArg(
              _argAt(n.argumentList, facadeErrorArg[aliases[f.name]!]!),
              v,
            );
      }
    }
    return false;
  }

  /// Yardımcı adının güvenilir anahtarları; aynı ad dosyada işlev dışı bir bildirimle
  /// (parametre/yerel/alan) de bildirilmişse çağrının hangi bildirime gittiği bilinemez → null.
  Set<Object>? helperKeys(String name) {
    final shadowed = declared.any(
      (d) =>
          d.name == name &&
          d.node is! FunctionDeclaration &&
          d.node is! MethodDeclaration,
    );
    return shadowed ? null : helpers[name];
  }

  /// [n] hatayı AYNEN iletiyor mu: `rethrow`, `throw v`, `Error.throwWithStackTrace(v, …)`.
  bool propagates(AstNode n, String? v) {
    if (n is RethrowExpression) return true;
    if (v == null) return false;
    if (n is ThrowExpression) return isErrorArg(n.expression, v);
    if (n is MethodInvocation &&
        n.methodName.name == 'throwWithStackTrace' &&
        n.target is SimpleIdentifier &&
        (n.target! as SimpleIdentifier).name == 'Error' &&
        !declared.any((d) => d.name == 'Error')) {
      return _argsPure(n.argumentList) &&
          isErrorArg(_argAt(n.argumentList, 0), v);
    }
    return false;
  }

  // ---- koşulsuz erişim --------------------------------------------------------------

  /// [root] değerlendirilirken [hit], önüne yan etkili/fırlatabilir bir şey girmeden KOŞULSUZ
  /// çalışıyor mu. Yalnız sade sarmalayıcılara (parantez, `as`, `await`, `throw`, `=` atama ve
  /// çağrı/kurucu bağımsız değişkenleri) inilir; bir bağımsız değişken yan etkiliyse ondan
  /// SONRAKİ konumlara inilmez. Kapanışlara, koşullu kollara, kısa devreye, `??` ve geri kalan
  /// her şeye inilmez (genel akış çözümlemesi değildir).
  bool must(AstNode? root, bool Function(AstNode) hit) {
    if (root == null) return false;
    if (hit(root)) return true;
    switch (root) {
      case ParenthesizedExpression():
        return must(root.expression, hit);
      case AsExpression():
        return must(root.expression, hit);
      case AwaitExpression():
        return must(root.expression, hit);
      case ThrowExpression():
        return must(root.expression, hit);
      case NamedArgument():
        return must(root.argumentExpression, hit);
      case AssignmentExpression():
        return root.operator.type == TokenType.EQ &&
            isPure(root.leftHandSide) &&
            must(root.rightHandSide, hit);
      case MethodInvocation():
        final t = root.target;
        if (t != null) {
          if (must(t, hit)) return true;
          if (!isPure(t)) return false;
        }
        return !root.isNullAware && _mustInArgs(root.argumentList, hit);
      case FunctionExpressionInvocation():
        if (must(root.function, hit)) return true;
        return isPure(root.function) && _mustInArgs(root.argumentList, hit);
      case InstanceCreationExpression():
        return _mustInArgs(root.argumentList, hit);
    }
    return false;
  }

  /// Bağımsız değişkenler sırayla değerlendirilir: [hit]'ten ÖNCE gelen her bağımsız değişken
  /// yan etkisiz olmalı (önceki `throw`/çağrı rapora ulaşmadan çıkabilir).
  bool _mustInArgs(ArgumentList list, bool Function(AstNode) hit) {
    for (final a in list.arguments) {
      if (must(a, hit)) return true;
      if (!isPure(a)) return false;
    }
    return false;
  }

  /// Deyim, kapanış dışında çıkabilir mi (return/throw/rethrow/break/continue/yield).
  static bool mayExit(AstNode stmt) {
    var found = false;
    stmt.accept(_ExitFinder(() => found = true));
    return found;
  }

  /// [stmts] sırayla çalışırken ilk koşulsuz sahip: `'rapor'` / `'iletilir'` ya da null (önce
  /// çıkış var, sahip yok ya da yalnız koşullu).
  String? ownerOf(Iterable<Statement> stmts, String? v) {
    for (final s in stmts) {
      final owner = _statementOwner(s, v);
      if (owner != null) return owner;
      if (mayExit(s)) return null;
    }
    return null;
  }

  String? _statementOwner(Statement s, String? v) {
    String? scan(AstNode? n) {
      if (n == null) return null;
      if (v != null && must(n, (x) => reportsCall(x, v))) return 'rapor';
      if (must(n, (x) => propagates(x, v))) return 'iletilir';
      return null;
    }

    switch (s) {
      case ExpressionStatement():
        return scan(s.expression);
      case ReturnStatement():
        return scan(s.expression);
      case VariableDeclarationStatement():
        for (final variable in s.variables.variables) {
          final o = scan(variable.initializer);
          if (o != null) return o;
          if (!isPure(variable.initializer)) {
            return null; // sonraki bildirime ulaşılamayabilir
          }
        }
        return null;
      case IfStatement():
        return scan(s.expression);
      case Block():
        return ownerOf(s.statements, v);
      default:
        return null;
    }
  }

  /// Geri çağrı (`onError`, `catchError`, `handleError`) birinci parametresini koşulsuz cepheye
  /// ya da yeniden fırlatmaya veriyor mu.
  bool callbackReports(Expression? cb) {
    if (cb is! FunctionExpression) return false;
    final params = cb.parameters?.parameters ?? const <FormalParameter>[];
    if (params.isEmpty) return false;
    final name = params.first.name?.lexeme;
    if (name == null) return false;
    return _bodyOwner(cb.body, name) == 'rapor';
  }

  String? _bodyOwner(FunctionBody body, String? v) => switch (body) {
    BlockFunctionBody() => ownerOf(body.block.statements, v),
    ExpressionFunctionBody() =>
      v != null && must(body.expression, (x) => reportsCall(x, v))
          ? 'rapor'
          : null,
    _ => null,
  };

  /// Gövdesinde hatayı parametresinden koşulsuz cepheye aktaran yerel işlevler (zincir).
  void _collectHelpers(CompilationUnit unit) {
    final decls = <(String, FormalParameterList?, FunctionBody)>[];
    unit.accept(
      _FnCollector((name, params, body) => decls.add((name, params, body))),
    );
    for (var pass = 0; pass < 4; pass++) {
      for (final (name, params, body) in decls) {
        final list = params?.parameters ?? const <FormalParameter>[];
        var positional = 0;
        final reported = <Object>{};
        for (final p in list) {
          final pname = p.name?.lexeme;
          final isNamed = p.isNamed;
          final key = isNamed ? (pname ?? '') : positional++;
          if (pname == null) continue;
          if (_bodyOwner(body, pname) == 'rapor') reported.add(key);
        }
        if (reported.isEmpty) continue;
        final prev = helpers[name];
        helpers[name] = prev == null ? reported : (prev..addAll(reported));
      }
    }
    // Aynı adlı birden çok bildirim (farklı sınıflar): kesişim — en az güvenceli olan geçerlidir.
    final counts = <String, int>{};
    for (final (name, _, _) in decls) {
      counts[name] = (counts[name] ?? 0) + 1;
    }
    for (final e in counts.entries.where((e) => e.value > 1)) {
      final sets = [
        for (final (name, params, body) in decls)
          if (name == e.key) _reportedKeys(params, body),
      ];
      helpers[e.key] = sets.reduce((a, b) => a.intersection(b));
      if (helpers[e.key]!.isEmpty) helpers.remove(e.key);
    }
  }

  Set<Object> _reportedKeys(FormalParameterList? params, FunctionBody body) {
    final out = <Object>{};
    var positional = 0;
    for (final p in params?.parameters ?? const <FormalParameter>[]) {
      final pname = p.name?.lexeme;
      final key = p.isNamed ? (pname ?? '') : positional++;
      if (pname != null && _bodyOwner(body, pname) == 'rapor') out.add(key);
    }
    return out;
  }
}

class _FnCollector extends RecursiveAstVisitor<void> {
  _FnCollector(this.onDecl);
  final void Function(String, FormalParameterList?, FunctionBody) onDecl;

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    onDecl(
      node.name.lexeme,
      node.functionExpression.parameters,
      node.functionExpression.body,
    );
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    onDecl(node.name.lexeme, node.parameters, node.body);
    super.visitMethodDeclaration(node);
  }
}

class _ExitFinder extends RecursiveAstVisitor<void> {
  _ExitFinder(this.onFound);
  final void Function() onFound;

  @override
  void visitFunctionExpression(FunctionExpression node) {} // kapanış: dışarı çıkış sayılmaz

  @override
  void visitReturnStatement(ReturnStatement node) => onFound();

  @override
  void visitBreakStatement(BreakStatement node) => onFound();

  @override
  void visitContinueStatement(ContinueStatement node) => onFound();

  @override
  void visitYieldStatement(YieldStatement node) => onFound();

  @override
  void visitThrowExpression(ThrowExpression node) => onFound();

  @override
  void visitRethrowExpression(RethrowExpression node) => onFound();
}

class _DeclVisitor extends RecursiveAstVisitor<void> {
  _DeclVisitor(this.out);
  final List<Declared> out;

  void _add(String name, AstNode node) => out.add((name: name, node: node));

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _add(node.name.lexeme, node);
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    _add(node.name.lexeme, node);
    super.visitMethodDeclaration(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    _add(node.name.lexeme, node);
    super.visitVariableDeclaration(node);
  }

  // Biçimsel parametreler (işlev tipli olanlar dahil): `RegularFormalParameter` hepsini kapsar.
  @override
  void visitRegularFormalParameter(RegularFormalParameter node) {
    final n = node.name?.lexeme;
    if (n != null) _add(n, node);
    super.visitRegularFormalParameter(node);
  }

  @override
  void visitFieldFormalParameter(FieldFormalParameter node) {
    _add(node.name.lexeme, node);
    super.visitFieldFormalParameter(node);
  }

  @override
  void visitSuperFormalParameter(SuperFormalParameter node) {
    _add(node.name.lexeme, node);
    super.visitSuperFormalParameter(node);
  }

  @override
  void visitDeclaredIdentifier(DeclaredIdentifier node) {
    _add(node.name.lexeme, node);
    super.visitDeclaredIdentifier(node);
  }

  @override
  void visitCatchClauseParameter(CatchClauseParameter node) {
    _add(node.name.lexeme, node);
    super.visitCatchClauseParameter(node);
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _add(node.namePart.typeName.lexeme, node);
    super.visitClassDeclaration(node);
  }
}
