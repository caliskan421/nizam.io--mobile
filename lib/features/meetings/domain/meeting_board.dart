import 'package:meta/meta.dart';

import '../../../core/domain/turkish_collation.dart';
import 'meeting.dart';

// Toplantı listesi ve ayrıntısının saf karar mantığı (prototip `S_meetings` / `S_mdetail`):
// sekme ayrımı, gün grupları, arama, gündem sırası ve görüntüleyen izinleri.

/// Liste sekmeleri. Silinenler yalnız yöneticiye açıktır (COLLABORATION-K22).
enum MeetingsTab { upcoming, past, deleted }

/// Yaklaşan toplantının göreli grubu (hafta pazartesi başlar).
enum MeetingWhen { today, tomorrow, thisWeek, nextWeek, later }

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// Toplantının yerel günü.
DateTime meetingDay(Meeting m) => _day(m.meetingDate.toLocal());

/// İki yerel gün arasındaki takvim günü farkı (yaz saati kaymasından bağımsız).
int dayDiff(DateTime a, DateTime b) => DateTime.utc(
  a.year,
  a.month,
  a.day,
).difference(DateTime.utc(b.year, b.month, b.day)).inDays;

/// [today] ve sonrası yaklaşan; bugünkü toplantı gün boyunca yaklaşandadır (saat geçse de
/// "geçmiş"e düşmez).
bool isUpcoming(Meeting m, DateTime today) =>
    dayDiff(meetingDay(m), today) >= 0;

/// [day]'in [today]'e göre grubu.
MeetingWhen meetingWhen(DateTime day, DateTime today) {
  final r = dayDiff(day, today);
  if (r <= 0) return MeetingWhen.today;
  if (r == 1) return MeetingWhen.tomorrow;
  final toSunday = DateTime.daysPerWeek - today.weekday;
  if (r <= toSunday) return MeetingWhen.thisWeek;
  if (r <= toSunday + DateTime.daysPerWeek) return MeetingWhen.nextWeek;
  return MeetingWhen.later;
}

/// Liste grubu: yaklaşanlarda [when], geçmiş ve silinenlerde [month] (ayın 1'i).
@immutable
final class MeetingGroup {
  const MeetingGroup({required this.items, this.when, this.month});

  final MeetingWhen? when;
  final DateTime? month;
  final List<Meeting> items;
}

/// Görünür toplantılar + (yöneticiyse) silinenler.
@immutable
final class MeetingsBoard {
  MeetingsBoard({
    required List<Meeting> visible,
    List<Meeting>? deleted,
    this.truncated = false,
  }) : visible = List.unmodifiable(visible),
       deleted = deleted == null ? null : List.unmodifiable(deleted);

  final List<Meeting> visible;

  /// Silinmiş toplantılar; null → görüntüleyen yönetici değil (sekme gizli).
  final List<Meeting>? deleted;

  /// Sayfa tavanında kesildi (sunucuda daha fazla toplantı var).
  final bool truncated;

  /// Sekmenin toplantıları: yaklaşanlar eskiden yeniye, geçmiş ve silinenler yeniden eskiye.
  List<Meeting> of(MeetingsTab tab, DateTime today) {
    final list = switch (tab) {
      MeetingsTab.upcoming => [
        for (final m in visible)
          if (isUpcoming(m, today)) m,
      ],
      MeetingsTab.past => [
        for (final m in visible)
          if (!isUpcoming(m, today)) m,
      ],
      MeetingsTab.deleted => [...?deleted],
    };
    final asc = tab == MeetingsTab.upcoming;
    return list..sort(
      (a, b) => asc
          ? a.meetingDate.compareTo(b.meetingDate)
          : b.meetingDate.compareTo(a.meetingDate),
    );
  }

  MeetingsBoard copyWith({List<Meeting>? visible, List<Meeting>? deleted}) =>
      MeetingsBoard(
        visible: visible ?? this.visible,
        deleted: deleted ?? this.deleted,
        truncated: truncated,
      );
}

/// Başlık ya da koordinatörlük etiketiyle eşleşen toplantılar ([label]: departman kimliği →
/// ekrandaki kısa kod). Boş sorgu hepsini geçirir.
List<Meeting> searchMeetings(
  List<Meeting> list,
  String query,
  String Function(MeetingDepartment d) label,
) {
  final q = trLower(query.trim());
  if (q.isEmpty) return list;
  return [
    for (final m in list)
      if (trLower(
        [
          m.title,
          for (final d in m.departments) ...[label(d), d.name],
        ].join(' '),
      ).contains(q))
        m,
  ];
}

