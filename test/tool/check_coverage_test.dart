// tool/check_coverage.dart: lcov ayrıştırma, dizin eşikleri, üretilmiş dosya hariç tutma,
// fail-closed (karar 11) ve süreç çıkış kodu.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_coverage.dart';

String lcov(Map<String, List<int>> files) {
  final b = StringBuffer();
  for (final MapEntry(key: path, value: hits) in files.entries) {
    b.writeln('SF:$path');
    for (var i = 0; i < hits.length; i++) {
      b.writeln('DA:${i + 1},${hits[i]}');
    }
    b.writeln('end_of_record');
  }
  return b.toString();
}

CoverageReport eval(
  Map<String, List<int>> files, {
  Map<String, String> sources = const {},
}) => evaluateCoverage(parseLcov(lcov(files)), sources);

List<int> lines(int covered, int total) => [
  for (var i = 0; i < total; i++) i < covered ? 1 : 0,
];

void main() {
  group('ayrıştırma', () {
    test('lib/ göreli yol, mutlak yol ve lib dışı', () {
      final parsed = parseLcov(
        'SF:lib/core/a.dart\nDA:1,2\nDA:2,0\nend_of_record\n'
        'SF:/w/proj/lib/core/b.dart\nDA:1,1\nend_of_record\n'
        'SF:/w/proj/test/x.dart\nDA:1,1\nend_of_record\n',
        root: '/w/proj',
      );
      expect(parsed.keys, ['core/a.dart', 'core/b.dart']);
      expect(parsed['core/a.dart'], {1: 2, 2: 0});
    });
  });

  group('dizin grupları', () {
    test('widgets core eşiğinden ayrı', () {
      expect(coverageGroup('core/ui/widgets/x/nz_a.dart'), 'widgets');
      expect(coverageGroup('core/ui/theme/t.dart'), 'core');
      expect(coverageGroup('features/id/application/s.dart'), 'application');
      expect(coverageGroup('features/id/data/r.dart'), 'data');
      expect(coverageGroup('features/id/presentation/p.dart'), 'presentation');
      expect(coverageGroup('app/app.dart'), isNull);
    });
    test('üretilmiş dosyalar hariç', () {
      expect(coverageGroup('core/api/generated/x.dart'), isNull);
      expect(coverageGroup('core/a.g.dart'), isNull);
      expect(coverageGroup('features/id/data/a.freezed.dart'), isNull);
    });
  });

  group('eşikler', () {
    test('tam eşikte geçer, altında kırılır (core %80)', () {
      expect(eval({'lib/core/a.dart': lines(80, 100)}).failed, isFalse);
      final low = eval({'lib/core/a.dart': lines(79, 100)});
      expect(low.failed, isTrue);
      expect(low.groups['core']!.belowThreshold, isTrue);
    });
    test('presentation %60, widgets %70', () {
      expect(
        eval({'lib/features/a/presentation/p.dart': lines(60, 100)}).failed,
        isFalse,
      );
      expect(
        eval({'lib/features/a/presentation/p.dart': lines(59, 100)}).failed,
        isTrue,
      );
      expect(
        eval({'lib/core/ui/widgets/g/nz_a.dart': lines(70, 100)}).failed,
        isFalse,
      );
      expect(
        eval({'lib/core/ui/widgets/g/nz_a.dart': lines(69, 100)}).failed,
        isTrue,
      );
    });
    test('widgets kapsaması core ortalamasını yükseltmez/düşürmez', () {
      final r = eval({
        'lib/core/a.dart': lines(10, 100),
        'lib/core/ui/widgets/g/nz_a.dart': lines(100, 100),
      });
      expect(r.groups['core']!.belowThreshold, isTrue);
      expect(r.groups['widgets']!.belowThreshold, isFalse);
    });
    test('application ve data için %80', () {
      expect(
        eval({'lib/features/a/application/s.dart': lines(7, 10)}).failed,
        isTrue,
      );
      expect(eval({'lib/features/a/data/r.dart': lines(7, 10)}).failed, isTrue);
    });
    test('üretilmiş ve app dosyaları eşiği etkilemez', () {
      final r = eval({
        'lib/core/a.dart': lines(10, 10),
        'lib/core/api/generated/g.dart': lines(0, 500),
        'lib/core/x.g.dart': lines(0, 500),
        'lib/app/app.dart': lines(0, 500),
      });
      expect(r.failed, isFalse);
    });
    test('dosyasız dizin geçer', () {
      expect(eval({}).failed, isFalse);
    });
  });

  group('fail-closed (karar 11)', () {
    test('lcov\'da görünmeyen eşikli dosya kapıyı kırar', () {
      final r = eval(
        {'lib/core/a.dart': lines(10, 10)},
        sources: {'core/errors/error_text.dart': 'class A {}\nint f() => 1;\n'},
      );
      expect(r.failed, isTrue);
      expect(r.groups['core']!.uncovered, ['core/errors/error_text.dart']);
    });
    test('yalnız yönerge/yorum içeren dosya hariç', () {
      final r = eval(
        {'lib/core/a.dart': lines(10, 10)},
        sources: {
          'features/identity/application/identity.dart': "// yüz\nlibrary;\nexport 'a.dart'\n    show A;\nimport 'b.dart';\npart 'c.dart';\n",
        },
      );
      expect(r.failed, isFalse);
    });
    test('eşiksiz ve üretilmiş görünmeyen dosya sorun değil', () {
      final r = eval(
        {},
        sources: {
          'main_dev.dart': 'void main() {}',
          'core/api/generated/a.dart': 'class A {}',
          'core/b.g.dart': 'class B {}',
        },
      );
      expect(r.failed, isFalse);
    });
  });

  group('süreç çıkış kodu', () {
    late Directory dir;
    setUp(() => dir = Directory.systemTemp.createTempSync('cov_'));
    tearDown(() => dir.deleteSync(recursive: true));

    Future<ProcessResult> run(String lcovText, Map<String, String> libFiles) {
      for (final MapEntry(key: p, value: c) in libFiles.entries) {
        File('${dir.path}/lib/$p')
          ..createSync(recursive: true)
          ..writeAsStringSync(c);
      }
      File('${dir.path}/coverage/lcov.info')
        ..createSync(recursive: true)
        ..writeAsStringSync(lcovText);
      return Process.run('dart', [
        '${Directory.current.path}/tool/check_coverage.dart',
      ], workingDirectory: dir.path);
    }

    test('eşik altı → çıkış 1, üstü → 0', () async {
      const src = {'core/a.dart': 'int a() => 1;'};
      final bad = await run(lcov({'lib/core/a.dart': lines(1, 10)}), src);
      expect(bad.exitCode, 1);
      final ok = await run(lcov({'lib/core/a.dart': lines(10, 10)}), src);
      expect(ok.exitCode, 0, reason: '${ok.stdout}${ok.stderr}');
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('lcov yoksa → çıkış 2', () async {
      final r = await Process.run('dart', [
        '${Directory.current.path}/tool/check_coverage.dart',
      ], workingDirectory: dir.path);
      expect(r.exitCode, 2);
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
