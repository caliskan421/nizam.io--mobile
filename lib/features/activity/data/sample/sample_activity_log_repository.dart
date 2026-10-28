import '../../domain/activity_log.dart';

part 'sample_activity_log_data.dart';

/// GELİŞTİRME ÖRNEĞİ — gerçek servis değildir. Prototipteki işlem geçmişini döner; ağ isteği
/// atmaz. Bileşim kökünde (`activity_module.dart`) tek yerde bağlanır.
final class SampleActivityLogRepository implements ActivityLogRepository {
  @override
  Future<ActivityLog> load() async => ActivityLog(
    today: _today,
    entries: _entries,
    people: _people,
    coordinatorships: _coordinatorships,
  );
}
