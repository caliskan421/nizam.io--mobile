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

  group('S5/S6 tercih ve firebase yalıtımı', () {
    test('shared_preferences yalnız core/storage', () {
      const sp = "import 'package:shared_preferences/shared_preferences.dart';";
      expect(rules('core/storage/shared_preference_store.dart', sp), isEmpty);
      expect(rules('core/preferences/a.dart', sp), ['S5']);
      expect(rules('features/identity/data/a.dart', sp), ['S5']);
      expect(rules('app/bootstrap.dart', sp), ['S5']);
    });
    test('firebase yalnız app ve core/telemetry', () {
      const fb = "import 'package:firebase_core/firebase_core.dart';";
      expect(rules('app/bootstrap.dart', fb), isEmpty);
      expect(rules('core/telemetry/a.dart', fb), isEmpty);
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
        ['S7'],
      );
      expect(
        rules(
          'core/telemetry/barrel.dart',
          "export 'package:firebase_core/firebase_core.dart';",
        ),
        ['S7'],
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
