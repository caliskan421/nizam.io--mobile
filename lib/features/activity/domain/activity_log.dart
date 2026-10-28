import 'package:meta/meta.dart';

/// Kayıt türü (prototip tür filtresi: Görev, Dosya, Toplantı, Mesaj, Hesap).
enum ActivityKind { task, file, meeting, message, account }

/// İşlem geçmişi kaydı (değiştirilemez denetim kaydı).
@immutable
final class ActivityEntry {
  const ActivityEntry({
    required this.at,
    required this.kind,
    required this.action,
    required this.detail,
    required this.target,
    required this.actorId,
    required this.actorName,
  });

  final DateTime at;
  final ActivityKind kind;

  /// Eylem başlığı ("Toplantı notu ekledi").
  final String action;

  /// Ayrıntı (not metni, gündem maddesi, oturum bilgisi; boş olabilir).
  final String detail;

  /// Hedef ("Haftalık koordinasyon toplantısı", "ALT-7").
  final String target;

  /// Yapanın kişi kimliği (görev kataloğundaki kişi; katalogda olmayabilir).
  final String actorId;

  /// Kayıt anındaki görünen ad (denetim kaydı adı kendisi taşır).
  final String actorName;
}

/// İşlem geçmişi: kayıtlar (yeniden eskiye), verinin "bugün"ü ve filtre alt sayfasında önerilen
/// kişi / koordinatörlük seçenekleri.
@immutable
final class ActivityLog {
  ActivityLog({
    required this.today,
    required List<ActivityEntry> entries,
    required List<String> people,
    required List<String> coordinatorships,
  }) : entries = List.unmodifiable(entries),
       people = List.unmodifiable(people),
       coordinatorships = List.unmodifiable(coordinatorships);

  final DateTime today;
  final List<ActivityEntry> entries;

  /// Filtrede önerilen yapan kişi kimlikleri.
  final List<String> people;

  /// Filtrede önerilen koordinatörlük kodları.
  final List<String> coordinatorships;
}

/// İşlem geçmişinin kaynağı (domain portu; gerçekleştirmeler `data/`).
abstract interface class ActivityLogRepository {
  Future<ActivityLog> load();
}
