// ActivityLogController: bileşim kökündeki örnek kaynaktan kayıtlar; alt menü alt yazısı.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/activity/activity.dart';
import 'package:nizamio/features/activity/application/activity_log_controller.dart';
import 'package:nizamio/features/activity/domain/activity_log.dart';

import '../../pilot_support.dart';

final class _UnavailableLog implements ActivityLogRepository {
  int reads = 0;
  @override
  Future<ActivityLog> load() async {
    reads++;
    throw const ActivityUnavailable();
  }
}

void main() {
  test('uç yokken yenileme kaynağı tekrar çağırmaz', () async {
    final repo = _UnavailableLog();
    final c = ProviderContainer(
      retry: (_, _) => null,
      overrides: [activityLogRepositoryProvider.overrideWithValue(repo)],
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

  test('sözleşmede günlük ucu yokken örnek kayıt gösterilmez', () async {
    final h = await pilotHarness(PilotBackend());
    final c = h.container;
    c.listen(activityNavCaptionProvider, (_, _) {});
    expect(c.read(activityNavCaptionProvider), isNull);
    await expectLater(
      c.read(activityLogControllerProvider.future),
      throwsA(isA<ActivityUnavailable>()),
    );
    expect(c.read(activityNavCaptionProvider), isNull);
  });
}
