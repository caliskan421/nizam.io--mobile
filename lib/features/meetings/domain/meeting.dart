import 'package:meta/meta.dart';

import '../../../core/domain/page_slice.dart';

// Toplantı domain varlıkları (collaboration modülünün toplantı ve konferans uçları, `v0.12.0-api`).
//
// Takvimdeki `MeetingEntry` (calendar/domain/calendar.dart) [Meeting] liste satırından eşlenir
// (yerel gün/saat, başlık, departman adları).

/// Toplantı bağlamındaki rol (oluşturan, görüntüleyen, not yazarı). Sunucu değerleri
/// `admin`, `coordinator`, `member`; bilinmeyen/boş değer [unknown].
enum MeetingRole { admin, coordinator, member, unknown }

/// Yönetici yaşam döngüsü sonucu (`restored`, `purged`).
enum MeetingLifecycleStatus { restored, purged, unknown }

/// Davet kipi (COLLABORATION-K73): `coordinatorship` bağlı departmanların koordinatörleri (ve
/// `members_included` ise üyeleri); `person` yalnız tek tek seçilen katılımcılar. Kuruluşta
/// seçilir, değişmez.
enum MeetingInviteMode { coordinatorship, person, unknown }

/// Nottan açılan görevin önceliği (istekte: `dusuk`, `orta`, `yuksek`, `acil`).
enum MeetingTaskPriority { low, medium, high, urgent }

/// Konferans durumu: `starting` sağlayıcı onayı bekleniyor; `live` sürüyor; `ending` kapatıldı,
/// oda henüz kapanmadı.
enum ConferenceStatus { starting, live, ending, unknown }

/// Konferanstaki rol: `host` (toplantıyı yöneten), `speaker` (toplantıyı gören üye ve
/// katılımcı).
enum ConferenceRole { host, speaker, unknown }

/// Konferansa bağlı kişilerin son görüntüsü (COLLABORATION-K78). Uzlaştırma turunun gözlemidir,
/// yetki kararı değildir; hiç gözlenmediyse [count] 0 ve [observedAt] null.
@immutable
final class ConferenceConnected {
  const ConferenceConnected({
    required this.count,
    required this.accountIds,
    this.observedAt,
  });

  static const none = ConferenceConnected(count: 0, accountIds: []);

  /// Tazelik sınırı: uzlaştırma aralığı varsayılan 1 dk (`NIZAMIO_VIDEO_RECONCILE_INTERVAL`);
  /// bundan eski gözlem "şu an bağlı" sayılmaz, zamanıyla gösterilir (F63 devri §5).
  static const freshFor = Duration(minutes: 3);

  final int count;

  /// Sıralı, tekil hesap kimlikleri.
  final List<String> accountIds;
  final DateTime? observedAt;

  /// Gözlenmiş ve [now] anında [freshFor]'dan eski değil (saat kayması: gelecekteki gözlem taze).
  bool isFreshAt(DateTime now) {
    final at = observedAt;
    return at != null && now.difference(at) <= freshFor;
  }

  /// Gözlemin yaşı (tam dakika); gözlenmediyse null.
  int? ageMinutes(DateTime now) {
    final at = observedAt;
    return at == null ? null : now.difference(at).inMinutes;
  }
}

/// Toplantıya bağlı görüntülü konferans (sunucu `Conference`; dış oda adı taşınmaz).
@immutable
final class MeetingConference {
  const MeetingConference({
    required this.id,
    required this.status,
    required this.startedAt,
    required this.startedByAccountId,
    this.connected = ConferenceConnected.none,
  });

  final String id;
  final ConferenceStatus status;
  final DateTime startedAt;
  final String startedByAccountId;
  final ConferenceConnected connected;

  /// Bitirme isteği kabul edildi, oda kapanışı henüz okunmadı: `ending`, bağlı görüntüsü boş.
  MeetingConference get closing => MeetingConference(
    id: id,
    status: ConferenceStatus.ending,
    startedAt: startedAt,
    startedByAccountId: startedByAccountId,
  );
}

/// Toplantının en yeni biten konferansı (`last_conference`, COLLABORATION-K70). Süre
/// `endedAt − startedAt`; sistem kapanışında boş oda payı (5 dk) süreye dahildir.
@immutable
final class PastConference {
  const PastConference({required this.startedAt, required this.endedAt});

