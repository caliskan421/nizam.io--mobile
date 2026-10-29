import 'package:meta/meta.dart';

/// Koordinatörlüğün alt birimi (ayrıntı "Birimler" sekmesi). Sayılar sunucunun verdiği
/// değerlerdir (örnek kaynakta sabittir).
@immutable
final class CoordinatorshipUnit {
  const CoordinatorshipUnit({
    required this.name,
    required this.leadId,
    required this.total,
    required this.done,
  });

  final String name;

  /// Birimin sorumlusu (kişi kimliği; null → koordinatör yok).
  final String? leadId;
  final int total;
  final int done;

  double get ratio => total == 0 ? 0 : done / total;
}

/// Koordinatörlükteki son etkinliklerden biri (ayrıntı "Hakkında" sekmesi).
@immutable
final class CoordinatorshipEvent {
  const CoordinatorshipEvent({
    required this.actorId,
    required this.action,
    required this.target,
    required this.at,
  });

  /// Yapan kişinin kimliği (görev kataloğundaki kişi).
  final String actorId;

  /// Eylem cümlesi ("tarih talebi gönderdi").
  final String action;

  /// Hedef ("Hidrofor sistemi kurulumu · 10.09 → 31.10").
  final String target;
  final DateTime at;
}

/// Görev kataloğunda olmayan, koordinatörlüğe özgü bilgiler: üst birim (tür), kuruluş,
/// açıklama, alt birimler, katalog dışındaki ek üyeler, arşiv/toplantı sayıları, ekip sohbeti ve
/// son etkinlik. Kimlik, ad, koordinatörler ve görevler kataloğun ([TaskCatalog]) verisidir.
@immutable
/// Kaynağın bildirdiği ayrıntı özeti (görev sayıları ve sezon ortalaması). Verilirse ayrıntı
/// ekranı bunu gösterir; verilmezse özet görev kataloğundan hesaplanır.
@immutable
final class CoordinatorshipReport {
  const CoordinatorshipReport({
    required this.done,
    required this.total,
    required this.late,
    required this.seasonRatio,
  });

  final int done;
  final int total;
  final int late;
  final double seasonRatio;
}

final class CoordinatorshipProfile {
  CoordinatorshipProfile({
    required this.code,
    required this.parent,
    required this.founded,
    required this.about,
    required List<CoordinatorshipUnit> units,
    required List<String> extraMembers,
    required this.archiveFiles,
    required this.meetings,
    required this.chatId,
    required List<CoordinatorshipEvent> events,
    this.reported,
  }) : units = List.unmodifiable(units),
       extraMembers = List.unmodifiable(extraMembers),
       events = List.unmodifiable(events);

  final String code;

  /// Üst birim (tür), ör. "Teknik altyapı".
  final String parent;
  final DateTime founded;
  final String about;
  final List<CoordinatorshipUnit> units;

  /// Katalogda kişi kaydı olmayan üyelerin adları (örnek ekip).
  final List<String> extraMembers;
  final int archiveFiles;

  /// Planlı toplantı sayısı.
  final int meetings;

  /// Kaynak özeti (örnek fikstürde prototip `D` kaydı); null → katalogdan hesap.
  final CoordinatorshipReport? reported;

  /// "Ekibe mesaj"ın açtığı sohbetin kimliği.
  final String chatId;

  /// Yeniden eskiye son etkinlik.
  final List<CoordinatorshipEvent> events;
}

/// Koordinatörlük ek bilgilerinin kaynağı (domain portu; gerçekleştirmeler `data/`).
abstract interface class CoordinatorshipProfileRepository {
  Future<List<CoordinatorshipProfile>> load();
}
