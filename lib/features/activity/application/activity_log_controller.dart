import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/refresh.dart';
import '../domain/activity_log.dart';
import 'activity_providers.dart';

part 'activity_log_controller.g.dart';

/// İşlem geçmişi kayıtları (yeniden yükleme yalnız dokunuşla).
@Riverpod(keepAlive: true)
class ActivityLogController extends _$ActivityLogController {
  Future<void> refresh() async {
    if (state.error is ActivityUnavailable) return;
    await refreshWithFeedback(
      shown: state.hasValue,
      reload: () async {
        ref.invalidateSelf();
        await future;
      },
    );
  }

  @override
  Future<ActivityLog> build() => ref.read(activityLogRepositoryProvider).load();
}
