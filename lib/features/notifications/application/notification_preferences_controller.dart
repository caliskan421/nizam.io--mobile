import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/notification_preferences.dart';
import 'notifications_providers.dart';

part 'notification_preferences_controller.g.dart';

/// Bildirim tercihleri (`GET/PUT /v1/notifications/preferences`; ayarlar ekranı). Değişiklik
/// tek grup için sunucuya yazılır, sunucunun döndürdüğü küme durum olur (iyimser güncelleme
/// yok); uçuştaki yazma varken yeni yazma gönderilmez.
@riverpod
class NotificationPreferencesController
    extends _$NotificationPreferencesController {
  bool _writing = false;

  @override
  Future<NotificationPreferences> build() {
    ref.watch(sessionGenerationProvider);
    return ref.read(notificationRepositoryProvider).preferences();
  }

  /// [group]'u sessize alır ([muted]) ya da açar. Hata kodla döner (durum değişmez); aynı
  /// değer ya da uçuştaki yazma → istek yok, null.
  Future<ApiError?> setMuted(
    NotificationPrefGroup group, {
    required bool muted,
  }) async {
    final current = state.value;
    if (current == null || _writing || current[group] == muted) return null;
    _writing = true;
    try {
      final next = await ref
          .read(notificationRepositoryProvider)
          .updatePreferences({group: muted});
      if (ref.mounted) state = AsyncData(next);
      return null;
    } on Object catch (e, st) {
      return toReportedApiError(e, st, source: ReportSource.notifications);
    } finally {
      _writing = false;
    }
  }
}
