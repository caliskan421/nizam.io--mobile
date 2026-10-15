// Pilot dikey dilim — gerçek backend'e karşı tek akış (MOB-UI-0 A7, W41): sunucu bağlama →
// giriş (yönetici) → program yoksa yönetici API'siyle program oluşturma → servis üzerinden
// program listesi → seçim → S2 readProgram (kapsam başlığı sunucuda çözülür; doğru program) →
// çıkış. Ekran katmanı widget testlerinde (test/features) sınanır; burada ekranların kullandığı
// zincir (controller'ların çağırdığı servisler → repository → üretilmiş istemci → gerçek HTTP)
// gerçek sunucuyla koşar.
//
// Ortam değişkenleri backend_test.dart ile aynıdır (NIZAMIO_IT_BACKEND, NIZAMIO_IT_ADMIN_EMAIL,
// NIZAMIO_IT_ADMIN_PASSWORD; aynı varsayılanlar). Yönetici parolası DEĞİŞTİRİLMEZ (diğer
// testler kullanır); zorunlu parola değişikliği yolu tohumda olmadığından birim/widget
// testlerinde kanıtlanır. Testler SIRALIDIR (`--concurrency=1`).
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/api/generated/clients/program_client.dart';
import 'package:nizamio/core/api/generated/models/create_program_request.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/logging/log.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/session/token_store.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/identity/identity.dart';
import 'package:nizamio/features/scope/scope.dart';

import 'support/proxy.dart';
import 'support/raw_http.dart';

final _env = Platform.environment;
final _backend = Uri.parse(
  _env['NIZAMIO_IT_BACKEND'] ?? 'http://127.0.0.1:18140',
);
final _adminEmail =
    _env['NIZAMIO_IT_ADMIN_EMAIL'] ?? 'yonetici@f14.nizamio.test';
final _adminPassword =
    _env['NIZAMIO_IT_ADMIN_PASSWORD'] ?? 'F14-Yonetici-Parola-2026';

void main() {
  final logs = <String>[];
  setUpAll(() async {
    Log.sink = logs.add;
    final ready = await rawRequest(
      'GET',
      _backend.replace(path: '/healthz/ready'),
    );
    expect(
      ready.status,
      200,
      reason: 'backend hazır değil: $_backend (make integration)',
    );
  });
  tearDownAll(Log.resetSink);

  test(
    'bağ → giriş → program oluştur → liste → seçim → S2 readProgram → çıkış',
    () async {
      final proxy = await CountingProxy.start(_backend);
      addTearDown(proxy.close);
      final store = MemorySecureStore();
      final composition = Composition.create(
        flavor: Flavor.dev,
        secureStore: store,
        preferenceStore: MemoryPreferenceStore(),
      );
      addTearDown(composition.dispose);
      final ProviderContainer c = composition.container;

      // 1. Sunucu bağlama (ServerConnectController'ın çağırdığı core doğrulaması).
      final binding = await c
          .read(serverBindingProvider)
          .verify(proxy.url.toString());
      expect(binding, isA<BindingVerified>());
      expect(c.read(appPhaseProvider), AppPhase.serverVerified);

      // 2. Giriş (LoginController → IdentityService.login).
      await c
          .read(identityServiceProvider)
          .login(email: _adminEmail, password: _adminPassword);
      expect(c.read(sessionStateProvider), isA<SessionActive>());
      expect(
        (c.read(sessionStateProvider) as SessionActive).forcePasswordChange,
        isFalse,
        reason: 'tohum yöneticisi zorunlu parola değişikliği istemez',
      );
      expect(c.read(appPhaseProvider), AppPhase.sessionOpen);

      // 3. Test kurulumu: benzersiz adlı program (S1 createProgram, yönetici API'si).
      final name = 'Pilot ${DateTime.now().microsecondsSinceEpoch}';
      final created = await ProgramClient(c.read(apiDioProvider)!)
          .createProgram(body: CreateProgramRequest(name: name, year: 2026));
      expect(created.created, isTrue);

      // 4. Program listesi (ProgramListController → ScopeService.programs).
      final scope = c.read(scopeServiceProvider);
      final slice = await scope.programs();
      final listed = slice.items.where((p) => p.id == created.programId);
      expect(listed, hasLength(1), reason: 'oluşturulan program listede');
      expect(listed.single.name, name);
      expect(
        proxy.count('GET', '/v1/programs'),
        1,
        reason: 'liste isteği gerçek sunucuya gitti',
      );

      // 5. Seçim → faz scoped.
      scope.select(created.programId);
      expect(c.read(scopeStateProvider).programId, created.programId);
      expect(c.read(appPhaseProvider), AppPhase.scoped);

      // 6. S2 readProgram: sunucu X-Nizamio-Program başlığından programı çözer → doğru program.
      final current = await scope.currentProgram();
      expect(current.id, created.programId);
      expect(current.name, name);
      expect(current.year, 2026);
      expect(proxy.count('GET', '/v1/program'), 1);

      // 7. Kapsamı değiştir → sessionOpen; seçim yokken S2 isteği ağa ÇIKMAZ.
      scope.clearSelection();
      expect(c.read(appPhaseProvider), AppPhase.sessionOpen);
      await expectLater(
        scope.currentProgram(),
        throwsA(
          predicate((e) => e.toString().contains('client.scope_missing')),
        ),
      );
      expect(proxy.count('GET', '/v1/program'), 1, reason: 'ikinci istek yok');

      // 8. Çıkış (LogoutController → IdentityService.logout): oturum ve kapsam temizlenir.
      scope.select(created.programId);
      await c.read(identityServiceProvider).logout();
      expect(proxy.count('POST', '/v1/auth/logout'), 1);
      expect(c.read(sessionStateProvider), isA<SessionNone>());
      expect(c.read(scopeStateProvider).hasProgram, isFalse);
      expect(c.read(appPhaseProvider), AppPhase.serverVerified);
      expect(await TokenStore(store).load(), isNull);

      // Parola ve belirteçler log'a / vekil gövdelerine sızmadı (parola yalnız giriş gövdesinde).
      expect(logs.join('\n'), isNot(contains(_adminPassword)));
      expect(
        proxy.bodies.where((b) => b.contains(_adminPassword)),
        hasLength(1),
        reason: 'parola yalnız giriş isteğinin gövdesinde',
      );
    },
  );
}
