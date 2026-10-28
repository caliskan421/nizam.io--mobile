// ActivityLogController: bileşim kökündeki örnek kaynaktan kayıtlar; alt menü alt yazısı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/activity/activity.dart';
import 'package:nizamio/features/activity/application/activity_log_controller.dart';

import '../../pilot_support.dart';

void main() {
  test('kayıtlar yüklenir; alt yazı "38 kayıt"', () async {
    final h = await pilotHarness(PilotBackend());
    final c = h.container;
    c.listen(activityNavCaptionProvider, (_, _) {});
    expect(c.read(activityNavCaptionProvider), isNull);
    final log = await c.read(activityLogControllerProvider.future);
    expect(log.entries, hasLength(38));
    expect(c.read(activityNavCaptionProvider), '38 kayıt');
  });
}
