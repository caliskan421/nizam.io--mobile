// PasswordChangeController: gönderim durumu; parolalar durumda/log'da yok; başarıda faz.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/logging/log.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/identity/application/password_change_controller.dart';

import '../../pilot_support.dart';

void main() {
  tearDown(Log.resetSink);

  test(
    'başarı: bayrak düşer → sessionOpen; parolalar durumda/log\'da yok',
    () async {
      final logs = <String>[];
      Log.sink = logs.add;
      final h = await pilotHarness(
        PilotBackend()..force = true,
        signedIn: true,
      );
      h.container.listen(passwordChangeControllerProvider, (_, _) {});
      expect(h.read(appPhaseProvider), AppPhase.passwordChangeRequired);
      await h.container
          .read(passwordChangeControllerProvider.notifier)
          .submit(currentPassword: secretCurrent, newPassword: secretNew);
      final s = h.read(passwordChangeControllerProvider);
      expect(s.hasError, isFalse);
      expect(s.isLoading, isFalse);
      expect(h.read(appPhaseProvider), AppPhase.sessionOpen);
      for (final secret in [secretCurrent, secretNew]) {
        expect(s.toString(), isNot(contains(secret)));
        expect(logs.join('\n'), isNot(contains(secret)));
      }
    },
  );

  test('hata: ApiError durumda; faz değişmez; parola sızmaz', () async {
    final backend = PilotBackend()
      ..force = true
      ..passwordError = 'identity.credentials_invalid';
    final h = await pilotHarness(backend, signedIn: true);
    h.container.listen(passwordChangeControllerProvider, (_, _) {});
    await h.container
        .read(passwordChangeControllerProvider.notifier)
        .submit(currentPassword: secretCurrent, newPassword: secretNew);
    final s = h.read(passwordChangeControllerProvider);
    expect(s.error, apiCode('identity.credentials_invalid'));
    expect(h.read(appPhaseProvider), AppPhase.passwordChangeRequired);
    for (final secret in [secretCurrent, secretNew]) {
      expect(s.toString(), isNot(contains(secret)));
      expect(s.error.toString(), isNot(contains(secret)));
    }
  });

  test('oturum yok: istek çıkmaz', () async {
    final h = await pilotHarness(PilotBackend());
    h.container.listen(passwordChangeControllerProvider, (_, _) {});
    await h.container
        .read(passwordChangeControllerProvider.notifier)
        .submit(currentPassword: secretCurrent, newPassword: secretNew);
    expect(
      h.read(passwordChangeControllerProvider).error,
      apiCode('client.not_signed_in'),
    );
    expect(h.backend.count('POST', '/v1/auth/password'), 0);
  });
}
