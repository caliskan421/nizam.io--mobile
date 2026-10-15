// LoginController: gönderim durumu; parola durumda/log'da yok; hata ApiError.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/logging/log.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/features/identity/application/login_controller.dart';

import '../../pilot_support.dart';

void main() {
  tearDown(Log.resetSink);

  test(
    'başarı: oturum açılır, durum biter; parola durumda ve log\'da yok',
    () async {
      final logs = <String>[];
      Log.sink = logs.add;
      final h = await pilotHarness(PilotBackend());
      h.container.listen(loginControllerProvider, (_, _) {});
      final states = <AsyncValue<void>>[];
      h.container.listen(loginControllerProvider, (_, n) => states.add(n));
      await h.container
          .read(loginControllerProvider.notifier)
          .submit(email: ' a@b.test ', password: secretLogin);
      expect(h.read(sessionStateProvider), isA<SessionActive>());
      expect(states.first.isLoading, isTrue);
      expect(states.last.hasError, isFalse);
      expect(h.backend.requests.last.body, {
        'email': 'a@b.test',
        'password': secretLogin,
      });
      for (final s in states) {
        expect(s.toString(), isNot(contains(secretLogin)));
      }
      expect(
        h.read(loginControllerProvider).toString(),
        isNot(contains(secretLogin)),
      );
      expect(logs.join('\n'), isNot(contains(secretLogin)));
    },
  );

  test('hata: durum ApiError taşır, oturum açılmaz', () async {
    final backend = PilotBackend()..loginError = 'identity.credentials_invalid';
    final h = await pilotHarness(backend);
    h.container.listen(loginControllerProvider, (_, _) {});
    await h.container
        .read(loginControllerProvider.notifier)
        .submit(email: 'a@b.test', password: secretLogin);
    final s = h.read(loginControllerProvider);
    expect(s.error, apiCode('identity.credentials_invalid'));
    expect(s.toString(), isNot(contains(secretLogin)));
    expect(s.error.toString(), isNot(contains(secretLogin)));
    expect(h.read(sessionStateProvider), isA<SessionNone>());
  });

  test('bağ doğrulanmamışken: serverNotVerified, ağa parola gitmez', () async {
    final h = await pilotHarness(PilotBackend(), verified: false);
    h.container.listen(loginControllerProvider, (_, _) {});
    await h.container
        .read(loginControllerProvider.notifier)
        .submit(email: 'a@b.test', password: secretLogin);
    expect(
      (h.read(loginControllerProvider).error! as ApiError).code,
      'client.server_not_verified',
    );
    expect(h.backend.requests, isEmpty);
  });
}
