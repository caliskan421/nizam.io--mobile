// tool/error_paths.dart (hata yolu kapsam kapısı): pozitif/negatif fixture matrisi, istisna
// listesinin sağlığı ve gerçek lib/ ağacının temiz + envanterin güncel olduğu.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/error_path_exceptions.dart';
import '../../tool/error_path_inventory.dart' as inventory;
import '../../tool/error_paths.dart';

List<String> rules(
  String src, {
  String path = 'features/tasks/application/x.dart',
  Map<String, ErrorPathException> exceptions = const {},
  Map<String, int>? usage,
}) => checkErrorPaths(
  path,
  src,
  exceptions: exceptions,
  usage: usage,
).map((v) => v.rule).toList();

void main() {
  group('izinli (ihlal YOK)', () {
    test('yakalanan hata rapor cephesine verilir', () {
      expect(
        rules('''
Future<void> f() async {
  try { await g(); } on Object catch (e, st) {
    reportUnexpected(e, st, source: ReportSource.tasks);
  }
}'''),
        isEmpty,
      );
    });

    test('toReportedApiError ile çeviri', () {
      expect(
        rules('''
Future<void> f() async {
  try { await g(); } on Object catch (e, st) {
    state = Failed(toReportedApiError(e, st, source: ReportSource.tasks));
  }
}'''),
        isEmpty,
      );
    });

    test('rethrow / throw e / Error.throwWithStackTrace(e …) iletilir', () {
      expect(
        rules('''
void a() { try { g(); } catch (e) { cleanup(); rethrow; } }
void b() { try { g(); } catch (e) { throw e; } }
void c() { try { g(); } catch (e, s) { Error.throwWithStackTrace(e, s); } }'''),
        isEmpty,
      );
    });

    test('on ApiError de girişte politika yardımcısından geçer', () {
      expect(
        rules('''
void a() { try { g(); } on ApiError catch (e, st) {
  reportUnexpected(e, st, source: ReportSource.tasks);
  show(e);
} }'''),
        isEmpty,
      );
    });

    test('aynı dosyada ExpectedFailure işaretli sınıf: denetim akışı', () {
      expect(
        rules('''
class _Cancelled implements Exception, ExpectedFailure {}
void a() { try { g(); } on _Cancelled { return; } }'''),
        isEmpty,
      );
    });

    test('güvenilir ön ek ve dosya düzeyi takma ad gerçek cephedir', () {
      expect(
        rules(
          '''
import 'package:nizamio/core/telemetry/unexpected_error.dart' as tel;
import '../../../core/telemetry/unexpected_error.dart' as rel;
final alias = reportUnexpected;
void a() { try { g(); } catch (e, st) { tel.reportUnexpected(e, st, source: s); } }
void b() { try { g(); } catch (e, st) { alias(e, st, source: s); } }
void c() { try { g(); } catch (e, st) { rel.reportUnexpected(e, st, source: s); } }
void d() { try { g(); } catch (e, st) { reportUnexpected(e.error ?? e, st); } }''',
        ),
        isEmpty,
      );
    });

    test('yardımcı hatayı kendi parametresinden koşulsuz aktarır', () {
      expect(
        rules('''
void _fail(Object error, StackTrace st, int epoch) {
  count++;
  reportUnexpected(error, st, source: s);
}
void a() { try { g(); } catch (e, st) { _fail(e, st, 1); } }'''),
        isEmpty,
      );
    });

    test('girişte koşulsuz rapor: önceki deyim çıkamıyorsa kabul', () {
      expect(
        rules('''
void a() {
  try { g(); } catch (e, st) {
    failed++;
    final api = toReportedApiError(e, st, source: s);
    if (!mounted) return;
    show(api);
  }
}'''),
        isEmpty,
      );
    });

    test('dosya içi yardımcı rapor cephesini çağırıyorsa kabul', () {
      expect(
        rules('''
void _report(Object e, StackTrace st) =>
    reportUnexpected(e, st, source: ReportSource.tasks);
void a() { try { g(); } catch (e, st) { _report(e, st); } }'''),
        isEmpty,
      );
    });

    test('onError / handleError geri çağrısı raporluyorsa kabul', () {
      expect(
        rules('''
void a() {
  s.listen(h, onError: (Object e, StackTrace st) {
    reportUnexpected(e, st, source: ReportSource.tasks);
  });
  f.catchError((Object e, StackTrace st) {
    reportUnexpected(e, st, source: ReportSource.tasks);
  });
}'''),
        isEmpty,
      );
    });

    test('guard içinde rapor cephesi varsa kabul', () {
      expect(
        rules('''
Future<void> a() async {
  state = await AsyncValue.guard(() async {
    try { return await g(); } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.identity);
      rethrow;
    }
  });
}'''),
        isEmpty,
      );
    });

    test('üretilmiş ve telemetri altyapısı dosyaları ölçüt dışı', () {
      const bad = 'void a() { try { g(); } catch (e) {} }';
      expect(rules(bad, path: 'core/api/generated/x.dart'), isEmpty);
      expect(rules(bad, path: 'features/x/data/y.g.dart'), isEmpty);
      expect(rules(bad, path: 'core/telemetry/error_reporting.dart'), isEmpty);
      expect(rules(bad, path: 'app/telemetry/error_hooks.dart'), isEmpty);
    });
  });

  group('kaçışlar yakalanır (ihlal VAR)', () {
    test('sessiz catch', () {
      expect(rules('void a() { try { g(); } catch (e) {} }'), ['E1']);
    });

    test('hata arayüz durumuna çevrilip yutulur (custom state)', () {
      expect(
        rules('''
Future<void> a() async {
  try { await g(); } on Object catch (e) {
    state = Failed(toApiError(e));
  }
}'''),
        ['E1'],
      );
    });

    test('değişkensiz catch raporlayamaz', () {
      expect(rules('void a() { try { g(); } on Object { x = 1; } }'), ['E1']);
    });

    test(
      'takma ad yalnız dosya düzeyi final ise; yerel/değişken takma ad değil',
      () {
        expect(
          rules('''
void a() {
  var r = reportUnexpected;
  try { g(); } catch (e, st) { r(e, st, source: s); }
}'''),
          ['E1'],
        );
      },
    );

    // Bağımsız saldırgan fixture'ları (/tmp/nizamio-reporting-independent-checks).
    test('gölgelenmiş/sahte cephe reddedilir (E6) ve rapor sayılmaz', () {
      expect(
        rules('''
void reportUnexpected(Object e) {}
void f() { try { g(); } catch (e) { reportUnexpected(e); } }'''),
        ['E1', 'E6'],
      );
      expect(
        rules('''
void f(void Function(Object) reportUnexpected) {
  try { g(); } catch (e) { reportUnexpected(e); }
}'''),
        ['E1', 'E6'],
      );
      expect(
        rules(
          'void f() { try { g(); } catch (e, st) { obj.reportUnexpected(e, st); } }',
        ),
        ['E1'],
        reason: 'başka nesnenin yöntemi cephe değildir',
      );
    });

    test('yardımcı yanlış hata/koşullu aktarıyorsa reddedilir', () {
      expect(
        rules('''
void h(Object e) { reportUnexpected(StateError("başka")); }
void f() { try { g(); } catch (e) { h(e); } }'''),
        ['E1'],
      );
      expect(
        rules('''
void h(Object e) { if (false) reportUnexpected(e); }
void f() { try { g(); } catch (e) { h(e); } }'''),
        ['E1'],
      );
    });

    test('koşullu, erişilemez, tembel rapor/iletme reddedilir', () {
      for (final body in [
        'if (enabled) reportUnexpected(e);',
        'return; reportUnexpected(e);',
        'final unused = () => reportUnexpected(e);',
        'enabled && reportUnexpected(e);',
        'if (enabled) rethrow; return;',
        'return; rethrow;',
        'final unused = () => throw e;',
        'if (!mounted) return; reportUnexpected(e);',
        'reportUnexpected(other, context: () => e);',
        'reportUnexpected(StateError("x"), e);',
      ]) {
        expect(
          rules(
            'void f(bool enabled, Object other) { try { g(); } catch (e) { $body } }',
          ),
          ['E1'],
          reason: body,
        );
      }
    });

    test('sahte/gölgelenmiş ön ek ve yardımcı adı gerçek cephe sayılmaz', () {
      const trusted =
          "import 'package:nizamio/core/telemetry/unexpected_error.dart' as r;";
      for (final src in [
        // gerçek ön ek parametre/yerel ile gölgelenmiş
        '$trusted void f(dynamic r) { try { g(); } catch (e) { r.reportUnexpected(e); } }',
        '$trusted void f(dynamic x) { final r = x; try { g(); } catch (e) { r.reportUnexpected(e); } }',
        // sahte paket / sonek / dizin dışı hedef
        "import 'package:evil/telemetry/unexpected_error.dart' as r; void f() { try { g(); } catch (e) { r.reportUnexpected(e); } }",
        "import 'package:evil/core/telemetry/unexpected_error.dart' as r; void f() { try { g(); } catch (e) { r.reportUnexpected(e); } }",
        "import '../../x/telemetry/unexpected_error.dart' as r; void f() { try { g(); } catch (e) { r.reportUnexpected(e); } }",
        // yardımcı adı aynı adlı parametreyle gölgelenmiş
        'void helper(Object e) { reportUnexpected(e); } '
            'void f(void Function(Object) helper) { try { g(); } catch (e) { helper(e); } }',
      ]) {
        expect(rules(src), contains('E1'), reason: src);
      }
    });

    test('hata bağımsız değişkeni yalnız e ya da e.error ?? e olabilir', () {
      for (final body in [
        'reportUnexpected(other ?? e);',
        'reportUnexpected(e ?? other);',
        'throw other ?? e;',
        'throw other.error ?? e;',
      ]) {
        expect(
          rules('void f(Object other) { try { g(); } catch (e) { $body } }'),
          ['E1'],
          reason: body,
        );
      }
    });

    test('rapordan önce fırlatabilen bağımsız değişken/ifade reddedilir', () {
      for (final body in [
        'reportUnexpected(e, throw StateError("lost"));',
        'consume(throw StateError("lost"), reportUnexpected(e));',
        'reportUnexpected(e, st, source: compute());',
        'consume(sideEffect(), toReportedApiError(e));',
      ]) {
        expect(
          rules('void f(StackTrace st) { try { g(); } catch (e) { $body } }'),
          ['E1'],
          reason: body,
        );
      }
    });

    test('guard: kapanış içindeki sahipsiz rapor çağrısı sahiplik değildir', () {
      for (final cb in [
        // kullanılmayan kapanışta rapor; guard gövdesi fırlatıp AsyncError olur
        '() async { final unused = () => reportUnexpected(other, st); throw StateError("x"); }',
        // catch yok
        '() async { reportUnexpected(other, st); return g(); }',
        // catch var ama başka değişkeni raporluyor
        '() async { try { return await g(); } on Object catch (e) { reportUnexpected(other, st); rethrow; } }',
        // yalnız yeniden fırlatma: rapor yok
        '() async { try { return await g(); } on Object catch (e) { rethrow; } }',
        // hepsini yakalayan kol yok
        '() async { try { return await g(); } on FormatException catch (e, st) { reportUnexpected(e, st); rethrow; } }',
        // finally bloğu raporsuz yeni hata üretebilir
        '() async { try { return await g(); } catch (e, st) { reportUnexpected(e, st); rethrow; } finally { throw StateError("lost"); } }',
      ]) {
        final got = rules(
          'void f(Object other, StackTrace st) { AsyncValue.guard($cb); }',
        );
        expect(got, contains('E2'), reason: cb);
      }
    });

    test('on ApiError ve özel hata tür adına güvenilmez', () {
      expect(
        rules('void f() { try { g(); } on ApiError catch (e) { return; } }'),
        ['E1'],
      );
      expect(
        rules('''
class _Corruption implements Exception {}
void f() { try { g(); } on _Corruption { return; } }'''),
        ['E1'],
        reason: 'ExpectedFailure işareti yok',
      );
    });

    test('yardımcı rapor cephesini ÇAĞIRMIYORSA kabul edilmez', () {
      expect(
        rules('''
void _handle(Object e) { state = Failed(e); }
void a() { try { g(); } catch (e) { _handle(e); } }'''),
        ['E1'],
      );
    });

    test('farklı bir değişken raporlanıyorsa yakalanan hata yutulmuştur', () {
      expect(
        rules('''
void a(Object other, StackTrace st) {
  try { g(); } catch (e) { reportUnexpected(other, st, source: s); }
}'''),
        ['E1'],
      );
    });

    test('yorum ve dize içindeki ad sayılmaz', () {
      expect(
        rules('''
void a() {
  try { g(); } catch (e) {
    // reportUnexpected(e, st) burada çağrılmalı
    log('reportUnexpected(e)');
  }
}'''),
        ['E1'],
      );
    });

    test('yeni nesne fırlatmak (çeviri) iletme değildir', () {
      expect(
        rules('void a() { try { g(); } catch (e) { throw StateError("x"); } }'),
        ['E1'],
      );
    });

    test('AsyncValue.guard raporsuz', () {
      expect(
        rules(
          'Future<void> a() async { state = await AsyncValue.guard(() => g()); }',
        ),
        ['E2'],
      );
    });

    test('AsyncError doğrudan kurulur', () {
      expect(
        rules(
          'AsyncValue<int> a(Object e) => AsyncError(e, StackTrace.current);',
        ),
        ['E2'],
      );
      expect(
        rules('Object a(Object e, StackTrace s) => AsyncValue.error(e, s);'),
        ['E2'],
      );
    });

    test('catchError / handleError / onError yutması', () {
      expect(rules('void a() { f.catchError((Object _) {}); }'), ['E2']);
      expect(rules('void a() { s.handleError((Object _) {}); }'), ['E2']);
      expect(rules('void a() { s.listen(h, onError: (Object _) {}); }'), [
        'E2',
      ]);
      expect(
        rules(
          'void a() { f.then((_) {}, onError: (Object _, StackTrace _) {}); }',
        ),
        ['E2'],
      );
      expect(
        rules('void a() { T.fromHandlers(handleError: (e, s, sink) {}); }'),
        ['E2'],
      );
    });

    test('onError ya da catchError tear-off ile saklanamaz', () {
      expect(rules('void a() { s.listen(h, onError: _swallow); }'), ['E2']);
      expect(rules('void a() { f.catchError(_swallow); }'), ['E2']);
    });

    test('ham Dio isteği apiCall dışında', () {
      expect(rules('Future<void> a() async { await _dio.post("/x"); }'), [
        'E3',
      ]);
      expect(rules('Future<void> a() async { await dio.get("/x"); }'), ['E3']);
      expect(
        rules(
          'Future<void> a() async { await _dio.get("/x"); }',
          path: 'core/http/ok.dart',
        ),
        isEmpty,
        reason: 'core/http katmanı halkaların kendisidir',
      );
    });

    test('apiCall takma adı ve işlev değeri olarak geçirme', () {
      expect(rules('final call = apiCall;'), ['E4']);
      expect(rules('void a() { run(apiCall); }'), ['E4']);
      expect(rules('Future<int> a() => apiCall(() => g());'), isEmpty);
      expect(
        rules('/// [apiCall] ile sarılır.\nvoid a() {}'),
        isEmpty,
        reason: 'belge bağlantısı çağrı değildir',
      );
    });

    test('client.invalid_response ham ApiError ile kurulamaz', () {
      expect(
        rules('void a() { throw ApiError(ClientErrorCode.invalidResponse); }'),
        ['E5'],
      );
      expect(rules("void a() { throw ApiError('client.invalid_response'); }"), [
        'E5',
      ]);
      expect(
        rules('void a() { throw invalidResponseError(); }'),
        isEmpty,
        reason: 'raporlu fabrika',
      );
    });
  });

  group('istisna tablosu', () {
    const src = 'void a() { try { g(); } catch (e) {} }';
    const key = 'features/tasks/application/x.dart::<top>.a#catch';
    // Kapsam adı üst düzey işlev adıdır.
    const real = 'features/tasks/application/x.dart::a#catch';

    test('anahtar eşleşirse izinli; kullanım sayılır', () {
      final usage = <String, int>{};
      expect(
        rules(
          src,
          exceptions: {real: const ErrorPathException(1, 'gerekçe')},
          usage: usage,
        ),
        isEmpty,
      );
      expect(usage[real], 1);
      expect(key, isNotEmpty);
    });

    test('sınır aşılırsa ihlal: istisna tüm dosyaya genişlemez', () {
      expect(
        rules(
          'void a() { try { g(); } catch (e) {} try { g(); } catch (e) {} }',
          exceptions: {real: const ErrorPathException(1, 'gerekçe')},
        ),
        ['E1'],
      );
    });

    test('başka işlevdeki aynı tür yol izinli sayılmaz', () {
      expect(
        rules(
          'void b() { try { g(); } catch (e) {} }',
          exceptions: {real: const ErrorPathException(1, 'gerekçe')},
        ),
        ['E1'],
      );
    });
  });

  group('gerçek ağaç', () {
    final lib = inventory.readLib();

    test('lib/ ağacında ihlal yok ve bayat istisna yok', () {
      final usage = <String, int>{};
      final violations = [
        for (final MapEntry(key: p, value: s) in lib.entries)
          ...checkErrorPaths(p, s, usage: usage),
      ];
      expect(violations.map((v) => v.toString()), isEmpty);
      expect(
        errorPathExceptions.keys.where((k) => !usage.containsKey(k)),
        isEmpty,
        reason: 'kodda karşılığı kalmayan istisna anahtarı silinmeli',
      );
    });

    test('her istisnanın gerçek gerekçesi ve makul sınırı var', () {
      for (final MapEntry(:key, :value) in errorPathExceptions.entries) {
        expect(value.reason.length, greaterThanOrEqualTo(40), reason: key);
        expect(value.max, inInclusiveRange(1, 4), reason: key);
        expect(key, matches(RegExp(r'^[a-z_/\.]+\.dart::[^#]+#\w+$')));
      }
    });

    test(
      'docs/yurutme/hata-takibi-kapsam.md kaynaktan üretilmiş ve güncel',
      () {
        expect(
          File(inventory.docPath).readAsStringSync(),
          inventory.render(lib),
          reason: 'dart run tool/error_path_inventory.dart',
        );
      },
    );
  });
}
