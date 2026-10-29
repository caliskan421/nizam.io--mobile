// Üretilmiş çıktıların içerik sözleşmesi: TR metin tamlığı (F14 kapsam 7), kapsam sınıfı
// haritası (kapsam 3/6), token tema uzantısı (kapsam 8), uygulama sürümü.
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/api/api_meta.dart';
import 'package:nizamio/core/api/generated/error_catalog.gen.dart';
import 'package:nizamio/core/api/generated/operations.gen.dart';
import 'package:nizamio/core/config/generated/app_version.gen.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/i18n/generated/error_messages.gen.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:yaml/yaml.dart';

void main() {
  final tr = lookupAppLocalizations(const Locale('tr'));

  group('TR hata metinleri (error-codes.json → ARB)', () {
    final serverCodes = <String>{
      for (final MapEntry(:key, :value) in errorCatalog.entries) ...[
        key,
        ...value.fields,
      ],
    };

    test('katalogdaki her zarf kodu ve her alan kodu için TR metin var', () {
      final missing = serverCodes
          .where((c) => localizedErrorText(tr, c) == null)
          .toList();
      expect(missing, isEmpty);
    });

    test('her istemci kodu için TR metin var', () {
      for (final c in ClientErrorCode.all) {
        expect(localizedErrorText(tr, c), isNotNull, reason: c);
      }
    });

    test('metinli kod kümesi = katalog ∪ alan kodları ∪ istemci kodları (eksik/fazla yok)', () {
      expect(localizedErrorCodes, {...serverCodes, ...ClientErrorCode.all});
    });

    test('her metin dolu; ICU özel karakteri yok', () {
      for (final c in localizedErrorCodes) {
        final text = localizedErrorText(tr, c)!;
        expect(text.trim(), isNotEmpty, reason: c);
        expect(text, isNot(contains('{')), reason: c);
      }
    });

    test('her kataloğun message_key\'i errors.<kod>', () {
      for (final MapEntry(:key, :value) in errorCatalog.entries) {
        expect(value.messageKey, 'errors.$key');
      }
    });

    test('metin web ile aynı kaynaktan (örnek)', () {
      expect(
        localizedErrorText(tr, 'identity.credentials_invalid'),
        'E-posta veya parola hatalı.',
      );
    });

    test('bilinmeyen kod null döner', () {
      expect(localizedErrorText(tr, 'yeni.kod'), isNull);
    });
  });

  group('operasyon → kapsam sınıfı haritası (spec\'ten)', () {
    test('v0.2.0-api: 140 işlem; API sürümü v1', () {
      expect(apiOperations, hasLength(140));
      expect(apiVersion, 'v1');
    });

    test('kapsam sınıfı ve başlık bayrakları tutarlı', () {
      for (final op in apiOperations.values) {
        expect(
          op.programHeader,
          op.scope == ScopeClass.s2 || op.scope == ScopeClass.s3,
          reason: op.operationId,
        );
        expect(
          op.departmentHeader,
          op.scope == ScopeClass.s3,
          reason: op.operationId,
        );
        // Belgeli istisna: akışlı multipart yükleme CSRF istemez (tool/gen/sources.dart).
        if (op.operationId != 'attachFile') {
          expect(op.csrf, op.method != 'GET', reason: op.operationId);
        }
        expect(op.auth, op.scope != ScopeClass.s0, reason: op.operationId);
      }
    });

    test('örnekler', () {
      expect(apiOperations['readProgram']!.scope, ScopeClass.s2);
      expect(apiOperations['login']!.auth, isFalse);
      expect(apiOperations['me']!.scope, ScopeClass.s1);
      expect(apiOperations['refresh']!.csrf, isTrue);
    });

    test(
      'üretilmiş istemcilerdeki her operationId haritada (ara katman tanır)',
      () {
        final ids = <String>{};
        for (final f in Directory(
          'lib/core/api/generated/clients',
        ).listSync().whereType<File>()) {
          if (!f.path.endsWith('_client.dart')) continue;
          ids.addAll(
            RegExp(r"""'operationId': ["'](\w+)["']""")
                .allMatches(f.readAsStringSync())
                .map((m) => m.group(1)!),
          );
        }
        expect(ids, apiOperations.keys.toSet());
      },
    );
  });

  group('tasarım token\'ları', () {
    test('roller tasarım kaynağından ARGB olarak çözülmüş', () {
      // accent (#c8f53c) iki modda aynı; scrim CSS #16161566 → ARGB 0x66161615.
      expect(NizamioColors.light.primary, const Color(0xFFC8F53C));
      expect(NizamioColors.dark.primary, NizamioColors.light.primary);
      expect(NizamioColors.light.scrim, const Color(0x66161615));
      expect(NizamioColors.dark.scrim, const Color(0x8C000000));
    });
    test('ThemeExtension lerp/copyWith', () {
      final mid = NizamioColors.light.lerp(NizamioColors.dark, 1);
      expect(mid.background, NizamioColors.dark.background);
      expect(
        NizamioColors.light
            .copyWith(primary: NizamioColors.dark.danger)
            .primary,
        NizamioColors.dark.danger,
      );
      expect(
        NizamioShadows.light.lerp(NizamioShadows.dark, 1).sheet,
        NizamioShadows.dark.sheet,
      );
    });
  });

  test('uygulama sürümü pubspec ile aynı', () {
    final v =
        (loadYaml(File('pubspec.yaml').readAsStringSync())
                as YamlMap)['version']
            as String;
    expect(appVersion, v.split('+').first);
  });
}
