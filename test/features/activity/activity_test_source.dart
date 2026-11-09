import 'package:nizamio/features/activity/data/sample/sample_activity_log_repository.dart';
import 'package:nizamio/features/activity/domain/activity_log.dart';

import '../../support/harness.dart';

/// Süzgeç/görünüm testleri örnek kaynağı açıkça enjekte eder; uygulama bunu kullanmaz.
Future<void> useActivityFixture(Harness harness) async {
  await harness.composition.locator.unregister<ActivityLogRepository>();
  harness.composition.locator.registerSingleton<ActivityLogRepository>(
    SampleActivityLogRepository(),
  );
}
