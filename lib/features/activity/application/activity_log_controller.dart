import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/activity_log.dart';
import 'activity_providers.dart';

part 'activity_log_controller.g.dart';

/// İşlem geçmişi kayıtları (yeniden yükleme yalnız dokunuşla).
@Riverpod(keepAlive: true)
class ActivityLogController extends _$ActivityLogController {
  @override
  Future<ActivityLog> build() => ref.read(activityLogRepositoryProvider).load();
}