  final DateTime startedAt;
  final DateTime endedAt;
}

/// Konferansa katılım token'ı (`joinConference`). [token] SIRDIR: log'a, hata metnine ve
/// kalıcı depoya yazılmaz; [toString] token'ı içermez. Kısa ömürlüdür ([expiresAt]); katılmadan
/// hemen önce alınır.
@immutable
final class ConferenceJoinToken {
  const ConferenceJoinToken({
    required this.token,
    required this.url,
    required this.expiresAt,
    required this.role,
  });

  final String token;

  /// İstemcinin bağlanacağı genel adres (wss).
  final String url;
  final DateTime expiresAt;
  final ConferenceRole role;

  @override
  String toString() => 'ConferenceJoinToken(…)';
}

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
    this.place,
    this.inviteMode = MeetingInviteMode.coordinatorship,
    this.deletedAt,
    this.deletedByName,
    this.summary,
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

  /// Toplantı yeri (düz metin); belirtilmemişse null (COLLABORATION-K76).
  final String? place;
  final MeetingInviteMode inviteMode;

  /// Yumuşak silinmişse silinme anı.
  final DateTime? deletedAt;

  /// Silenin adı (yalnız silinenler listesinde; eski silinmelerde ya da ad bilinmiyorsa null).
  final String? deletedByName;

  /// Liste satırının özeti (yalnız `listMeetings` satırında; diğer görüntülerde null).
  final MeetingSummary? summary;

  bool get byPerson => inviteMode == MeetingInviteMode.person;

  /// Yer metnindeki ilk http(s) bağlantısı (ör. çevrim içi toplantı); yoksa null.
  Uri? get placeLink {
    final match = _link.firstMatch(place ?? '');
    final uri = match == null ? null : Uri.tryParse(match.group(0)!);
    return uri != null && uri.host.isNotEmpty ? uri : null;
  }

  static final _link = RegExp(r'https?://\S+', caseSensitive: false);

  Meeting withSummary(MeetingSummary s) => Meeting(
    id: id,
    programId: programId,
    ownerDepartmentId: ownerDepartmentId,
    title: title,
    meetingDate: meetingDate,
    membersIncluded: membersIncluded,
    createdByAccountId: createdByAccountId,
    createdByRole: createdByRole,
    createdAt: createdAt,
    updatedAt: updatedAt,
    departments: departments,
    place: place,
    inviteMode: inviteMode,
    deletedAt: deletedAt,
    deletedByName: deletedByName,
    summary: s,
  );
}

/// Liste ucundaki konferans durumu: `none` hiç açılmadı; `starting`/`live`/`ending` açık
/// konferansın durumu; `ended` açık konferans yok, son konferans bitti.
enum SummaryConferenceStatus { none, starting, live, ending, ended, unknown }

/// Toplantı satırı özeti (sunucu `MeetingSummary`, COLLABORATION-K70/K78): kart sayaçları ve
/// konferans durumu. Ayrıntıdan da türetilir ([MeetingSummary.of]); açık ayrıntı yazdıkça liste
/// kartı ağ isteği olmadan güncellenir.
@immutable
final class MeetingSummary {
  const MeetingSummary({
    required this.agendaTotal,
    required this.agendaChecked,
    required this.noteCount,
    required this.participantCount,
    required this.conferenceStatus,
    required this.connectedCount,
    this.conferenceStartedAt,
    this.conferenceEndedAt,
  });

  /// Ayrıntının güncel sayaçları ([notes]: okunan bütün notların sayısı). Açık konferans varsa
  /// onun, yoksa son biten konferansın anları.
  factory MeetingSummary.of(MeetingDetail d, {required int notes}) {
    final c = d.conference;
    final last = d.lastConference;
    return MeetingSummary(
      agendaTotal: d.agenda.length,
      agendaChecked: d.agenda.where((a) => a.isChecked).length,
      noteCount: notes,
      participantCount: d.participants.length,
      conferenceStatus: c != null
          ? switch (c.status) {
              ConferenceStatus.starting => SummaryConferenceStatus.starting,
              ConferenceStatus.live => SummaryConferenceStatus.live,
              ConferenceStatus.ending => SummaryConferenceStatus.ending,
              ConferenceStatus.unknown => SummaryConferenceStatus.unknown,
            }
          : last != null
          ? SummaryConferenceStatus.ended
          : SummaryConferenceStatus.none,
      conferenceStartedAt: c?.startedAt ?? last?.startedAt,
      conferenceEndedAt: c == null ? last?.endedAt : null,
      connectedCount: c?.connected.count ?? 0,
    );
  }

