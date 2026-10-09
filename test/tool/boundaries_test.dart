// tool/boundaries.dart negatif/pozitif matrisi + gerçek lib/ ağacının temiz olduğu.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/boundaries.dart';

List<String> rules(String path, String src) =>
    checkSource(path, src).map((v) => v.rule).toList();

void main() {
  group('B1 core → features/app yasak', () {
    test('package: importu', () {
      expect(
        rules(
          'core/http/a.dart',
          "import 'package:nizamio/features/identity/identity.dart';",
        ),
        ['B1'],
      );
    });
    test('göreli import', () {
      expect(
        rules(
          'core/http/a.dart',
          "import '../../features/identity/data/x.dart';",
        ),
        ['B1'],
      );
    });
    test('app importu', () {
      expect(rules('core/a.dart', "import 'package:nizamio/app/app.dart';"), [
        'B1',
      ]);
    });
    test('export da sayılır', () {
      expect(
        rules('core/a.dart', "export '../features/identity/identity.dart';"),
        ['B1'],
      );
    });
    test('core → core serbest', () {
      expect(
        rules('core/http/a.dart', "import '../storage/secure_store.dart';"),
        isEmpty,
      );
    });
  });

  group('B2/B3 features arası', () {
    test('features → app yasak', () {
      expect(
        rules(
          'features/identity/data/a.dart',
          "import 'package:nizamio/app/router.dart';",
        ),
        ['B2'],
      );
    });
    test("başka feature'ın iç katmanı yasak", () {
      expect(
        rules(
          'features/identity/application/a.dart',
          "import 'package:nizamio/features/work/data/repo.dart';",
        ),
        ['B3'],
      );
    });
    test("başka feature'ın açık yüzü serbest", () {
      expect(
        rules(
          'features/identity/application/a.dart',
          "import 'package:nizamio/features/work/work.dart';",
        ),
        isEmpty,
      );
    });
    test('göreli yolla iç katman da yakalanır', () {
      expect(
        rules(
          'features/identity/data/a.dart',
          "import '../../work/domain/task.dart';",
        ),
        ['B3'],
      );
    });
  });

  group('B4 katman yönü', () {
    const cases = {
      ('presentation', 'data'): ['B4'],
      ('presentation', 'application'): <String>[],
      ('presentation', 'domain'): <String>[],
      ('application', 'presentation'): ['B4'],
      ('application', 'data'): <String>[],
      ('data', 'application'): ['B4'],
      ('data', 'presentation'): ['B4'],
      ('data', 'domain'): <String>[],
      ('domain', 'data'): ['B4'],
      ('domain', 'application'): ['B4'],
    };
    cases.forEach((pair, expected) {
      test('${pair.$1} → ${pair.$2}', () {
        expect(
          rules(
            'features/identity/${pair.$1}/a.dart',
            "import 'package:nizamio/features/identity/${pair.$2}/b.dart';",
          ),
          expected,
        );
      });
    });
    test('iç katman kendi açık yüzünü import edemez (döngü)', () {
      expect(
        rules('features/identity/data/a.dart', "import '../identity.dart';"),
        ['B4'],
      );
    });
  });

  group('B5 yerleşim', () {
    test('bilinmeyen katman', () {
      expect(rules('features/identity/widgets/a.dart', ''), ['B5']);
    });
    test('lib kökünde main dışı dosya', () {
      expect(rules('helpers.dart', ''), ['B5']);
    });
    test('lib altında bilinmeyen alan', () {
      expect(rules('shared/a.dart', ''), ['B5']);
    });
    test('main_dev.dart serbest', () {
      expect(rules('main_dev.dart', ''), isEmpty);
    });
  });

  group('D1 elle DTO yasak', () {
    const kacislar = {
      'json_annotation importu':
          "import 'package:json_annotation/json_annotation.dart';",
      '@JsonSerializable': '@JsonSerializable() class A {}',
      '@JsonKey alanı': "class A { @JsonKey(name: 'x') final int x = 1; }",
      'fromJson fabrikası':
          'class A { A(); factory A.fromJson(Object? j) => A(); }',
      'toJson metodu': 'class A { Object toJson() => 1; }',
      'statik fromJson': 'class A { static A fromJson(Object? j) => A(); }',
      'üst düzey fonksiyon': r'Object? _$AToJson(Object a) => null;',
      'extension metodu': 'extension E on int { Object toJson() => this; }',
      'fonksiyon alanı': 'final userFromJson = (Object? j) => j;',
    };
    kacislar.forEach((name, src) {
      test(name, () {
        expect(rules('features/identity/data/a.dart', src), contains('D1'));
        expect(rules('core/http/a.dart', src), contains('D1'));
      });
    });
    test('üretilmiş API dizini muaf', () {
      expect(
        rules(
          'core/api/generated/models/a.dart',
          "import 'package:json_annotation/json_annotation.dart';\n"
              '@JsonSerializable() class A { A(); factory A.fromJson(Object? j) => A(); }',
        ),
        isEmpty,
      );
    });
    test('yorum ve dize içindeki sözcük ihlal değil', () {
      expect(
        rules('core/a.dart', "// fromJson kullanılmaz\nconst s = 'toJson';"),
        isEmpty,
      );
    });
  });

  group('D2 features içinde elle JSON', () {
    test('dart:convert', () {
      expect(rules('features/identity/data/a.dart', "import 'dart:convert';"), [
        'D2',
      ]);
    });
    test('Map<String, dynamic>', () {
      expect(
        rules(
          'features/identity/data/a.dart',
          'Map<String, dynamic> f() => {};',
        ),
        ['D2'],
      );
    });
    test('Map<String, Object?> typedef ile', () {
      expect(
        rules(
          'features/identity/data/a.dart',
          'typedef J = Map<String, Object?>;',
        ),
        ['D2'],
      );
    });
    test('core içinde Map<String, dynamic> serbest (dio başlıkları)', () {
      expect(
        rules('core/http/a.dart', 'Map<String, dynamic> h = {};'),
        isEmpty,
      );
    });
  });

  group('S kuralları', () {
    test('flutter_secure_storage yalnız core/storage', () {
      const src =
          "import 'package:flutter_secure_storage/flutter_secure_storage.dart';";
      expect(rules('core/http/a.dart', src), ['S1']);
      expect(rules('core/storage/a.dart', src), isEmpty);
    });
    test('badCertificateCallback yasak (core dahil)', () {
      expect(
        rules(
          'core/http/a.dart',
          'void f(dynamic c) { c.badCertificateCallback = null; }',
        ),
        ['S2'],
      );
    });
    test('HttpOverrides yasak', () {
      expect(
        rules('core/a.dart', 'void f() { HttpOverrides.global = null; }'),
        ['S2'],
      );
    });
    test('debugPrint ve dart:developer yalnız core/logging', () {
      expect(rules('core/http/a.dart', "void f() { debugPrint('x'); }"), [
        'S3',
      ]);
      expect(rules('core/http/a.dart', "import 'dart:developer';"), ['S3']);
      expect(rules('core/logging/a.dart', "import 'dart:developer';"), isEmpty);
    });
    test('domain saf Dart', () {
      expect(
        rules(
          'features/identity/domain/a.dart',
          "import 'package:dio/dio.dart';",
        ),
        ['S4'],
      );
      expect(
        rules(
          'features/identity/domain/a.dart',
          "import 'package:flutter/widgets.dart';",
        ),
        ['S4'],
      );
    });
  });

  test('gerçek lib/ ağacı kurallara uyar', () {
    final violations = <Violation>[];
    for (final f in Directory(
      'lib',
    ).listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      violations.addAll(
        checkSource(f.path.substring('lib/'.length), f.readAsStringSync()),
      );
    }
    expect(violations.map((v) => v.toString()), isEmpty);
  });
}
