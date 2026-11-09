import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/reports/data/report_pdf_api_repository.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';

void main() {
  test(
    'gerçek API kapısı PDF GET ve iş yükü POST program/kimlik/gövdesini korur',
    () async {
      final h = Harness(
        handler: (r) {
          if (r.path == '/v1/auth/login') {
            return jsonResponse(200, loginBody('1'));
          }
          if (r.path.startsWith('/v1/reports/')) {
            return ResponseBody.fromBytes(
              [37, 80, 68, 70],
              200,
              headers: {
                'content-type': ['application/pdf'],
              },
            );
          }
          return discoveryHandler(r);
        },
      );
      addTearDown(h.dispose);
      await h.read(serverBindingProvider).verify(testUrl);
      await h.identity.login(email: 'a@b.test', password: 'password');
      h.read(scopeControllerProvider).selectProgram('program');
      final repository = ApiReportPdfRepository(h.read(apiDioProvider)!);
      expect(
        await (await repository.open('/v1/reports/season/pdf'))
            .expand((v) => v)
            .toList(),
        [37, 80, 68, 70],
      );
      var request = h.backend.requests.last;
      expect(request.header('Authorization'), 'Bearer access-token-1');
      expect(request.header('X-Nizamio-Program'), 'program');
      expect(request.method, 'GET');
      await (await repository.open(
        '/v1/reports/workload',
        memberIds: ['member'],
      )).drain<void>();
      request = h.backend.requests.last;
      expect(request.method, 'POST');
      expect(request.header('X-Nizamio-Program'), 'program');
      expect(request.header('X-Requested-With'), isNotEmpty);
      expect(request.body, {
        'member_ids': ['member'],
      });
    },
  );
}
