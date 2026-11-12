// Giriş akışı hata raporu: gerçek bileşim kökü + sahte sunucu; beklenen/beklenmeyen ayrımı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/features/identity/application/login_controller.dart';

import '../../../support/fake_backend.dart';
import '../../../support/fake_error_reporter.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';

void main() {
  late FakeErrorReporter sdk;

  setUp(() {
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk);
    ErrorReporting.setEnabled(true);
  });
  tearDown(ErrorReporting.reset);

  Future<Object?> submit(Harness h) async {
    h.container.listen(loginControllerProvider, (_, _) {});
    await h.container
        .read(loginControllerProvider.notifier)
        .submit(email: 'a@b.test', password: secretLogin);
    return h.read(loginControllerProvider).error;
  }

  test('yanlış parola ve doğrulama hatası RAPORLANMAZ', () async {
    final backend = PilotBackend()..loginError = 'identity.credentials_invalid';
    final error = await submit(await pilotHarness(backend));
    expect((error! as ApiError).code, 'identity.credentials_invalid');
    expect(sdk.reports, isEmpty);
  });

  test(
    'tokensız başarılı yanıt (gerçek login akışı): tek rapor, login bağlamı',
    () async {
      final pilot = PilotBackend();
      final h = await pilotHarness(pilot);
      h.backend.handler = (r) {
        if (r.path == '/v1/auth/login') {
          final body = loginBody('1')
            ..remove('access_token')
            ..remove('refresh_token');
          return jsonResponse(200, body);
        }
        return pilot.handle(r);
      };
      final error = await submit(h);
      expect((error! as ApiError).code, ClientErrorCode.invalidResponse);
      final r = sdk.reports.single;
      expect(r.kind, ReportKind.invalidResponse);
      expect(r.operation, ReportOperation.login);
      expect(r.apiCode, ClientErrorCode.invalidResponse);
      expect(wireOf(r), isNot(contains('a@b.test')));
      expect(wireOf(r), isNot(contains(secretLogin)));
    },
  );

  test('şemaya uymayan başarılı yanıt: ayrıştırma hatası login bağlamıyla raporlanır', () async {
    final pilot = PilotBackend();
    final h = await pilotHarness(pilot);
    h.backend.handler = (r) => r.path == '/v1/auth/login'
        ? jsonResponse(200, {'account_id': 5})
        : pilot.handle(r);
    final error = await submit(h);
    expect((error! as ApiError).code, ClientErrorCode.invalidResponse);
    expect(sdk.reports.single.operation, ReportOperation.login);
    expect(sdk.reports.single.kind, ReportKind.invalidResponse);
  });
}
