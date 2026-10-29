// CurrentAccountController: GET /v1/me → domain hesabı; hata ApiError.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/identity/application/current_account_controller.dart';
import 'package:nizamio/features/identity/domain/current_account.dart';

import '../../../support/fake_backend.dart';
import '../../pilot_support.dart';

void main() {
  test('hesap e-postası döner', () async {
    final h = await pilotHarness(PilotBackend(), signedIn: true);
    h.container.listen(currentAccountControllerProvider, (_, _) {});
    final account = await h.container.read(
      currentAccountControllerProvider.future,
    );
    expect(
      account,
      const CurrentAccount(
        accountId: 'acc-1',
        email: 'a@b.test',
        fullName: 'Ayşe Yılmaz',
        companyAdmin: true,
      ),
    );
  });

  test('hata: AsyncError(ApiError)', () async {
    final backend = PilotBackend();
    final h = await pilotHarness(backend, signedIn: true);
    h.backend.handler = (r) => r.path == '/v1/me'
        ? envelope(404, 'platform.not_found')
        : backend.handle(r);
    h.container.listen(currentAccountControllerProvider, (_, _) {});
    await expectLater(
      h.container.read(currentAccountControllerProvider.future),
      throwsA(apiCode('platform.not_found')),
    );
    expect(
      h.container.read(currentAccountControllerProvider),
      isA<AsyncError<CurrentAccount>>(),
    );
  });
}
