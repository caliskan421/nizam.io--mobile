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
    test('çıkarımlı ve tipli Map literal istek gövdesi (Codex 8)', () {
      for (final src in [
        "final body = {'password': password};",
        "final body = <String, Object?>{'password': password};",
        'final body = <String, dynamic>{};',
        "final body = const {'a': 1};",
        "final body = {if (c) 'k': v};",
        "final body = {for (final x in xs) 'k\$x': x};",
        "final body = {'a' 'b': 1};",
        "final body = {...other, 'k': 1};",
      ]) {
        expect(
          rules('features/identity/data/a.dart', src),
          contains('D2'),
          reason: src,
        );
        expect(
          rules('features/identity/presentation/a.dart', src),
          contains('D2'),
          reason: src,
        );
      }
    });
    test('Map literal pozitifleri: küme, boş, anahtarı dize olmayan, core', () {
      for (final src in [
        "final s = {'a', 'b'};",
        "final s = <String>{'a'};",
        'final m = {};',
        'final m = {k: v};',
        'final m = <int, String>{1: "a"};',
      ]) {
        expect(
          rules('features/identity/data/a.dart', src),
          isEmpty,
          reason: src,
        );
      }
      expect(rules('core/http/a.dart', "final h = {'a': 1};"), isEmpty);
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
    test('HttpOverrides tip yolları: typedef, extends, önekli (Codex 8)', () {
      for (final src in [
        'typedef O = HttpOverrides;',
        'class X extends HttpOverrides {}',
        'class X implements HttpOverrides {}',
        "import 'dart:io' as io;\nio.HttpOverrides? o;",
        'HttpOverrides? o;',
        'void f<T extends HttpOverrides>() {}',
      ]) {
        expect(rules('core/a.dart', src), contains('S2'), reason: src);
      }
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

  group('G1/G2 get_it yalnız bileşim kökünde (ADR-0001, D-0182)', () {
    const getIt = "import 'package:get_it/get_it.dart';";
    test('core → get_it yasak', () {
      expect(rules('core/session/a.dart', getIt), ['G1']);
    });
    test('presentation → get_it yasak', () {
      expect(rules('features/identity/presentation/a.dart', getIt), ['G1']);
    });
    test('application → get_it yasak', () {
      expect(rules('features/identity/application/a.dart', getIt), ['G1']);
    });
    test('data ve domain → get_it yasak', () {
      expect(rules('features/identity/data/a.dart', getIt), ['G1']);
      expect(rules('features/identity/domain/a.dart', getIt), ['G1']);
    });
    test('feature açık yüzü → get_it yasak', () {
      expect(rules('features/identity/identity.dart', getIt), ['G1']);
    });
    test('app/** ve <f>_module.dart → get_it serbest', () {
      expect(rules('app/di/dependencies.dart', getIt), isEmpty);
      expect(rules('features/identity/identity_module.dart', getIt), isEmpty);
    });
    test('başka adlı feature kök dosyası modül sayılmaz', () {
      expect(
        rules('features/identity/kayit_module.dart', getIt),
        containsAll(['B5', 'G1']),
      );
    });
    test('modül yalnız app/di tarafından import edilir', () {
      const mod =
          "import 'package:nizamio/features/identity/identity_module.dart';";
      expect(rules('app/di/composition.dart', mod), isEmpty);
      expect(rules('app/bootstrap.dart', mod), ['G2']);
      expect(
        rules(
          'features/identity/identity.dart',
          "export 'identity_module.dart';",
        ),
        ['G2'],
      );
      expect(rules('features/work/application/a.dart', mod), ['G2']);
      expect(rules('core/a.dart', mod), containsAll(['B1', 'G2']));
    });
    test('modül kendi katmanlarını ve core\'u import edebilir', () {
      expect(
        rules(
          'features/identity/identity_module.dart',
          "import 'application/identity_service.dart';\nimport 'data/identity_repository.dart';\n"
              "import '../../core/session/session_controller.dart';",
        ),
        isEmpty,
      );
    });
  });

  group('A1 üretilmiş API kodu yalnız data katmanında', () {
    const dto =
        "import 'package:nizamio/core/api/generated/models/me_response.dart';";
    test('application → DTO yasak (package: ve göreli)', () {
      expect(rules('features/identity/application/a.dart', dto), ['A1']);
      expect(
        rules(
          'features/identity/application/a.dart',
          "import '../../../core/api/generated/models/me_response.dart';",
        ),
        ['A1'],
      );
    });
    test('presentation ve domain → DTO yasak', () {
      expect(rules('features/identity/presentation/a.dart', dto), ['A1']);
      expect(rules('features/identity/domain/a.dart', dto), ['A1']);
    });
    test('enum ve istemci de sayılır', () {
      expect(
        rules(
          'features/work/presentation/a.dart',
          "import 'package:nizamio/core/api/generated/models/roster_member_status.dart';",
        ),
        ['A1'],
      );
      expect(
        rules(
          'features/identity/application/a.dart',
          "import 'package:nizamio/core/api/generated/clients/identity_client.dart';",
        ),
        ['A1'],
      );
    });
    test('açık yüz DTO dışa veremez', () {
      expect(
        rules(
          'features/identity/identity.dart',
          "export '../../core/api/generated/models/me_response.dart';",
        ),
        ['A1'],
      );
    });
    test('data ve <f>_module.dart → serbest; core → serbest', () {
      expect(rules('features/identity/data/a.dart', dto), isEmpty);
      expect(rules('features/identity/identity_module.dart', dto), isEmpty);
      expect(rules('core/http/a.dart', dto), isEmpty);
    });
    test('B8 yüzde-kodlu ve ./.. bileşenli URI fail-closed (CX-a-Ö-06)', () {
      expect(
        rules(
          'features/identity/application/a.dart',
          "import 'package:nizamio/core/api/g%65nerated/models/me_response.dart';",
        ),
        ['B8'],
      );
      expect(
        rules(
          'features/identity/identity.dart',
          "export 'package:nizamio/core/api/g%65nerated/models/me_response.dart';",
        ),
        ['B8'],
      );
      expect(
        rules('core/session/a.dart', "import 'package:get%5Fit/get_it.dart';"),
        ['B8'],
      );
      expect(
        rules(
          'app/bootstrap.dart',
          "import 'package:nizamio/features/identity/identity%5Fmodule.dart';",
        ),
        ['B8'],
      );
      expect(
        rules(
          'features/identity/application/a.dart',
          "import 'package:nizamio/features/../core/api/generated/models/me_response.dart';",
        ),
        ['B8'],
      );
      expect(rules('features/identity/data/a.g.dart', "part of 'a%2Edart';"), [
        'B6',
      ]);
    });
    test('B7 koşullu import/export yasak (üretilmiş kod hariç)', () {
      const cond = "import 'a.dart' if (dart.library.io) 'b.dart';";
      expect(rules('features/identity/data/x.dart', cond), ['B7']);
      expect(rules('core/http/x.dart', cond), ['B7']);
      expect(
        rules('app/x.dart', "export 'a.dart' if (dart.library.io) 'b.dart';"),
        ['B7'],
      );
      expect(rules('core/api/generated/x.dart', cond), isEmpty);
    });
    test('koşullu import dalı da denetlenir', () {
      expect(
        rules(
          'features/identity/application/a.dart',
          "import 'stub.dart' if (dart.library.io) "
              "'package:nizamio/core/api/generated/models/me_response.dart';",
        ),
        unorderedEquals(['A1', 'B7']),
      );
      expect(
        rules(
          'features/identity/application/a.dart',
          "import '../../../core/errors/api_error.dart' if (dart.library.io) "
              "'../../../core/api/generated/models/me_response.dart';",
        ),
        unorderedEquals(['A1', 'B7']),
      );
    });
    test('part yönergesi de denetlenir', () {
      expect(
        rules(
          'features/identity/application/a.dart',
          "part '../../../core/api/generated/models/me_response.g.dart';",
        ),
        unorderedEquals(['A1', 'B6']),
      );
    });
    test('barrel ile transitif sızma: üretilmiş kod yalnız üretilmiş koddan export', () {
      const exp =
          "export 'package:nizamio/core/api/generated/models/me_response.dart';";
      expect(rules('core/api/models.dart', exp), ['A1']);
      expect(rules('features/identity/data/dtos.dart', exp), ['A1']);
      expect(rules('core/api/generated/export.dart', exp), isEmpty);
    });
    test('core/api dışı core serbest (hata, oturum)', () {
      expect(
        rules(
          'features/identity/application/a.dart',
          "import '../../../core/errors/api_error.dart';",
        ),
        isEmpty,
      );
    });
  });

  group('B6 part tüneli', () {
    test('aynı dizindeki part serbest (.g.dart)', () {
      expect(
        rules('features/identity/application/a.dart', "part 'a.g.dart';"),
        isEmpty,
      );
      expect(
        rules('features/identity/application/a.g.dart', "part of 'a.dart';"),
        isEmpty,
      );
    });
    test('data kütüphanesi + domain parçası (CX-a-Ö-01 tüneli)', () {
      expect(
        rules(
          'features/identity/data/repo.dart',
          "import 'package:nizamio/core/api/generated/models/me_response.dart';\n"
              "part '../domain/leak.dart';",
        ),
        ['B6'],
      );
      expect(
        rules(
          'features/identity/domain/leak.dart',
          "part of '../data/repo.dart';",
        ),
        ['B6'],
      );
    });
    test('kütüphane adıyla part of yasak', () {
      expect(rules('features/identity/domain/a.dart', 'part of x.y;'), ['B6']);
    });
  });

  group('B9 yerel dosya / mutlak URI (Codex 7)', () {
    test('file:, http: ve mutlak yol import/export/part B9 verir', () {
      for (final src in [
        "import 'file:///x/lib/features/identity/data/x.dart';",
        "export 'file:///x/lib/features/identity/data/x.dart';",
        "import 'http://h/x.dart';",
        "import '/abs/lib/core/storage/preference_store.dart';",
        "import '//host/x.dart';",
        "import 'file:///x/lib/core/storage/preference_store.dart';",
        "import 'file:///x/lib/features/identity/identity_module.dart';",
        "import 'file:///x/lib/core/api/generated/models/me_response.dart';",
        "import 'file:///x/get_it/lib/get_it.dart';",
      ]) {
        expect(rules('core/session/a.dart', src), contains('B9'), reason: src);
        expect(
          rules('features/identity/presentation/a.dart', src),
          contains('B9'),
          reason: src,
        );
      }
      expect(
        rules('core/session/a.dart', "part 'file:///x/a.part.dart';"),
        containsAll(['B6', 'B9']),
      );
    });
    test('büyük harfli şema ve ters eğik çizgi B8 verir', () {
      for (final src in [
        "import 'PACKAGE:get_it/get_it.dart';",
        "import 'Package:flutter_secure_storage/flutter_secure_storage.dart';",
        "import 'File:///x.dart';",
        r"import 'package:nizamio\\core\\a.dart';",
      ]) {
        expect(rules('core/session/a.dart', src), contains('B8'), reason: src);
      }
    });
    test('dart:, package: ve göreli URI serbest', () {
      expect(
        rules(
          'core/session/a.dart',
          "import 'dart:async';\nimport 'package:dio/dio.dart';\nimport '../http/b.dart';",
        ),
        isEmpty,
      );
    });
  });

  group('S1/S4 hassas paket export yasağı (Codex 7)', () {
    test('flutter_secure_storage izinli dizinden bile export edilemez', () {
      expect(
        rules(
          'core/storage/barrel.dart',
          "export 'package:flutter_secure_storage/flutter_secure_storage.dart';",
        ),
        ['S1'],
      );
    });
    test('flutter/dio/riverpod export edilemez (domain transitif sızma)', () {
      for (final pkg in [
        'package:flutter/widgets.dart',
        'package:flutter/material.dart',
        'package:dio/dio.dart',
        'package:flutter_riverpod/flutter_riverpod.dart',
        'package:riverpod_annotation/riverpod_annotation.dart',
      ]) {
        for (final path in [
          'core/http/barrel.dart',
          'app/x.dart',
          'features/identity/identity.dart',
          'features/identity/application/a.dart',
        ]) {
          expect(rules(path, "export '$pkg';"), ['S4'], reason: '$path $pkg');
        }
      }
    });
    test('import serbest (yalnız domain katmanı S4)', () {
      expect(
        rules('core/http/a.dart', "import 'package:dio/dio.dart';"),
        isEmpty,
      );
    });
  });

  group('S5/S6 tercih ve firebase yalıtımı', () {
    test('shared_preferences yalnız core/storage', () {
      const sp = "import 'package:shared_preferences/shared_preferences.dart';";
      expect(rules('core/storage/shared_preference_store.dart', sp), isEmpty);
      expect(rules('core/preferences/a.dart', sp), ['S5']);
      expect(rules('core/storage/prefs_facade.dart', sp), ['S5']);
      expect(rules('features/identity/data/a.dart', sp), ['S5']);
      expect(rules('app/bootstrap.dart', sp), ['S5']);
    });
    test('firebase yalnız app ve core/telemetry', () {
      const fb = "import 'package:firebase_core/firebase_core.dart';";
      expect(rules('app/bootstrap.dart', fb), isEmpty);
      expect(rules('core/telemetry/telemetry.dart', fb), isEmpty);
      expect(rules('core/telemetry/a.dart', fb), ['S6']);
      expect(rules('core/http/a.dart', fb), ['S6']);
      expect(
        rules(
          'features/identity/application/a.dart',
          "import 'package:firebase_analytics/firebase_analytics.dart';",
        ),
        ['S6'],
      );
    });
  });

  group('S7 ham tercih deposu ve SDK export', () {
    const raw = "import 'package:nizamio/core/storage/preference_store.dart';";
    test('ham port yalnız AppPreferences, core/storage ve app/di', () {
      expect(rules('core/preferences/app_preferences.dart', raw), isEmpty);
      expect(rules('app/di/dependencies.dart', raw), isEmpty);
      expect(
        rules(
          'core/storage/shared_preference_store.dart',
          "import 'preference_store.dart';",
        ),
        isEmpty,
      );
      expect(rules('core/session/a.dart', raw), ['S7']);
      expect(rules('core/storage/prefs_facade.dart', raw), ['S7']);
      expect(rules('core/preferences/theme_mode_controller.dart', raw), ['S7']);
      expect(
        rules(
          'features/identity/data/a.dart',
          "import '../../../core/storage/shared_preference_store.dart';",
        ),
        ['S7'],
      );
    });
    test('SDK paketleri izinli dizinden bile export edilemez', () {
      expect(
        rules(
          'core/storage/barrel.dart',
          "export 'package:shared_preferences/shared_preferences.dart';",
        ),
        unorderedEquals(['S5', 'S7']),
      );
      expect(
        rules('core/storage/barrel.dart', "export 'preference_store.dart';"),
        ['S7'],
      );
      expect(
        rules(
          'core/storage/barrel.dart',
          "export 'shared_preference_store.dart';",
        ),
        ['S7'],
      );
      expect(
        rules(
          'core/telemetry/barrel.dart',
          "export 'package:firebase_core/firebase_core.dart';",
        ),
        unorderedEquals(['S6', 'S7']),
      );
      expect(
        rules(
          'app/x.dart',
          "export 'package:firebase_analytics/firebase_analytics.dart';",
        ),
        ['S7'],
      );
    });
  });

  group('U1 boşluk standardı Gap', () {
    test('çocuksuz SizedBox (const, constsuz, square, fromSize) yasak', () {
      for (final src in [
        'final w = const SizedBox(height: 8);',
        'final w = SizedBox(width: 8);',
        'final w = SizedBox.square(dimension: 8);',
        'final w = const SizedBox.square(dimension: 8);',
        'final w = const SizedBox.fromSize(size: Size(1, 1));',
        'final w = m.SizedBox(height: 8);',
        'final w = m.SizedBox.square(dimension: 8);',
        'final w = SizedBox.new(height: 8);',
        'final w = const SizedBox.new(height: 8);',
        'typedef Box = SizedBox;',
        'final f = SizedBox.new;',
        'final f = SizedBox.square;',
        'final g = m.SizedBox.new;',
      ]) {
        expect(rules('features/identity/presentation/a.dart', src), [
          'U1',
        ], reason: src);
      }
      expect(rules('app/app.dart', 'final w = SizedBox(height: 4);'), ['U1']);
    });
    test('dosyanın kendi SizedBox sınıfı yanlış pozitif değil', () {
      expect(
        rules(
          'features/identity/presentation/a.dart',
          'class SizedBox { SizedBox({int? height}); }\n'
              'final w = SizedBox(height: 8);',
        ),
        isEmpty,
      );
    });
    test('çocuklu SizedBox, shrink/expand ve Gap serbest', () {
      for (final src in [
        'final w = SizedBox(width: 40, child: Text(""));',
        'final w = const SizedBox.shrink();',
        'final w = const SizedBox.expand();',
        'final w = SizedBox.expand(child: x);',
        'final w = const Gap(8);',
      ]) {
        expect(
          rules('features/identity/presentation/a.dart', src),
          isEmpty,
          reason: src,
        );
      }
    });
  });

  const pres = 'features/x/presentation/a.dart';

  void expectAll(String path, Iterable<String> srcs, String rule) {
    for (final src in srcs) {
      expect(rules(path, src), [rule], reason: src);
    }
  }

  void expectNone(String path, Iterable<String> srcs) {
    for (final src in srcs) {
      expect(rules(path, src), isEmpty, reason: src);
    }
  }

  group('U2 ham renk', () {
    test('tablodaki ve atlatma örnekleri yasak', () {
      expectAll(pres, ['final c = const Color(0xFF112233);'], 'U2');
      expectAll('core/session/b.dart', ['final c = Colors.red;'], 'U2');
      expectAll(pres, [
        'final c = Color(0x1);',
        'final c = Color.fromARGB(255, 0, 0, 0);',
        'final c = const Color.fromRGBO(0, 0, 0, 1);',
        'final c = Color.from(alpha: 1, red: 0, green: 0, blue: 0);',
        'final c = Color.new(1);',
        'final c = CupertinoColors.systemRed;',
        'final c = Colors.red.shade50;',
        "import 'package:flutter/material.dart' as m;\nfinal c = m.Colors.red;",
        'final c = m.Color.fromARGB(255, 0, 0, 0);',
        'final c = m.Color(0x1);',
        'final c = const m.Color(0x1);',
        'typedef C = Color;',
        'typedef C = m.Color;',
        'typedef Cs = Colors;',
        'final f = Color.new;',
        'final f = m.Color.new;',
        'final cs = Colors;',
      ], 'U2');
    });
    test('izinli yollar; app/app.dart artık muaf değil', () {
      const src = 'final c = const Color(0xFF000000); final d = Colors.red;';
      for (final path in [
        'core/ui/theme/app_theme.dart',
        'core/theme/generated/tokens.gen.dart',
        'core/security/privacy_mask.dart',
      ]) {
        expect(rules(path, src), isEmpty, reason: path);
      }
      expect(rules('app/app.dart', src), ['U2', 'U2']);
      // Kesin dosya: komşusu serbest değil.
      expect(rules('core/security/other.dart', src), ['U2', 'U2']);
      expect(
        checkSource('core/ui/theme/a.dart', src, allowances: false),
        hasLength(2),
      );
    });
    test('token erişimi ve renk tipi/yöntemi serbest', () {
      expectNone(pres, [
        'final c = context.colors.textMuted;',
        'Color? c; final d = Color.lerp(a, b, 0.5);',
        'final d = c.withValues(alpha: 0.5);',
        'final colors = <int>[]; final x = colors.length;',
      ]);
    });
  });

  group('U3 ham metin stili', () {
    test('tablodaki ve atlatma örnekleri yasak', () {
      expectAll(pres, [
        'const s = TextStyle(fontSize: 12);',
        'final s = m.TextStyle(fontSize: 12);',
        'final s = TextStyle.new;',
        'final s = TextStyle.new(fontSize: 1);',
        'typedef T = TextStyle;',
        "import 'package:google_fonts/google_fonts.dart';",
        "import 'package:google_fonts/google_fonts.dart' as gf;",
        "export 'package:google_fonts/google_fonts.dart';",
      ], 'U3');
      expectAll('core/ui/widgets/buttons/nz_button.dart', [
        'final s = TextStyle(fontWeight: FontWeight.w600);',
      ], 'U3');
    });
    test('izinli yollar; app/app.dart google_fonts içe aktaramaz', () {
      const style = 'const s = TextStyle(fontSize: 14);';
      const gf = "import 'package:google_fonts/google_fonts.dart';";
      expectNone('core/ui/theme/nz_text_styles.dart', [style, gf]);
      expectNone('app/bootstrap.dart', [gf]);
      expect(rules('app/app.dart', gf), ['U3']);
      expect(rules('app/app.dart', style), ['U3']);
      expect(rules('app/bootstrap.dart', style), ['U3']);
      expect(rules('core/http/a.dart', gf), ['U3']);
      expect(
        checkSource(
          'app/bootstrap.dart',
          gf,
          allowances: false,
        ).map((v) => v.rule),
        ['U3'],
      );
    });
    test('copyWith her yerde serbest', () {
      expectNone(pres, [
        'final s = context.text.titleMd.copyWith(color: context.colors.danger, fontWeight: FontWeight.w700);',
        'final s = TextStyle.lerp(a, b, 0.5);',
      ]);
    });
  });

  group('U4 MediaQuery.of / maybeOf', () {
    test('tablodaki ve atlatma örnekleri yasak', () {
      expectAll(pres, [
        'final s = MediaQuery.of(context).size;',
        'final p = MediaQuery.maybeOf(context)?.padding;',
        'final s = m.MediaQuery.of(context);',
        'final s = m.MediaQuery.maybeOf(context);',
        'final f = MediaQuery.of;',
        'final f = MediaQuery.maybeOf;',
        'final f = m.MediaQuery.of;',
        'typedef M = MediaQuery;',
      ], 'U4');
      expectAll('core/ui/layout/a.dart', ['final s = MediaQuery.of(c);'], 'U4');
      expectAll('app/app.dart', ['final s = MediaQuery.of(c);'], 'U4');
    });
    test('boyut yöntemleri ve sarmalayıcı serbest (pozitif)', () {
      expectNone(pres, [
        'final w = MediaQuery.sizeOf(context).width;',
        'final p = MediaQuery.paddingOf(context);',
        'final i = MediaQuery.viewInsetsOf(context);',
        'final t = MediaQuery.textScalerOf(context);',
        'final s = MediaQuery.maybeSizeOf(context);',
        'final s = MediaQuery.maybePaddingOf(context);',
        'final s = m.MediaQuery.sizeOf(context);',
        'final w = MediaQuery.withClampedTextScaling(child: x);',
        'final w = MediaQuery(data: d, child: x);',
      ]);
    });
  });

  group('U5 tema uzantısı erişimi', () {
    const ext = 'core/ui/extensions/context_ext.dart';
    test('tablodaki ve atlatma örnekleri yasak', () {
      expectAll(pres, [
        'final c = Theme.of(context).extension<NizamioColors>()!;',
        'final t = Theme.of(context); final s = t.extension<NzTextStyles>();',
        'final c = Theme.of(context).extensions[NizamioColors];',
        'final v = Theme.of(context).extensions.values;',
        'final v = theme.extensions;',
        'final f = theme.extension;',
        'final f = Theme.of(context).extension;',
        // Örtük this: ThemeData üzerine yazılmış extension bloğu (hedefsiz çağrı).
        'extension E on ThemeData { X? get x => extension<X>(); }',
      ], 'U5');
      expectAll('core/ui/theme/a.dart', [
        'final c = t.extension<NizamioColors>();',
      ], 'U5');
      expectAll('core/ui/extensions/other_ext.dart', [
        'final c = t.extension<NizamioColors>();',
      ], 'U5');
    });
    test(
      'üretilmiş i18n kodu U5 dışıdır (api/generated ile aynı muafiyet)',
      () {
        expectNone('core/i18n/generated/app_localizations.dart', [
          'final c = Theme.of(context).extension<NizamioColors>();',
          'extension E on ThemeData { X? get x => extension<X>(); }',
        ]);
        expectNone('core/api/generated/x.dart', [
          'final c = Theme.of(context).extension<NizamioColors>();',
        ]);
        expect(
          rules(
            'core/i18n/generated/x.dart',
            "import 'a.dart' if (dart.library.io) 'b.dart';",
          ),
          isEmpty,
        );
      },
    );
    test('izinli tek dosya', () {
      expectNone(ext, [
        'NizamioColors get colors => Theme.of(this).extension<NizamioColors>()!;',
        'final m = Theme.of(this).extensions;',
      ]);
      expect(
        checkSource(
          ext,
          'final c = Theme.of(c).extension<X>();',
          allowances: false,
        ).map((v) => v.rule),
        ['U5'],
      );
    });
    test(
      'ThemeData(extensions: […]) adlandırılmış argüman yanlış pozitif değil',
      () {
        expectNone('app/app.dart', [
          'final t = ThemeData(extensions: [c]);',
          'final t = ThemeData(extensions: <ThemeExtension>[c, d]);',
          'final t = base.copyWith(extensions: [c]);',
        ]);
        expectNone(pres, ['final t = ThemeData(extensions: [c]);']);
      },
    );
  });

  group('U6 sayfa kabuğu', () {
    test('tablodaki ve atlatma örnekleri yasak', () {
      expectAll('features/x/presentation/pages/p.dart', [
        'final w = Scaffold(body: x);',
        'final w = const Scaffold(body: x);',
        'final w = m.Scaffold(body: x);',
        'final w = Scaffold.new(body: x);',
        'final f = Scaffold.new;',
        'typedef S = Scaffold;',
        'class P extends Scaffold { P(); }',
      ], 'U6');
      expectAll('features/x/presentation/widgets/w.dart', [
        'final w = const CupertinoPageScaffold(child: x);',
        'final w = m.CupertinoPageScaffold(child: x);',
        'final f = CupertinoPageScaffold.new;',
        'typedef S = CupertinoPageScaffold;',
      ], 'U6');
    });
    test('presentation dışı ve NzPage serbest', () {
      for (final path in [
        'core/ui/pages/nz_page.dart',
        'app/app.dart',
        'features/x/application/a.dart',
      ]) {
        expectNone(path, ['final w = Scaffold(body: x);']);
      }
      expectNone('features/x/presentation/pages/p.dart', [
        'final w = NzPage(title: t, body: x);',
        'final m = Scaffold.of(context);',
        'final m = ScaffoldMessenger.of(context);',
      ]);
    });
  });

  test('izinler kapalıyken ham ölçüm: U2=55, U3 TextStyle=0, google_fonts=2', () {
    final raw = <Violation>[];
    for (final f in Directory(
      'lib',
    ).listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      raw.addAll(
        checkSource(
          f.path.substring('lib/'.length),
          f.readAsStringSync(),
          allowances: false,
        ),
      );
    }
    int count(String rule) => raw.where((v) => v.rule == rule).length;
    // tokens.gen.dart 54 (21 rol × 2 mod + 12 gölge rengi; ADR-0003 karar 24) +
    // privacy_mask.dart 1.
    expect(
      count('U2'),
      55,
      reason: raw.where((v) => v.rule == 'U2').join('\n'),
    );
    expect(
      raw.where((v) => v.rule == 'U2' && v.path == 'lib/app/app.dart'),
      isEmpty,
    );
    expect(count('U3'), 2, reason: raw.where((v) => v.rule == 'U3').join('\n'));
    // U5: yalnız context_ext.dart (izinli tek dosya) iki `.extension<…>()` çağrısı taşır.
    expect(raw.where((v) => v.rule == 'U5').map((v) => v.path).toSet(), {
      'lib/core/ui/extensions/context_ext.dart',
    });
    expect(count('U4') + count('U6'), 0);
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
