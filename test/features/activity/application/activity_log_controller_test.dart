// ActivityLogController: bileşim kökündeki örnek kaynaktan kayıtlar; alt menü alt yazısı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/activity/activity.dart';
import 'package:nizamio/features/activity/application/activity_log_controller.dart';
import 'package:nizamio/features/activity/domain/activity_log.dart';

import '../../pilot_support.dart';

void main() {
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