/// Sıralı listeyi ardışık gruplara böler.
List<MeetingGroup> groupMeetings(
  List<Meeting> sorted,
  MeetingsTab tab,
  DateTime today,
) {
  final out = <MeetingGroup>[];
  for (final m in sorted) {
    final day = meetingDay(m);
    final when = tab == MeetingsTab.upcoming ? meetingWhen(day, today) : null;
    final month = when == null ? DateTime(day.year, day.month) : null;
    final last = out.lastOrNull;
    if (last != null && last.when == when && last.month == month) {
      out[out.length - 1] = MeetingGroup(
        when: when,
        month: month,
        items: [...last.items, m],
      );
    } else {
      out.add(MeetingGroup(when: when, month: month, items: [m]));
    }
  }
  return out;
}

/// Gündem sırası: açık maddeler ilk eklenme sırasıyla (sunucu `sort_order`) üstte, işaretliler
/// işaretlenme anına göre altta. [held]: yeni işaretlenmiş ama henüz yerinden kaydırılmamış
/// maddeler (işaret hareketi bitene dek açıkların arasında, kendi sırasında durur).
List<AgendaItem> orderAgenda(
  List<AgendaItem> items, {
  Set<String> held = const {},
}) {
  bool open(AgendaItem a) => !a.isChecked || held.contains(a.id);
  final opens = [
    for (final a in items)
      if (open(a)) a,
  ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  final done =
      [
        for (final a in items)
          if (!open(a)) a,
      ]..sort((a, b) {
        final x = a.checkedAt, y = b.checkedAt;
        if (x == null || y == null) return a.sortOrder.compareTo(b.sortOrder);
        final d = x.compareTo(y);
        return d != 0 ? d : a.sortOrder.compareTo(b.sortOrder);
      });
  return [...opens, ...done];
}

/// Not süzgeci (prototip "Tümü / Göreve dönüşen / Benim").
enum NoteFilter { all, converted, mine }

/// [filter]'a uyan notlar (yeniden eskiye).
List<MeetingNote> filterNotes(
  List<MeetingNote> notes,
  NoteFilter filter,
  String? me,
) {
  final out = [
    for (final n in notes)
      if (switch (filter) {
        NoteFilter.all => true,
        NoteFilter.converted => n.convertedToWorkItemId != null,
        NoteFilter.mine => me != null && n.authorAccountId == me,
      })
        n,
  ];
  return out..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

/// Görüntüleyenin toplantıdaki yetkileri. Karar sunucudadır; bu sınıf yalnız hangi düğmenin
/// görüneceğini seçer (COLLABORATION-K16, K20, K21, K26, K28, K29, K32, K44, K74). Yönetim
/// sunucunun `viewer_role`'ündendir: `admin` ve `coordinator` yönetir, `member` (katılımcı
/// dahil) okur ve not yazar.
@immutable
final class MeetingPermissions {
  const MeetingPermissions({
    required this.role,
    required this.me,
    this.byPerson = false,
    this.coordinatesLinked = false,
  });

  /// Sunucunun bildirdiği görüntüleyen rolü.
  final MeetingRole role;

  /// Oturumdaki hesap.
  final String? me;

  /// Davet kipi `person` mi.
  final bool byPerson;

  /// Görüntüleyen toplantıya bağlı bir departmanın koordinatörü mü (`coordinatorship`
  /// kipinde katılımcı yönetimi yalnız ona açıktır; koordinatör rolü olmayan yönetici dahil
  /// başkası reddedilir, K21).
  final bool coordinatesLinked;

  bool get _manager =>
      role == MeetingRole.admin || role == MeetingRole.coordinator;

  /// Düzenle, sil, gündem yazma, konferans başlat/bitir, nottan görev.
  bool get canManage => _manager;

  /// `person` kipinde yönetici ve yöneten oluşturan; `coordinatorship` kipinde bağlı
  /// departmanın koordinatörü (K21).
  bool get canManageParticipants => byPerson ? _manager : coordinatesLinked;

  /// Not ekleme toplantıyı gören herkese açıktır.
  bool get canAddNote => role != MeetingRole.unknown;

  bool _mine(MeetingNote n) => me != null && n.authorAccountId == me;

  /// Yönetici ve koordinatör üye notu dışındakileri; üye yalnız kendi dönüşmemiş notunu.
  bool canEditNote(MeetingNote n) => _manager
      ? n.authorRole != MeetingRole.member
      : _mine(n) && n.convertedToWorkItemId == null;

  /// Yönetici ve koordinatör her notu; üye yalnız kendi dönüşmemiş notunu.
  bool canDeleteNote(MeetingNote n) =>
      _manager || (_mine(n) && n.convertedToWorkItemId == null);

  bool canConvertNote(MeetingNote n) =>
      _manager && n.convertedToWorkItemId == null;
}
