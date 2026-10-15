// LogoutController: çıkış sonrası oturum kapanır (sunucu çıkışı başarısız olsa da).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/identity/application/logout_controller.dart';

import '../../../support/fake_backend.dart';
import '../../pilot_support.dart';

void main() {
  test('çıkış: oturum kapanır, faz serverVerified', () async {
    final h = await pilotHarness(PilotBackend(), signedIn: true);
    h.container.listen(logoutControllerProvider, (_, _) {});
    await h.container.read(logoutControllerProvider.notifier).signOut();
    expect(h.read(logoutControllerProvider).hasError, isFalse);
    expect(h.read(appPhaseProvider), AppPhase.serverVerified);
    expect(h.backend.count('POST', '/v1/auth/logout'), 1);
  });

  test('sunucu çıkışı düşse de yerel oturum kapanır', () async {
    final backend = PilotBackend();
    final h = await pilotHarness(backend, signedIn: true);
    h.container.listen(logoutControllerProvider, (_, _) {});
    h.backend.handler = (r) => r.path == '/v1/auth/logout'
        ? envelope(500, 'platform.internal')
        : backend.handle(r);
    await h.container.read(logoutControllerProvider.notifier).signOut();
    expect(h.read(appPhaseProvider), AppPhase.serverVerified);
  });
}
