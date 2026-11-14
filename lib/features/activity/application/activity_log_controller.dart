import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../../../core/refresh.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
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

  bool _loadingMore = false;

  /// Sunucudaki sonraki (daha eski) sayfayı ekler. İmleç yoksa, yükleme sürüyorsa ya da
  /// arada oturum değiştiyse (yanıt eski neslin) bir şey yapmaz; hata durumu bozmaz, döner.
  Future<Object?> loadMore() async {
    final current = state.value;
    final cursor = current?.nextCursor;
    if (current == null || cursor == null || _loadingMore) return null;
    _loadingMore = true;
    final generation = ref.read(sessionGenerationProvider);
    try {
      final page = await ref
          .read(activityLogRepositoryProvider)
          .load(cursor: cursor);
      if (!ref.mounted ||
          ref.read(sessionGenerationProvider) != generation ||
          !identical(state.value, current)) {
        return null;
      }
      state = AsyncData(current.append(page));
      return null;
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.activity);
      return e;
    } finally {
      _loadingMore = false;
    }
  }

  /// Oturum (hesap) değişince kayıtlar atılır ve yeniden okunur: önceki yöneticinin kayıtları
  /// yeni hesaba gösterilmez; eski neslin geç yanıtı yeniden kurulumda yok sayılır.
  @override
  Future<ActivityLog> build() {
    ref.watch(sessionGenerationProvider);
    return ref.read(activityLogRepositoryProvider).load();
  }
}
