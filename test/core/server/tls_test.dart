// GERÇEK TLS: güvenilmeyen (kendinden imzalı) sertifikalı https sunucusu. Varsayılan dio
// bağdaştırıcısı (platform güven zinciri) kullanılır; badCertificateCallback yoktur.
// Kabul ölçütü: yanlış sertifikalı sunucuya (prod flavor) parola gönderilmez.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/session/session_controller.dart';
import 'package:nizamio/core/session/token_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/identity/identity.dart';

void main() {
  late Directory dir;
  late HttpServer server;
  final seen = <String>[];

  setUpAll(() async {
    dir = await Directory.systemTemp.createTemp('nizamio-tls-');
    final r = await Process.run('openssl', [
      'req',
      '-x509',
      '-newkey',
      'rsa:2048',
      '-nodes',
      '-days',
      '1',
      '-subj',
      '/CN=localhost',
      '-addext',
      'subjectAltName=DNS:localhost,IP:127.0.0.1',
      '-keyout',
      '${dir.path}/key.pem',
      '-out',
      '${dir.path}/cert.pem',
    ]);
    expect(r.exitCode, 0, reason: '${r.stderr}');
    final ctx = SecurityContext()
      ..useCertificateChain('${dir.path}/cert.pem')
      ..usePrivateKey('${dir.path}/key.pem');
    server = await HttpServer.bindSecure(InternetAddress.loopbackIPv4, 0, ctx);
    server.listen((req) async {
      seen.add('${req.method} ${req.uri.path}');
      req.response
        ..statusCode = 200
        ..headers.contentType = ContentType.json
        ..write('{}');
      await req.response.close();
    }, onError: (Object _) {});
  });

  tearDownAll(() async {
    await server.close(force: true);
    await dir.delete(recursive: true);
  });

  test('güvenilmeyen sertifika → client.tls_error; hiçbir HTTP isteği ve parola gitmez', () async {
    final store = MemorySecureStore();
    final binding = ServerBindingController(flavor: Flavor.prod, store: store);
    final state = await binding.verify('https://localhost:${server.port}');
    expect(state, isA<BindingFailed>());
    expect((state as BindingFailed).error.code, ClientErrorCode.tlsError);

    final session = SessionController(
      TokenStore(store),
      (_, _) => throw StateError('yok'),
    );
    final identity = IdentityService(
      binding: binding,
      session: session,
      repository: () => null,
    );
    await expectLater(
      identity.login(email: 'a@b.test', password: 'Gizli-Parola-1'),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          ClientErrorCode.serverNotVerified,
        ),
      ),
    );
    expect(
      seen,
      isEmpty,
      reason: 'TLS el sıkışması düştü; istek (ve parola) sunucuya ulaşmadı',
    );
    expect(store.values, isEmpty);
  });
}
