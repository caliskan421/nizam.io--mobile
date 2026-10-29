import 'package:meta/meta.dart';

import '../../../core/domain/page_slice.dart';

// Toplantı domain varlıkları (collaboration modülünün toplantı uçları, `v0.2.0-api`).
//
// Takvimdeki `MeetingEntry` (calendar/domain/calendar.dart) aynı kavramın örnek veriden türeyen
// görünümüdür; örtüşen alanlar (başlık, tarih, departmanlar, gündem, katılımcı) takvim
// entegrasyonunda bu tiplerden doldurulacak. Eşleme envanterdedir
// (docs/yurutme/servis-katmani/envanter-records-meetings.md).

/// Toplantı bağlamındaki rol (oluşturan, görüntüleyen, not yazarı). Sunucu değerleri
/// `admin`, `coordinator`, `member`; bilinmeyen/boş değer [unknown].
enum MeetingRole { admin, coordinator, member, unknown }

/// Yönetici yaşam döngüsü sonucu (`restored`, `purged`).
enum MeetingLifecycleStatus { restored, purged, unknown }

/// Nottan açılan görevin önceliği (istekte: `dusuk`, `orta`, `yuksek`, `acil`).
enum MeetingTaskPriority { low, medium, high, urgent }

/// Toplantıya bağlı departman; ad bağ kurulduğu andaki kopyadır.
@immutable
final class MeetingDepartment {
  const MeetingDepartment({required this.id, required this.name});

  final String id;
  final String name;
}

/// Toplantı (sunucu `Meeting`). Liste satırı; katılımcı ve gündem yalnız [MeetingDetail]'de.
@immutable
final class Meeting {
  const Meeting({
    required this.id,
    required this.programId,
    required this.ownerDepartmentId,
    required this.title,
    required this.meetingDate,
    required this.membersIncluded,
    required this.createdByAccountId,
    required this.createdByRole,
    required this.createdAt,
    required this.updatedAt,
    required this.departments,
    this.deletedAt,
  });

  final String id;
  final String programId;

  /// Sahip departman (= [departments]'ın ilki).
  final String ownerDepartmentId;
  final String title;

  /// Toplantı anı (UTC). Yerel güne kurulum saat dilimiyle çevrilir.
  final DateTime meetingDate;

  /// Üyeler de görür (COLLABORATION-K19).
  final bool membersIncluded;
  final String createdByAccountId;

  /// Yalnız [MeetingRole.admin] ya da [MeetingRole.coordinator] beklenir.
  final MeetingRole createdByRole;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MeetingDepartment> departments;

  /// Yumuşak silinmişse silinme anı.
  final DateTime? deletedAt;
}

/// Toplantı katılımcısı.
@immutable
final class MeetingParticipant {
  const MeetingParticipant({required this.accountId, required this.fullName});

  final String accountId;
  final String fullName;
}

/// Gündem maddesi.
@immutable
final class AgendaItem {
  const AgendaItem({
    required this.id,
    required this.meetingId,
    required this.title,
    required this.sortOrder,
    required this.isChecked,
    required this.createdAt,
    this.checkedAt,
    this.checkedByAccountId,
  });

  final String id;
  final String meetingId;
  final String title;
  final int sortOrder;
  final bool isChecked;
  final DateTime createdAt;
  final DateTime? checkedAt;
  final String? checkedByAccountId;
}

/// Toplantı notu.
@immutable
final class MeetingNote {
  const MeetingNote({
    required this.id,
    required this.meetingId,
    required this.authorName,
    required this.authorRole,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.authorAccountId,
    this.convertedToWorkItemId,
  });

  final String id;
  final String meetingId;

  /// Yazar hesabı silinmişse `null`.
  final String? authorAccountId;
  final String authorName;

  /// Eski notlarda sunucu boş döner → [MeetingRole.unknown].
  final MeetingRole authorRole;
  final String content;

  /// Not göreve dönüştürüldüyse görev kimliği.
  final String? convertedToWorkItemId;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// Toplantı ayrıntısı: katılımcılar, gündem ve notların ilk sayfası.
@immutable
final class MeetingDetail {
  const MeetingDetail({
    required this.meeting,
    required this.viewerRole,
    required this.participants,
    required this.agenda,
    required this.notes,
  });

