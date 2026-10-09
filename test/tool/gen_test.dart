// tool/gen/sources.dart: üretim kaynaklarının katı okunması (negatif durumlar).
import 'package:flutter_test/flutter_test.dart';

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

  group('resolveTokens', () {
    const base = '''
{"version": 1, "palette": {"primary": {"600": "#1f4e79"}},
 "modes": {"light": {"primary": "{primary.600}"}, "dark": {"primary": "PLACEHOLDER"}},
 "typography": {"fontFamily": {"sans": ["Inter"]}, "fontSize": {"md": 16},
   "fontWeight": {"regular": 400}, "lineHeight": {"normal": 1.5}},
 "spacing": {"1": 4}, "radius": {"sm": 4}}''';
    test('başvuru çözülür', () {
      final t = resolveTokens(
        base.replaceFirst('PLACEHOLDER', '{primary.600}'),
      );
      expect(t.light['primary'], '#1f4e79');
    });
    test('çözülemeyen başvuru düşer', () {
      expect(
        () => resolveTokens(base.replaceFirst('PLACEHOLDER', '{primary.700}')),
        throwsFormatException,
      );
    });
    test('hex olmayan palet değeri düşer', () {
      expect(
        () => resolveTokens(
          base
              .replaceFirst('#1f4e79', 'blue')
              .replaceFirst('PLACEHOLDER', '{primary.600}'),
        ),
        throwsFormatException,
      );
    });
  });

  test('appVersionFromPubspec', () {
    expect(appVersionFromPubspec('name: x\nversion: 1.2.3+4\n'), '1.2.3');
    expect(
      () => appVersionFromPubspec('version: 1.2\n'),
      throwsFormatException,
    );
  });
}
