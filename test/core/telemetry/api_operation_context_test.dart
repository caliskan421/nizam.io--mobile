// apiCall → API işlem kimliği (operationId) bağlamı: gerçek bileşim (Harness), gerçek Dio halkaları,
// üretilmiş istemciler. İşlem kimliği YALNIZ üretilmiş apiOperations listesinden gelir; paralel ve
// iç içe çağrılar birbirinin bağlamını ezmez; URL/belirteç/e-posta rapora girmez.
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/api/generated/clients/identity_client.dart';
import 'package:nizamio/core/api/generated/clients/platform_client.dart';
import 'package:nizamio/core/api/generated/operations.gen.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';
import 'package:nizamio/core/telemetry/stack_sanitizer.dart';

import '../../support/fake_backend.dart';
import '../../support/fake_error_reporter.dart';
import '../../support/harness.dart';

void main() {
  late Harness h;
  late FakeErrorReporter sdk;
  late ResponseBody Function(Seen) onMe;
  late ResponseBody Function(Seen) onProfile;

  setUp(() async {
    onMe = (_) => jsonResponse(200, {'account_id': 'acc-1'});
    onProfile = discoveryHandler;
    h = Harness(
      handler: (r) {
        if (r.path == '/v1/auth/login')
          return jsonResponse(200, loginBody('1'));
        if (r.path == '/v1/me') return onMe(r);
        if (r.path == '/v1/instance/profile') return onProfile(r);
        return discoveryHandler(r);
      },
    );
    await h.read(serverBindingProvider).verify(testUrl);
    await h.identity.login(email: 'a@b.test', password: 'Gizli-Parola-1');
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk).setEnabled(true);
  });
  tearDown(() async {
    ErrorReporting.reset();
    await h.dispose();
  });

  Dio dio() => h.read(apiDioProvider)!;

  /// Kişisel görünen gövdeler: e-posta, belirteç, dosya adı. Rapora hiçbiri girmemeli.
  const poisoned = {
    'account_id': 5, // DTO tür hatası → TypeError
    'email': 'ali.veli@example.com',
    'token': 'access-token-GIZLI',
    'file': 'maaş-bordrosu.pdf',
  };

  String wire(ErrorReport r) => '${r.label}\n${r.message}\n${r.stack}';

  void expectClean(ErrorReport r) {
    final text = wire(r);
    for (final leak in [
      'ali.veli',
      'example.com',
      'example.test',
      'access-token',
      'GIZLI',
      'maaş',
      'bordro',
      '/v1/me',
      'https://',
    ]) {
      expect(text, isNot(contains(leak)), reason: leak);
    }
  }

  test(
    'geçersiz 2xx gövde → TEK rapor, doğrulanmış işlem kimliği, sabit mesaj',
    () async {
      onMe = (_) => jsonResponse(200, poisoned);
      await expectLater(
        apiCall(() => IdentityClient(dio()).me()),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            ClientErrorCode.invalidResponse,
          ),
        ),
      );
      expect(sdk.reports, hasLength(1));
      final r = sdk.reports.single;
      expect(r.kind, ReportKind.invalidResponse);
      expect(r.apiOperationId, 'me');
      expect(apiOperations.containsKey(r.apiOperationId), isTrue);
      expect(r.source, ReportSource.network);
      expect(r.label, contains('api=me'));
      expect(r.message, startsWith('Sunucu yanıtı beklenen biçimde'));
      expectClean(r);
    },
  );

  test(
    '5xx → serverError + işlem kimliği; 403 beklenen hata rapor üretmez',
    () async {
      onMe = (_) => envelope(502, 'platform.internal');
      await expectLater(
        apiCall(() => IdentityClient(dio()).me()),
        throwsA(isA<ApiError>()),
      );
      expect(sdk.reports.single.kind, ReportKind.serverError);
      expect(sdk.reports.single.apiOperationId, 'me');
      expect(sdk.reports.single.statusClass, '5xx');

      sdk.reports.clear();
      ErrorReporting.reset();
      ErrorReporting.attach(sdk).setEnabled(true);
      onMe = (_) => envelope(403, 'organization.not_authorized');
      await expectLater(
        apiCall(() => IdentityClient(dio()).me()),
        throwsA(isA<ApiError>()),
      );
      expect(sdk.reports, isEmpty, reason: 'yetki reddi beklenen durumdur');
    },
  );

  test('eşzamanlı iki apiCall bağlamları karışmaz', () async {
    onMe = (_) => jsonResponse(200, poisoned);
    onProfile = (_) => jsonResponse(200, <String, Object?>{'display_name': 5});
    final a = apiCall(() => IdentityClient(dio()).me());
    final b = apiCall(() => PlatformClient(dio()).instanceProfile());
    await Future.wait([
      a.then<void>((_) {}, onError: (_) {}),
      b.then<void>((_) {}, onError: (_) {}),
    ]);
    expect(sdk.reports.map((r) => r.apiOperationId).toSet(), {
      'me',
      'instanceProfile',
    });
    expect(sdk.reports, hasLength(2));
  });

  test('tek apiCall içinde iki farklı işlem → belirsiz: kimlik null (sahte kesinlik yok)', () async {
    onMe = (_) => jsonResponse(200, poisoned);
    onProfile = (_) => jsonResponse(200, <String, Object?>{'display_name': 5});
    await expectLater(
      apiCall(() async {
        await PlatformClient(dio())
            .instanceProfile()
            .then<void>((_) {}, onError: (_) {});
        await IdentityClient(dio()).me();
      }),
      throwsA(isA<ApiError>()),
    );
    // İç istek DioException değil, DTO TypeError'ı: Dio isteği iki farklı işlem gördü.
    expect(sdk.reports.last.apiOperationId, isNull);
  });

  test('iç içe apiCall: iç işlem kimliği, tek rapor', () async {
    onMe = (_) => jsonResponse(200, poisoned);
    await expectLater(
      apiCall(() => apiCall(() => IdentityClient(dio()).me())),
      throwsA(isA<ApiError>()),
    );
    expect(sdk.reports, hasLength(1));
    expect(sdk.reports.single.apiOperationId, 'me');
  });

  test('rıza kapalı: kanala hiçbir şey verilmez', () async {
    ErrorReporting.setEnabled(false);
    onMe = (_) => jsonResponse(200, poisoned);
    await expectLater(
      apiCall(() => IdentityClient(dio()).me()),
      throwsA(isA<ApiError>()),
    );
    expect(sdk.reports, isEmpty);
  });

  test('ErrorReport.create: whitelist dışı işlem kimliği düşer', () {
    final r = ErrorReport.create(
      operation: ReportOperation.none,
      kind: ReportKind.unexpected,
      errorType: ReportErrorType.other,
      stack: sanitizeStack(StackTrace.current),
      apiOperationId: '/v1/me?token=abc',
    );
    expect(r.apiOperationId, isNull);
    expect(r.label, isNot(contains('token')));
  });
}