  final Meeting meeting;

  /// Sunucunun bildirdiği görüntüleyen rolü (istemci türetmez).
  final MeetingRole viewerRole;
  final List<MeetingParticipant> participants;
  final List<AgendaItem> agenda;

  /// Notların ilk sayfası; devamı `MeetingsRepository.listNotes` ile.
  final PageSlice<MeetingNote> notes;
}

/// İşlem sonrası en iyi çabalı yan etkiler (arıza işlemi geri almaz).
@immutable
final class MeetingSideEffects {
  const MeetingSideEffects({
    required this.failedMessages,
    required this.eventFailed,
  });

  /// Gönderilemeyen toplantı mesajı sayısı.
  final int failedMessages;

  /// Olay (bildirim) yazılamadı.
  final bool eventFailed;
}

/// `createMeeting` sonucu.
@immutable
final class MeetingCreated {
  const MeetingCreated({
    required this.meeting,
    required this.failedParticipants,
    required this.sideEffects,
  });

  final Meeting meeting;

  /// Yazılamayan katılımcı kimlikleri (sunucu `null` → boş).
  final List<String> failedParticipants;
  final MeetingSideEffects sideEffects;
}

/// `updateMeeting` sonucu.
@immutable
final class MeetingRevised {
  const MeetingRevised({required this.meeting, required this.sideEffects});

  final Meeting meeting;
  final MeetingSideEffects sideEffects;
}

/// Geri yükleme / kalıcı silme sonucu.
@immutable
final class MeetingLifecycleResult {
  const MeetingLifecycleResult({required this.meetingId, required this.status});

  final String meetingId;
  final MeetingLifecycleStatus status;
}

/// Notun göreve dönüşümü sonucu.
@immutable
final class NoteConversion {
  const NoteConversion({required this.workItemId, required this.note});

  final String workItemId;
  final MeetingNote note;
}

/// Yeni toplantı girdisi.
@immutable
final class MeetingDraft {
  const MeetingDraft({
    required this.title,
    required this.meetingDate,
    required this.departmentIds,
    this.participantIds,
    this.membersIncluded,
    this.agendaItems,
    this.isInstant,
  });

  final String title;

  /// UTC ise RFC 3339 (`Z`) gönderilir; yerel (UTC olmayan) değer saat dilimsiz duvar saati
  /// (`YYYY-MM-DDTHH:MM:SS`) olarak gider ve sunucu onu KURULUM saat diliminde yorumlar.
  final DateTime meetingDate;

  /// En az bir departman; ilki sahip departmandır.
  final List<String> departmentIds;
  final List<String>? participantIds;
  final bool? membersIncluded;

  /// İlk gündem maddeleri (aynı işlemde yazılır).
  final List<String>? agendaItems;

  /// `true` ise koordinatörlere toplantı mesajı gönderilmez.
  final bool? isInstant;
}

/// Toplantı güncellemesi; `null` alan değişmez. Departman seti yalnız yönetici yolunda.
@immutable
final class MeetingChanges {
  const MeetingChanges({
    this.title,
    this.meetingDate,
    this.departmentIds,
    this.membersIncluded,
  });

  final String? title;

  /// [MeetingDraft.meetingDate] ile aynı kural.
  final DateTime? meetingDate;
  final List<String>? departmentIds;
  final bool? membersIncluded;
}

/// Nottan görev açma girdisi.
@immutable
final class NoteTaskDraft {
  const NoteTaskDraft({
    required this.startDate,
    required this.endDate,
    this.title,
    this.priority,
    this.departmentId,
    this.assigneeAccountIds,
  });

  /// Gün (saat yok sayılır); bugünden ve [endDate]'ten sonra olamaz.
  final DateTime startDate;
  final DateTime endDate;

  /// Boşsa notun ilk 100 karakteri.
  final String? title;

  /// `null` → sunucu varsayılanı (`orta`).
  final MeetingTaskPriority? priority;
  final String? departmentId;
  final List<String>? assigneeAccountIds;
}
