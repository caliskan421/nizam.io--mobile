// ScopeService: program listesi (S1, kapsam başlığı YOK), seçim (ScopeController), kapsamdaki
// program (S2, X-Nizamio-Program başlığı AÇIK taşınır; seçim yokken istek gönderilmez).
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/scope/scope.dart';

import '../../../support/harness.dart';
import '../../pilot_support.dart';

void main() {
  ScopeService scope(Harness h) => h.read(scopeServiceProvider);

  group('programs', () {
    test(
      'S1 listesi: kapsam başlığı gönderilmez; domain Program döner',
      () async {
        final h = await pilotHarness(PilotBackend(), signedIn: true);
        final slice = await scope(h).programs();
        expect(slice.items, const [
          Program(id: 'prog-1', name: 'Program Bir'),
          Program(id: 'prog-2', name: 'Program İki'),
        ]);
        final req = h.backend.requests.last;
        expect(req.path, '/v1/programs');
        expect(req.header('X-Nizamio-Program'), isNull);
        expect(req.header('Authorization'), startsWith('Bearer '));
      },
    );

    test('program.not_authorized ApiError olarak yükselir', () async {
      final backend = PilotBackend()..programsError = 'program.not_authorized';
      final h = await pilotHarness(backend, signedIn: true);
      await expectLater(
        scope(h).programs(),
        throwsA(apiCode('program.not_authorized')),
      );
    });

    test('bağ yok → serverNotVerified, istek yok', () async {
      final h = await pilotHarness(PilotBackend(), verified: false);
      await expectLater(
        scope(h).programs(),
        throwsA(apiCode(ClientErrorCode.serverNotVerified)),
      );
      expect(h.backend.requests, isEmpty);
    });

    test(
      'oturum giriş yapılmamışsa notSignedIn (istek ara katmanda reddedilir)',
      () async {
        final h = await pilotHarness(PilotBackend());
        await expectLater(
          scope(h).programs(),
          throwsA(apiCode(ClientErrorCode.notSignedIn)),
        );
        expect(h.backend.count('GET', '/v1/programs'), 0);
      },
    );

    test('yanıt beklenirken çıkış olursa sonuç atılır', () async {
      final gate = Completer<void>();
      final backend = PilotBackend();
      final h = await pilotHarness(backend, signedIn: true);
      h.backend.handler = (r) async {
        if (r.path == '/v1/programs') await gate.future;
        return backend.handle(r);
      };
      final pending = scope(h).programs();
      final expectation = expectLater(
        pending,
        throwsA(apiCode(ClientErrorCode.sessionEnded)),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await h.read(sessionControllerProvider).clear();
      gate.complete();
      await expectation;
    });
  });

  group('select / clearSelection', () {
    test(
      'seçim ScopeController\'a yazılır; faz sessionOpen → scoped',
      () async {
        final h = await pilotHarness(PilotBackend(), signedIn: true);
        expect(h.read(appPhaseProvider), AppPhase.sessionOpen);
        scope(h).select('prog-2');
        expect(h.read(scopeControllerProvider).current.programId, 'prog-2');
        expect(h.read(appPhaseProvider), AppPhase.scoped);
        scope(h).clearSelection();
        expect(h.read(appPhaseProvider), AppPhase.sessionOpen);
      },
    );

    test('oturum yok / boş kimlik: seçim yapılmaz', () async {
      final h = await pilotHarness(PilotBackend());
      expect(
        () => scope(h).select('prog-1'),
        throwsA(apiCode('client.not_signed_in')),
      );
      final h2 = await pilotHarness(PilotBackend(), signedIn: true);
      expect(
        () => scope(h2).select(''),
        throwsA(apiCode('client.not_signed_in')),
      );
      expect(h2.read(scopeControllerProvider).current.hasProgram, isFalse);
    });

    test('parola değişikliği beklerken seçim yapılmaz', () async {
      final h = await pilotHarness(
        PilotBackend()..force = true,
        signedIn: true,
      );
      expect(
        () => scope(h).select('prog-1'),
        throwsA(apiCode('client.not_signed_in')),
      );
    });
  });

  group('currentProgram (S2)', () {
    test(
      'X-Nizamio-Program = seçilen kimlik; yanıttaki program döner',
      () async {
        final h = await pilotHarness(PilotBackend(), signedIn: true);
        scope(h).select('prog-2');
        final program = await scope(h).currentProgram();
        expect(
          program,
          const Program(id: 'prog-2', name: 'Program İki', year: 2026),
        );
        final req = h.backend.requests.last;
        expect(req.path, '/v1/program');
        expect(req.header('X-Nizamio-Program'), 'prog-2');
        expect(req.header('X-Nizamio-Department'), isNull);
      },
    );

    test('seçim değişince sonraki istek yeni kimliği taşır', () async {
      final h = await pilotHarness(PilotBackend(), signedIn: true);
      scope(h).select('prog-1');
      await scope(h).currentProgram();
      scope(h).select('prog-2');
      await scope(h).currentProgram();
      final headers = [
        for (final r in h.backend.requests.where(
          (r) => r.path == '/v1/program',
        ))
          r.header('X-Nizamio-Program'),
      ];
      expect(headers, ['prog-1', 'prog-2']);
    });

    test('seçim yok → client.scope_missing; S2 isteği AĞA ÇIKMAZ', () async {
      final h = await pilotHarness(PilotBackend(), signedIn: true);
      await expectLater(
        scope(h).currentProgram(),
        throwsA(apiCode(ClientErrorCode.scopeMissing)),
      );
      expect(h.backend.count('GET', '/v1/program'), 0);
    });

    test('yanıt beklenirken kapsam değişirse sonuç atılır', () async {
      final gate = Completer<void>();
      final backend = PilotBackend();
      final h = await pilotHarness(backend, signedIn: true);
      scope(h).select('prog-1');
      h.backend.handler = (r) async {
        if (r.path == '/v1/program') await gate.future;
        return backend.handle(r);
      };
      final pending = scope(h).currentProgram();
      final expectation = expectLater(
        pending,
        throwsA(apiCode(ClientErrorCode.sessionEnded)),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));
      scope(h).clearSelection();
      gate.complete();
      await expectation;
    });
  });
}
