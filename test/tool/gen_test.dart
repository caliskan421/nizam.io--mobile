// tool/gen/sources.dart: üretim kaynaklarının katı okunması (negatif durumlar).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/api/generated/models/change_password_request.dart';
import 'package:nizamio/core/api/generated/models/delete_program_request.dart';
import 'package:nizamio/core/api/generated/models/login_request.dart';
import 'package:nizamio/core/api/generated/models/login_response.dart';
import 'package:nizamio/core/api/generated/models/refresh_request.dart';
import 'package:nizamio/core/api/generated/models/refresh_response.dart';

import '../../tool/gen/sensitive.dart';
import '../../tool/gen/sources.dart';

const _catalogJson = '''
{"catalog_version": 1, "codes": {
  "identity.credentials_invalid": {"status": 401, "fields": [], "message_key": "errors.identity.credentials_invalid"},
  "identity.input_invalid": {"status": 422, "fields": ["identity.email_invalid"], "message_key": "errors.identity.input_invalid"},
  "records.content_rejected": {"status": [422, 500], "fields": [], "message_key": "errors.records.content_rejected"}
}}''';

String _web(String body) =>
    '// başlık\nexport const trErrors: Record<string, string> = {\n$body\n}\n';

void main() {
  group('parseCatalog', () {
    test('durum dizisi ve alan kodları', () {
      final c = parseCatalog(_catalogJson);
      expect(c.version, 1);
      expect(c.entries.last.statuses, [422, 500]);
      expect(c.allCodes, contains('identity.email_invalid'));
    });
    test('message_key errors.<kod> değilse düşer', () {
      expect(
        () => parseCatalog(
          '{"catalog_version":1,"codes":{"a.b":{"status":400,"fields":[],"message_key":"x"}}}',
        ),
        throwsFormatException,
      );
    });
  });

  group('parseWebTrErrors (katı)', () {
    test('tek ve çok satırlı girdiler, yorumlar, kaçışlı tırnak', () {
      final m = parseWebTrErrors(
        _web(
          "  // identity\n  'identity.a': 'Bir.',\n  'identity.b':\n    'Program\\'a iki.',",
        ),
      );
      expect(m, {'identity.a': 'Bir.', 'identity.b': "Program'a iki."});
    });
    test('tanınmayan içerik düşer (biçim değişti)', () {
      expect(
        () => parseWebTrErrors(_web("  'identity.a': 'Bir.',\n  ...other,")),
        throwsFormatException,
      );
    });
    test('çift tırnaklı girdi tanınmaz → düşer', () {
      expect(
        () => parseWebTrErrors(_web('  "identity.a": "Bir.",')),
        throwsFormatException,
      );
    });
    test('yinelenen kod düşer', () {
      expect(
        () => parseWebTrErrors(_web("  'a.b': 'x',\n  'a.b': 'y',")),
        throwsFormatException,
      );
    });
    test('bildirim yoksa düşer', () {
      expect(() => parseWebTrErrors('const x = {}'), throwsFormatException);
    });
  });

  group('buildTrMessages', () {
    final catalog = parseCatalog(_catalogJson);
    final web = {
      'identity.credentials_invalid': 'E-posta veya parola hatalı.',
      'identity.input_invalid': 'Geçersiz.',
      'identity.email_invalid': 'E-posta geçersiz.',
      'records.content_rejected': 'Reddedildi.',
      'client.network_error': 'web istemci metni — alınmaz',
    };
    test('sunucu kodları web metninden, istemci kodları mobil dosyasından', () {
      final m = buildTrMessages(catalog, web, {'client.tls_error': 'TLS.'});
      expect(m['identity.email_invalid'], 'E-posta geçersiz.');
      expect(m['client.tls_error'], 'TLS.');
      expect(m.containsKey('client.network_error'), isFalse);
    });
    test('alan kodunun metni eksikse düşer', () {
      final eksik = Map.of(web)..remove('identity.email_invalid');
      expect(() => buildTrMessages(catalog, eksik, {}), throwsFormatException);
    });
    test('ICU özel karakteri düşer', () {
      expect(
        () => buildTrMessages(catalog, web, {'client.x': 'Değer {n}'}),
        throwsFormatException,
      );
    });
    test('ARB anahtar çakışması düşer', () {
      expect(
        arbKey('identity.credentials_invalid'),
        'errIdentityCredentialsInvalid',
      );
      expect(
        () => buildTrMessages(catalog, web, {
          'client.a_b': 'x',
          'client.a.b': 'y',
        }),
        throwsFormatException,
      );
    });
  });

  group('parseClientErrors', () {
    test('client. öneki zorunlu', () {
      expect(
        () => parseClientErrors('{"codes": {"network_error": "x"}}'),
        throwsFormatException,
      );
    });
  });

  group('summarizeSpec tutarlılık', () {
    String spec(String op) =>
        '''
openapi: 3.0.3
info: {title: t, version: v1}
paths:
  /v1/x:
$op
''';
    test('S2 + program başlığı + yazma CSRF geçer', () {
      final s = summarizeSpec(
        spec('''
    post:
      operationId: x
      x-nizamio-scope-class: S2
      parameters:
        - \$ref: '#/components/parameters/CsrfHeader'
        - \$ref: '#/components/parameters/ProgramScope'
'''),
      );
      expect(s.apiVersion, 'v1');
      expect(s.operations.single.programHeader, isTrue);
      expect(s.operations.single.auth, isTrue);
    });
    test('S2 ama program başlığı yok → düşer', () {
      expect(
        () => summarizeSpec(
          spec('''
    get:
      operationId: x
      x-nizamio-scope-class: S2
'''),
        ),
        throwsFormatException,
      );
    });
    test('yazma ama CSRF yok → düşer', () {
      expect(
        () => summarizeSpec(
          spec('''
    post:
      operationId: x
      x-nizamio-scope-class: S1
'''),
        ),
        throwsFormatException,
      );
    });
    test('kapsam sınıfı yok → düşer', () {
      expect(
        () => summarizeSpec(spec('    get:\n      operationId: x\n')),
        throwsFormatException,
      );
    });
  });

  group('resolveTokens (tasarım + mobil eşleme)', () {
    // Negatifler doğru nedenle düşmeli (bozuk JSON da FormatException'dır).
    Matcher fails(String part) => throwsA(
      isA<FormatException>().having(
        (e) => e.message,
        'message',
        contains(part),
      ),
    );
    String design({
      String colors =
          '{"name": "bg-base", "value": {"dark": "#0b0b0b", "light": "#f6f6f3"}},'
          '{"name": "scrim", "value": {"dark": "#0000008c", "light": "#16161566"}},'
          '{"name": "glass", "value": {"dark": "rgba(11, 11, 11, 0.78)", "light": "rgba(255,255,255,1)"}},'
          '{"name": "other", "value": {"dark": "{bg-base}", "light": "{bg-base}"}}',
      String letterSpacing = '"-0.015em"',
      String shadow = '{"dark": "0 12px 32px rgba(0,0,0,0.45)", "light": "-24px 0 60px rgba(22,22,21,0.14)"}',
    }) =>
        '''
{"version": 1,
 "color": {"themes": [{"id": "dark"}, {"id": "light"}], "tokens": [$colors]},
 "type": {"families": {"sans": "\\"Inter\\", system-ui", "mono": "\\"Geist Mono\\", monospace"},
   "groups": [{"name": "D", "family": "sans", "styles": [
     {"name": "m-h1-detail", "fontSize": "24px", "lineHeight": "30px", "fontWeight": 600, "letterSpacing": $letterSpacing}]}]},
 "spacing": {"tokens": [{"name": "m-gap-xs", "value": "4px"}]},
 "radius": {"tokens": [{"name": "m-r-card", "value": "20px"}]},
 "shadow": {"tokens": [{"name": "m-sh-float", "value": $shadow}, {"name": "m-sh-knob", "value": "0 1px 3px rgba(0,0,0,0.35)"}]},
 "size": {"tokens": [{"name": "m-tap", "value": "44px"}]},
 "blur": {"tokens": [{"name": "m-blur-bar", "value": "18px"}]}}''';
    String mobile({
      String colors = '"background": "bg-base", "scrim": "scrim", "glass": "glass", "other": "other"',
    }) =>
        '''
{"version": 1, "source": {"path": "x", "blob": "x"}, "colors": {$colors},
 "spacingScale": {"\$comment": "x", "1": 4}, "metrics": {"iconSize": 20}}''';

    test('roller çözülür; CSS #RRGGBBAA ve rgba() ARGB sırasına çevrilir', () {
      final t = resolveTokens(design(), mobile());
      expect(t.roles, ['background', 'scrim', 'glass', 'other']);
      expect(t.light['background'], 0xFFF6F6F3);
      expect(t.dark['scrim'], 0x8C000000);
      expect(t.light['scrim'], 0x66161615);
      expect(t.dark['glass'], 0xC70B0B0B);
      expect(t.light['glass'], 0xFFFFFFFF);
      expect(t.dark['other'], t.dark['background']);
    });
    test('tipografi, ölçüler ve gölgeler kaynak birimleriyle okunur', () {
      final t = resolveTokens(design(), mobile());
      expect(t.families['mono'], ['Geist Mono', 'monospace']);
      final h = t.typeStyles['h1Detail']!;
      expect((h.family, h.size, h.lineHeight, h.weight), ('sans', 24, 30, 600));
      expect(h.letterSpacingEm, -0.015);
      expect(t.spacing, {'gapXs': 4});
      expect(t.radius, {'card': 20});
      expect(t.size, {'tap': 44});
      expect(t.blur, {'bar': 18});
      expect(t.spacingScale, {'1': 4});
      expect(t.metrics, {'iconSize': 20});
      final f = t.shadowsLight['float']!;
      expect(
        (f.dx, f.dy, f.blur, f.spread, f.argb),
        (-24, 0, 60, 0, 0x24161615),
      );
      expect(t.shadowsDark['knob']!.argb, t.shadowsLight['knob']!.argb);
    });
    test('tasarımda olmayan token\'a eşleme düşer', () {
      expect(
        () => resolveTokens(design(), mobile(colors: '"text": "ink"')),
        fails('tasarımda olmayan token'),
      );
    });
    test('desteklenmeyen renk biçimi düşer (hsl, kısa hex)', () {
      for (final (v, why) in [
        ('hsl(0, 0%, 0%)', 'desteklenmeyen renk'),
        ('#fff', 'desteklenmeyen renk'),
        ('rgba(300,0,0,1)', '255 üstü'),
      ]) {
        expect(
          () => resolveTokens(
            design(colors: '{"name": "bg-base", "value": "$v"}'),
            mobile(colors: '"background": "bg-base"'),
          ),
          fails(why),
          reason: v,
        );
      }
    });
    test('tek temada tanımlı renk ve döngülü başvuru düşer', () {
      expect(
        () => resolveTokens(
          design(colors: '{"name": "bg-base", "value": {"dark": "#000000"}}'),
          mobile(colors: '"background": "bg-base"'),
        ),
        fails('iki temada'),
      );
      expect(
        () => resolveTokens(
          design(
            colors:
                '{"name": "a", "value": "{b}"}, {"name": "b", "value": "{a}"}',
          ),
          mobile(colors: '"x": "a"'),
        ),
        fails('döngülü'),
      );
    });
    test('em olmayan harf aralığı ve px olmayan gölge düşer', () {
      expect(
        () => resolveTokens(design(letterSpacing: '"-0.2px"'), mobile()),
        fails('em değil'),
      );
      expect(
        () => resolveTokens(design(shadow: '"0 12rem 32px #000000"'), mobile()),
        fails('gölge değil'),
      );
    });
    test('mobil metrics tasarım size adıyla çakışırsa düşer', () {
      expect(
        () => resolveTokens(
          design(),
          mobile().replaceFirst('"iconSize": 20', '"tap": 48'),
        ),
        fails('çakışıyor'),
      );
    });
    test('tokenIdent önek atar, kebab → camel', () {
      expect(tokenIdent('m-gap-xs'), 'gapXs');
      expect(tokenIdent('m-r-bubble-tail', 'm-r-'), 'bubbleTail');
      expect(() => tokenIdent('gap-xs'), throwsFormatException);
    });
    test('depodaki kaynaklar çözülür; pin blob tasarım dosyasıyla aynı', () {
      final mobileText = File('design/mobile-tokens.json').readAsStringSync();
      final src =
          (jsonDecode(mobileText) as Map<String, Object?>)['source']!
              as Map<String, Object?>;
      final path = src['path']! as String;
      final t = resolveTokens(File(path).readAsStringSync(), mobileText);
      expect(t.light.keys, t.dark.keys);
      final blob = Process.runSync('git', ['hash-object', '--', path]);
      expect((blob.stdout as String).trim(), src['blob']);
    });
  });

  test('appVersionFromPubspec', () {
    expect(appVersionFromPubspec('name: x\nversion: 1.2.3+4\n'), '1.2.3');
    expect(
      () => appVersionFromPubspec('version: 1.2\n'),
      throwsFormatException,
    );
  });

  group('UI metin kaynağı', () {
    String file(String body) => '{"texts": {$body}}';
    test('geçerli dosyalar birleşir; ARB anahtarı camelCase', () {
      final ui = parseUiTexts({
        'common.tr.json': file('"ui.common.retry": "Yeniden dene"'),
        'auth.tr.json': file('"ui.auth.sign_in": "Giriş"'),
      });
      expect(ui, {
        'ui.auth.sign_in': 'Giriş',
        'ui.common.retry': 'Yeniden dene',
      });
      expect(arbKey('ui.common.retry'), 'uiCommonRetry');
      expect(arbKey('ui.auth.sign_in'), 'uiAuthSignIn');
      final arb = buildArb({}, 'x', ui);
      expect(arb, contains('"uiCommonRetry": "Yeniden dene"'));
    });
    test('dosya adı ile önek uyuşmazlığı düşer', () {
      expect(
        () => parseUiTexts({'auth.tr.json': file('"ui.common.retry": "x"')}),
        throwsFormatException,
      );
    });
    test('geçersiz dosya adı düşer', () {
      expect(
        () => parseUiTexts({'Auth.json': file('"ui.auth.a": "x"')}),
        throwsFormatException,
      );
    });
    test('yinelenen anahtar düşer', () {
      expect(
        () => parseUiTexts({
          'common.tr.json': file('"ui.common.a": "x", "ui.common.a": "y"'),
        }),
        throwsFormatException,
      );
    });
    test('ARB anahtar çakışması düşer', () {
      expect(
        () => parseUiTexts({
          'common.tr.json': file('"ui.common.a_b": "x", "ui.common.a.b": "y"'),
        }),
        throwsFormatException,
      );
    });
    test('boş metin ve ICU karakteri düşer', () {
      expect(
        () => parseUiTexts({'common.tr.json': file('"ui.common.a": " "')}),
        throwsFormatException,
      );
      expect(
        () => parseUiTexts({'common.tr.json': file('"ui.common.a": "{n}"')}),
        throwsFormatException,
      );
    });
    test('hata kodu / ARB anahtarı çakışması düşer', () {
      final ui = {'ui.common.retry': 'x'};
      expect(
        () => checkUiAgainstErrors(ui, ['client.timeout']),
        returnsNormally,
      );
      expect(
        () => checkUiAgainstErrors(ui, ['ui.common.retry']),
        throwsFormatException,
      );
      expect(
        () => checkUiAgainstErrors(ui, ['ui.other.x']),
        throwsFormatException,
      );
    });
  });

  group('gizli alanlı DTO\'lar (CX-W51-4): toString değer sızdırmaz', () {
    const secret = 'SIR-DEGER-9f3a';

    test('gerçek DTO örnekleri parola/belirteç yazmaz', () {
      final samples = <Object>[
        const LoginRequest(
          email: 'a@b.test',
          password: secret,
          captchaToken: secret,
        ),
        const ChangePasswordRequest(
          currentPassword: secret,
          newPassword: '$secret-yeni',
        ),
        const DeleteProgramRequest(password: secret),
        const RefreshRequest(refreshToken: secret),
        const LoginResponse(
          accountId: 'acc-1',
          expiresAt: 1,
          forcePasswordChange: false,
          token: secret,
          accessToken: secret,
          refreshToken: secret,
        ),
        const RefreshResponse(
          accountId: 'acc-1',
          expiresAt: 1,
          refreshExpiresAt: 2,
          token: secret,
          accessToken: secret,
          refreshToken: secret,
        ),
      ];
      for (final dto in samples) {
        expect('$dto', isNot(contains(secret)), reason: '${dto.runtimeType}');
        expect('$dto', isNot(contains('SIR-')), reason: '${dto.runtimeType}');
      }
    });

    test('üretilmiş modellerde String parola/belirteç/sır alanı olan HER model maskeli', () {
      final dir = Directory('lib/core/api/generated/models');
      var sensitive = 0;
      for (final f in dir.listSync().whereType<File>().where(
        (f) =>
            f.path.endsWith('.dart') &&
            !f.path.endsWith('.g.dart') &&
            !f.path.endsWith('.freezed.dart'),
      )) {
        final src = f.readAsStringSync();
        if (!hasSensitiveFields(src)) continue;
        sensitive++;
        final freezed = File(
          f.path.replaceFirst(RegExp(r'\.dart$'), '.freezed.dart'),
        ).readAsStringSync();
        expect(
          src,
          contains('@Freezed(toStringOverride: false)'),
          reason: f.path,
        );
        expect(freezed, isNot(contains('String toString()')), reason: f.path);
      }
      expect(
        sensitive,
        6,
        reason: 'hassas model kümesi değişti: listeyi bilerek güncelleyin',
      );
    });
  });

  group('maskSensitiveModels (tool/gen/sensitive.dart)', () {
    String model(String body, {String ann = '@Freezed()'}) =>
        '''
$ann
abstract class M with _\$M {
  const factory M({
$body
  }) = _M;
}
''';

    test(
      'alan adı kuralı: yalnız String alanlar; bool bayrak hassas değil',
      () {
        expect(
          hasSensitiveFields(
            model("@JsonKey(name: 'x') required String currentPassword,"),
          ),
          isTrue,
        );
        expect(hasSensitiveFields(model('String? accessToken,')), isTrue);
        expect(
          hasSensitiveFields(model('required String clientSecret,')),
          isTrue,
        );
        expect(
          hasSensitiveFields(model('required bool forcePasswordChange,')),
          isFalse,
        );
        expect(hasSensitiveFields(model('bool? resetPassword,')), isFalse);
        expect(hasSensitiveFields(model('required String email,')), isFalse);
      },
    );

    test(
      'hassas model @Freezed(toStringOverride: false) olur; diğeri aynen kalır',
      () {
        final masked = maskSensitiveModels(model('required String password,'));
        expect(masked, contains('@Freezed(toStringOverride: false)'));
        expect(masked, isNot(contains('@Freezed()')));
        final plain = model('required String email,');
        expect(maskSensitiveModels(plain), plain);
      },
    );

    test('hassas modelde beklenen @Freezed() yoksa düşer (fail-closed)', () {
      expect(
        () => maskSensitiveModels(
          model('required String password,', ann: '@freezed'),
        ),
        throwsStateError,
      );
    });

    test('maskeleme idempotent', () {
      final once = maskSensitiveModels(model('required String password,'));
      expect(maskSensitiveModels(once), once);
    });
  });
}
