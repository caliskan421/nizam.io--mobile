// Bildirim tercihleri denetleyicisi: okuma, tek grup yazma (sunucu kümesi durum olur), aynı
// değer istek göndermez, hata kodla döner ve durum korunur.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/notifications/application/notification_preferences_controller.dart';
import 'package:nizamio/features/notifications/application/notifications_providers.dart';
import 'package:nizamio/features/notifications/domain/notification_preferences.dart';

import '../notification_count_stub.dart';

class _Repo extends NotificationCountStub {
  NotificationPreferences server = {
    for (final g in NotificationPrefGroup.values) g: false,
  };
  final writes = <NotificationPreferences>[];
  ApiError? error;

  @override
  Future<NotificationPreferences> preferences() async => server;

  @override
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences changes,
  ) async {
    writes.add(changes);
    if (error case final e?) throw e;
    return server = {...server, ...changes};
  }
}

void main() {
  test('sessize alma sunucuya tek grup gider; aynı değer istek yok', () async {
    final repo = _Repo();
    final c = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        notificationRepositoryProvider.overrideWithValue(repo),
        sessionGenerationProvider.overrideWith((ref) => 0),
      ],
    );
    addTearDown(c.dispose);
    c.listen(notificationPreferencesControllerProvider, (_, _) {});
    await c.read(notificationPreferencesControllerProvider.future);
    final ctl = c.read(notificationPreferencesControllerProvider.notifier);

    expect(
      await ctl.setMuted(NotificationPrefGroup.mesaj, muted: false),
      isNull,
    );
    expect(repo.writes, isEmpty);
    expect(
      await ctl.setMuted(NotificationPrefGroup.mesaj, muted: true),
      isNull,
    );
    expect(repo.writes.single, {NotificationPrefGroup.mesaj: true});
    expect(
      c
          .read(notificationPreferencesControllerProvider)
          .value?[NotificationPrefGroup.mesaj],
      isTrue,
    );

    repo.error = ApiError('notifications.input_invalid', status: 422);
    final e = await ctl.setMuted(NotificationPrefGroup.gorev, muted: true);
    expect(e?.code, 'notifications.input_invalid');
    expect(
      c
          .read(notificationPreferencesControllerProvider)
          .value?[NotificationPrefGroup.gorev],
      isFalse,
    );
  });
}
