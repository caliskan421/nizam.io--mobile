import 'package:meta/meta.dart';

import '../../../core/telemetry/expected_failure.dart';

/// Kayıt türü (prototip tür filtresi: Görev, Dosya, Toplantı, Mesaj, Hesap).
enum ActivityKind { task, file, meeting, message, account }

/// Eylem kodunun modül önekinden kayıt türü (`work.` görev, `records.` dosya, `collaboration.`
/// toplantı, `messaging.` mesaj; kalan her şey hesap/sistem).
ActivityKind activityKindOf(String actionCode) =>
    switch (actionCode.split('.').first) {
      'work' => ActivityKind.task,
      'records' => ActivityKind.file,
      'collaboration' => ActivityKind.meeting,
      'messaging' => ActivityKind.message,
      _ => ActivityKind.account,
    };

/// İşlem geçmişi kaydı (değiştirilemez denetim kaydı; sunucu `AuditEntry`).
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
    this.actionCode,
    this.subjectKind,
    this.subjectId,
    this.departmentId,
    this.failed = false,
  });

  /// Kararlı eylem kodu (`action_code`, ör. `work.item.transitioned`); görünen ad istemci
  /// sözlüğündedir (sunumda). null → [action] hazır metindir.
  final String? actionCode;

  /// Konu türü ve kimliği (`subject_kind`, `subject_id`; ör. `work_item`).
  final String? subjectKind;
  final String? subjectId;

  /// Kaydın departman kapsamı (`department_id`; koordinatörlük süzgeci).
  final String? departmentId;

  /// Sonuç `failed` (reddedilen girişim).
  final bool failed;

  /// Hedefi [target] olan kopya (görev kimliği → "KOD · başlık" çözümü).
  ActivityEntry withTarget(String target) => ActivityEntry(
    at: at,
    kind: kind,
    action: action,
    detail: detail,
    target: target,
    actorId: actorId,
    actorName: actorName,
    actionCode: actionCode,
    subjectKind: subjectKind,
    subjectId: subjectId,
    departmentId: departmentId,
    failed: failed,
  );

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
    this.nextCursor,
  }) : entries = List.unmodifiable(entries),
       people = List.unmodifiable(people),
       coordinatorships = List.unmodifiable(coordinatorships);

  final DateTime today;
  final List<ActivityEntry> entries;

  /// Filtrede önerilen yapan kişi kimlikleri.
  final List<String> people;

  /// Filtrede önerilen koordinatörlük kodları.
  final List<String> coordinatorships;

  /// Sunucuda daha eski kayıt varsa sonraki sayfanın imleci; yoksa null.
  final String? nextCursor;

  /// [page]'i bu kümenin sonuna ekler (daha eski kayıtlar); imleç [page]'inkidir.
  ActivityLog append(ActivityLog page) => ActivityLog(
    today: today,
    entries: [...entries, ...page.entries],
    people: {...people, ...page.people}.toList(),
    coordinatorships: {...coordinatorships, ...page.coordinatorships}.toList(),
    nextCursor: page.nextCursor,
  );
}

/// İşlem geçmişinin kaynağı (domain portu; gerçekleştirme `data/`, `GET /v1/audit/entries`).
abstract interface class ActivityLogRepository {
  /// Son kayıtlar (yeniden eskiye); [actorAccountId] verilirse yalnız o kişinin işlemleri.
  /// [cursor] önceki sayfanın [ActivityLog.nextCursor] değeridir.
  Future<ActivityLog> load({String? actorAccountId, String? cursor});
}

/// İşlem geçmişi bu hesaba kapalı (yalnız şirket yöneticisi okur; 403 `audit.not_authorized`).
final class ActivityUnavailable implements Exception, ExpectedFailure {
  const ActivityUnavailable();
}
