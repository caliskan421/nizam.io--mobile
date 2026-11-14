// ActivityLogController: kapalı (yönetici olmayan) kaynakta yenileme tekrar çağırmaz; gerçek
// bileşim kökünde yönetici olmayana 403 → ActivityUnavailable, alt yazı yok.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/activity/activity.dart';
import 'package:nizamio/features/activity/application/activity_log_controller.dart';
import 'package:nizamio/features/activity/domain/activity_log.dart';

import '../../../support/fake_backend.dart';
import '../../pilot_support.dart';

final class _UnavailableLog implements ActivityLogRepository {
  int reads = 0;
  @override
  Future<ActivityLog> load({String? actorAccountId, String? cursor}) async {
    reads++;
    throw const ActivityUnavailable();
  }
}

void main() {
  test('kapalı kaynakta yenileme kaynağı tekrar çağırmaz', () async {
    final repo = _UnavailableLog();
    final c = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        activityLogRepositoryProvider.overrideWithValue(repo),
        sessionGenerationProvider.overrideWith((ref) => 1),
      ],
    );
    addTearDown(c.dispose);
    c.listen(activityLogControllerProvider, (_, _) {});
    await expectLater(
      c.read(activityLogControllerProvider.future),
      throwsA(isA<ActivityUnavailable>()),
    );
    await c.read(activityLogControllerProvider.notifier).refresh();
    expect(repo.reads, 1);
  });

  test(
    'yönetici olmayana 403 audit.not_authorized → kapalı; alt yazı yok',
    () async {
      final pilot = PilotBackend();
      final h = await pilotHarness(pilot, signedIn: true);
      final base = h.backend.handler;
      h.backend.handler = (r) => r.path == '/v1/audit/entries'
          ? jsonResponse(403, {
              'code': 'audit.not_authorized',
              'message': 'x',
              'request_id': 'req-1',
            })
          : base(r);
      final c = h.container;
      c.listen(activityNavCaptionProvider, (_, _) {});
      await expectLater(
        c.read(activityLogControllerProvider.future),
        throwsA(isA<ActivityUnavailable>()),
      );
      expect(c.read(activityNavCaptionProvider), isNull);
    },
  );
}
