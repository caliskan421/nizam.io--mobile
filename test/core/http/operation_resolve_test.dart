// Kapı halkasının işlem çözümü: sabit segmentli yol, yol parametreli şablona üstündür
// (`/v1/chats/candidates` → `listChatCandidates`, `getChat` değil); başka işlemin metaverisiyle
// aynı yola istek yine gönderilmez (CX-Ö-02).
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/api/generated/clients/messaging_client.dart';
import 'package:nizamio/core/api/generated/models/purpose.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';

import '../../support/fake_backend.dart';
import '../../support/harness.dart';

void main() {
  test('sabit yol üstün; başka işlem metaverisi reddedilir', () async {
    final h = Harness(
      handler: (r) => switch ('${r.method} ${r.path}') {
        'POST /v1/auth/login' => jsonResponse(200, loginBody('1')),
        'GET /v1/chats/candidates' => jsonResponse(200, {
          'items': <Object>[],
          'truncated': false,
        }),
        _ => discoveryHandler(r),
      },
    );
    addTearDown(h.dispose);
    await h.read(serverBindingProvider).verify(testUrl);
    await h.identity.login(email: 'a@b.test', password: 'p');
    h.read(scopeControllerProvider).selectProgram('prog-7');
    final dio = h.read(apiDioProvider)!;
    await apiCall(
      () => MessagingClient(dio).listChatCandidates(purpose: Purpose.direct),
    );
    expect(h.backend.requests.last.path, '/v1/chats/candidates');
    final before = h.backend.requests.length;
    await expectLater(
      dio.get<Object?>(
        '/v1/chats/candidates',
        options: Options(extra: MessagingClient.getChatOpenapiExtras),
      ),
      throwsA(
        isA<DioException>().having(
          (e) => (e.error! as ApiError).code,
          'code',
          ClientErrorCode.unknownOperation,
        ),
      ),
    );
    expect(h.backend.requests.length, before);
  });
}
