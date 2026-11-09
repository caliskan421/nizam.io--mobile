// keepAlive önbellekler: A okuması sürerken B aynı programı seçer; geç A yanıtı
// B'nin değerini ya da hatasını değiştiremez. Gerçek depolar + sahte HTTP kullanılır.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/meetings/application/meetings_controller.dart';
import 'package:nizamio/features/scope/application/home_dashboard_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../meetings/meetings_server.dart';
import '../../pilot_support.dart';

void main() {
  for (final home in [true, false]) {
    for (final failB in [false, true]) {
      test(
        '${home ? 'özet' : 'toplantılar'}: A uçuşta → B aynı program; '
        'geç A yanıtı ${failB ? 'B hatasını' : 'B verisini'} değiştirmez',
        () async {
          final (h, _) = await openMeetings(MeetingsServer());
          final server = MeetingsServer();
          final pilot = PilotBackend();
          var session = 1;
          final c = ProviderContainer(
            parent: h.container,
            retry: (_, _) => null,
            overrides: [
              sessionGenerationProvider.overrideWith((ref) => session),
              scopeStateProvider.overrideWithValue(
                const ScopeSelection(programId: 'prog-1'),
              ),
              taskCatalogControllerProvider.overrideWith(
                TaskCatalogController.new,
              ),
              homeDashboardControllerProvider.overrideWith(
                HomeDashboardController.new,
              ),
              meetingsBoardControllerProvider.overrideWith(
                MeetingsBoardController.new,
              ),
            ],
          );
          addTearDown(c.dispose);
          final started = Completer<void>();
          final releaseA = Completer<void>();
          final returnedA = Completer<void>();
          final endpoint = home ? '/v1/reports/dashboard' : '/v1/meetings';
          var reads = 0;
          h.backend.handler = (r) async {
            if (r.path == endpoint && r.method == 'GET') {
              final n = ++reads;
              final response = home
                  ? jsonResponse(200, {
                      ...emptyDashboardWire()[endpoint]! as Map<String, Object>,
                      'total_tasks': n,
                    })
                  : jsonResponse(200, {
                      'items': [meetingWire(id: 'm$n')],
                      'next_cursor': '',
                    });
              if (n == 1) {
                started.complete();
                await releaseA.future;
                returnedA.complete();
                return response;
              }
              if (failB) return errorBody(500, 'platform.internal');
              return response;
            }
            return home ? pilot.handle(r) : server.handle(r);
          };

          Future<Object> read() => home
              ? c.read(homeDashboardControllerProvider.future)
              : c.read(meetingsBoardControllerProvider.future);
          AsyncValue<Object> visible() => home
              ? c.read(homeDashboardControllerProvider.notifier).visible
              : c.read(meetingsBoardControllerProvider.notifier).visible;
          Object? marker() => home
              ? c.read(homeDashboardControllerProvider).value?.tasks.total
              : c
                    .read(meetingsBoardControllerProvider)
                    .value
                    ?.visible
                    .single
                    .id;

          // Oturum nesli değişmeden önce A'nın HTTP isteği gerçekten başlamış olmalı.
          final a = read();
          unawaited(a.then<void>((_) {}, onError: (Object _, StackTrace _) {}));
          await started.future;
          session = 2;
          c.invalidate(sessionGenerationProvider);
          final b = read();
          expect(
            visible().hasValue,
            isFalse,
            reason: 'A verisi B yüklenirken görünmez',
          );
          if (failB) {
            await expectLater(b, throwsA(isA<Exception>()));
          } else {
            await b;
            expect(marker(), home ? 2 : 'm2');
          }
          releaseA.complete();
          await returnedA.future;
          await pumpEventQueue();
          expect(reads, 2, reason: 'bir A, bir B okuması; otomatik tekrar yok');
          expect(visible().hasError, failB);
          expect(visible().hasValue, !failB);
          if (!failB) expect(marker(), home ? 2 : 'm2');
          await c.pump();
          expect(
            c.exists(
              home
                  ? homeDashboardControllerProvider
                  : meetingsBoardControllerProvider,
            ),
            isTrue,
            reason: 'dinleyicisiz önbellek keepAlive kalır',
          );
        },
      );
    }
  }
}