  final int agendaTotal;
  final int agendaChecked;
  final int noteCount;
  final int participantCount;
  final SummaryConferenceStatus conferenceStatus;

  /// `starting`/`live` iken null; `ending`/`ended` iken kapanma anı.
  final DateTime? conferenceStartedAt;
  final DateTime? conferenceEndedAt;

  /// Bağlı kişi sayısı (`none`/`ended` iken 0).
  final int connectedCount;
}

/// Katılımcının toplantının programındaki ekip satırı (COLLABORATION-K72; görüntüdür).
@immutable
final class ParticipantTeam {
  const ParticipantTeam({
    required this.departmentId,
    required this.departmentName,
    required this.coordinator,
  });

  final String departmentId;

  /// Departmanın programdaki adı.
  final String departmentName;

  /// Oradaki rol koordinatör mü (değilse üye).
  final bool coordinator;
}

/// Toplantı katılımcısı.
@immutable
final class MeetingParticipant {
  const MeetingParticipant({
    required this.accountId,
    required this.fullName,
    this.teams = const [],
  });

  final String accountId;
  final String fullName;

  /// Programdaki ekip satırları; ekip satırı olmayan (yalnız yönetici) katılımcıda boş.
  final List<ParticipantTeam> teams;
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
    required this.editRevision,
  });

  final String id;
  final String meetingId;

  /// İçeriğin düzenleme sürümü (`edit_revision`, ADR-0027); düzenleme `expected_revision`
  /// olarak geri gönderir.
  final int editRevision;

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
    this.conference,
    this.lastConference,
    this.conferenceAvailable = false,
  });

  final Meeting meeting;

  /// Sunucunun bildirdiği görüntüleyen rolü (istemci türetmez).
  final MeetingRole viewerRole;
  final List<MeetingParticipant> participants;
  final List<AgendaItem> agenda;

  /// Notların ilk sayfası; devamı `MeetingsRepository.listNotes` ile.
  final PageSlice<MeetingNote> notes;

  /// Aktif ya da kapanmakta olan konferans; yoksa `null`.
  final MeetingConference? conference;

  /// En yeni biten konferans; [conference] ile ikisi de null ise hiç konferans açılmadı.
  final PastConference? lastConference;

  /// Bağlı video sağlayıcısı oda açabiliyor mu (sağlayıcı `none` iken `false`). Başlat
  /// düğmesi buna göre gösterilir.
  final bool conferenceAvailable;

  MeetingDetail copyWith({
    List<MeetingParticipant>? participants,
    List<AgendaItem>? agenda,
    MeetingConference? Function()? conference,
  }) => MeetingDetail(
    meeting: meeting,
    viewerRole: viewerRole,
    participants: participants ?? this.participants,
    agenda: agenda ?? this.agenda,
    notes: notes,
    conference: conference == null ? this.conference : conference(),
    lastConference: lastConference,
    conferenceAvailable: conferenceAvailable,
  );
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
    this.place,
    this.inviteMode = MeetingInviteMode.coordinatorship,
  });

  final String title;

  /// Yer (en çok 200 karakter); null → yer yok.
  final String? place;

  /// `person` kipinde [departmentIds] tek eleman (sahip) ve [membersIncluded] `true` olamaz.
  final MeetingInviteMode inviteMode;

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

/// Toplantı güncellemesi; `null` alan değişmez. Departman seti yalnız yönetici yolunda; `person`
/// kipinde departman seti ve üye bayrağı gönderilmez (422). Kip değişmez.
@immutable
final class MeetingChanges {
  const MeetingChanges({
    this.title,
    this.meetingDate,
    this.departmentIds,
    this.membersIncluded,
    this.place,
  });

  final String? title;

  /// Boş dizge yeri kaldırır.
  final String? place;

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
