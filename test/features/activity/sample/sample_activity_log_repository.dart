import 'package:nizamio/features/activity/domain/activity_log.dart';

part 'sample_activity_log_data.dart';

/// TEST FİKSTÜRÜ — prototipteki işlem geçmişi (38 kayıt); ağ isteği atmaz. Sayfa/süzgeç
/// testleri bileşim köküne açıkça enjekte eder ([useActivityFixture]); uygulama kullanmaz.
final class SampleActivityLogRepository implements ActivityLogRepository {
  @override
  Future<ActivityLog> load({String? actorAccountId, String? cursor}) async =>
      ActivityLog(
        today: _today,
        entries: [
          for (final e in _entries)
            if (actorAccountId == null || e.actorId == actorAccountId) e,
        ],
        people: _people,
        coordinatorships: _coordinatorships,
      );
}
