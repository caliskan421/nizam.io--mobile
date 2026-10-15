// ServerConnectController: core ServerBindingController.verify'ı çağırır; sonuç bağ durumundadır.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/features/server/application/server_connect_controller.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';

void main() {
  test('başarılı bağlanma: gönderim biter, bağ doğrulanır', () async {
    final h = Harness();
    addTearDown(h.dispose);
    final states = <AsyncValue<void>>[];
    h.container.listen(
      serverConnectControllerProvider,
      (_, next) => states.add(next),
    );
    await h.container
        .read(serverConnectControllerProvider.notifier)
        .connect(testUrl);
    expect(h.read(bindingStateProvider), isA<BindingVerified>());
    expect(states.first.isLoading, isTrue);
    expect(states.last.hasError, isFalse);
    expect(states.last.isLoading, isFalse);
  });

  test(
    'güvensiz adres (prod http): BindingFailed insecure_server, istek yok',
    () async {
      final h = Harness();
      addTearDown(h.dispose);
      await h.container
          .read(serverConnectControllerProvider.notifier)
          .connect('http://nizam.example.test');
      final s = h.read(bindingStateProvider);
      expect(s, isA<BindingFailed>());
      expect((s as BindingFailed).error.code, ClientErrorCode.insecureServer);
      expect(h.backend.requests, isEmpty);
    },
  );

  test('güncelleme gerekli: bağ durumu BindingUpdateRequired', () async {
    final h = Harness(handler: (r) => discoveryHandler(r, minimum: '99.0.0'));
    addTearDown(h.dispose);
    await h.container
        .read(serverConnectControllerProvider.notifier)
        .connect(testUrl);
    expect(h.read(bindingStateProvider), isA<BindingUpdateRequired>());
  });

  test('TLS hatası ayrı kod olarak bağ durumunda kalır', () async {
    final h = Harness(flavor: Flavor.prod, handler: badCertificate);
    addTearDown(h.dispose);
    await h.container
        .read(serverConnectControllerProvider.notifier)
        .connect(testUrl);
    final s = h.read(bindingStateProvider) as BindingFailed;
    expect(s.error.code, ClientErrorCode.tlsError);
  });
}
