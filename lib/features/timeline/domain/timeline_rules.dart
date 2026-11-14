import 'package:meta/meta.dart';

import '../../tasks/tasks.dart';
import 'timeline.dart';

// Zaman çizelgesinin rol kuralları (prototip `gantt`, koordinatör dalı). Telefon ve tablet
// aynı kuralları buradan okur; arayüz yalnız sonucu gösterir, yetkiyi sunucu denetler.

/// Koordinatörün onaysız ileri alabileceği en çok gün (prototip `RULE_D`). Fazlası ya da
/// başlangıç değişikliği tarih talebine gider (`RULE_R`). Tek kaynak görevlerdeki ürün kuralı.
const timelineDirectDays = maxDirectExtendDays;

/// Tarih talebi gerekçesinin en kısa boyu (prototip `whyOk`).
const timelineReasonMin = 3;

/// Koordinatör görünümünün iki sekmesi: koordinatörlüğün görevleri ve kendi görevleri.
enum TimelineTab { department, mine }

/// Etkin görünümün zaman çizelgesindeki izdüşümü. [department] null → yönetici görünümü
/// (bütün koordinatörlükler, koordinatörlük seçici açık); dolu → tek koordinatörlük, seçici
/// gizli, gruplar durum başlıkları (açık / tamamlanan).
@immutable
final class TimelineLens {
  const TimelineLens({
    this.department,
    this.tabs = false,
    this.mineOnly = false,
    this.directRule = false,
  });

  /// Yönetici görünümü (bugünkü davranış).
  static const admin = TimelineLens();

  /// Sabit koordinatörlük (Koordinatör/Üye görünümü); yöneticide null.
  final String? department;

  /// İki sekme gösterilir (Koordinatör görünümü).
  final bool tabs;

  /// Yalnız oturumdaki kişinin görevleri (Üye görünümü ya da "Görevlerim" sekmesi).
  final bool mineOnly;

  /// Doğrudan değişiklik 7 gün kuralına bağlı (Koordinatör görünümü); yönetici serbest kaydeder.
  final bool directRule;

  bool get locked => department != null;

  /// Etkin görünümden: yönetici → [admin]; koordinatör → sekmeli, 7 gün kuralı; üye → yalnız
  /// kendi görevleri. [department] etkin koordinatörlük; boşsa hiçbir görev eşleşmez.
  factory TimelineLens.of({
    required bool adminView,
    required bool coordinatorView,
    required String? department,
    required TimelineTab tab,
  }) {
    if (adminView) return admin;
    return TimelineLens(
      department: department ?? '',
      tabs: coordinatorView,
      mineOnly: !coordinatorView || tab == TimelineTab.mine,
      directRule: coordinatorView,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TimelineLens &&
      other.department == department &&
      other.tabs == tabs &&
      other.mineOnly == mineOnly &&
      other.directRule == directRule;

  @override
  int get hashCode => Object.hash(department, tabs, mineOnly, directRule);
}

/// Sekme veri kümesi: kilitli görünümde yalnız etkin koordinatörlüğün görevleri; [lens]
/// `mineOnly` ise yalnız [me]'ye atananlar. Yönetici görünümünde küme değişmez.
List<TaskItem> timelineTaskSet(
  Iterable<TaskItem> tasks,
  TimelineLens lens,
  String me,
) => [
  for (final t in tasks)
    if ((!lens.locked || t.coordinatorship == lens.department) &&
        (!lens.mineOnly || t.assignees.contains(me)))
      t,
];

/// Durum grupları (kilitli görünüm): açık görevler ve tamamlananlar. Kodlar koordinatörlük
/// kodlarıyla çakışmaz; ad sunumda yerelleştirilir.
const timelineOpenGroup = '@open';
const timelineDoneGroup = '@done';

bool isTimelineStatusGroup(String code) =>
    code == timelineOpenGroup || code == timelineDoneGroup;

/// Seçili görevin tarih değişikliğinin yolu.
sealed class TimelineDateChange {
  const TimelineDateChange();

  /// Kayıtlı aralık [from] ile taslak [to] arasındaki fark. [directRule] (koordinatör):
  /// başlangıç aynı, bitiş 1–7 gün ileri → [TimelineExtend] (`…/extend`); bitiş en çok 7 gün
  /// geri → [TimelineSave]; başlangıç değişirse ya da bitiş 7 günü aşarsa [TimelineRequest].
  /// Kuralsız görünümde (yönetici) her değişiklik [TimelineSave].
  static TimelineDateChange of(
    DayRange from,
    DayRange to, {
    required bool directRule,
  }) {
    final ds = to.start - from.start;
    final de = to.end - from.end;
    if (ds == 0 && de == 0) return const TimelineNoChange();
    if (!directRule) return const TimelineSave();
    if (ds != 0 || de.abs() > timelineDirectDays) {
      return const TimelineRequest();
    }
    return de > 0 ? TimelineExtend(de) : const TimelineSave();
  }
}

final class TimelineNoChange extends TimelineDateChange {
  const TimelineNoChange();
}

/// Doğrudan kayıt (tarih düzenleme yazımı).
final class TimelineSave extends TimelineDateChange {
  const TimelineSave();
}

/// Doğrudan süre uzatma (`POST /v1/work-items/{id}/extend`, 1–7 gün).
final class TimelineExtend extends TimelineDateChange {
  const TimelineExtend(this.days);

  final int days;

  @override
  bool operator ==(Object other) =>
      other is TimelineExtend && other.days == days;

  @override
  int get hashCode => days.hashCode;
}

/// Yönetici onayına giden tarih talebi (gerekçe zorunlu).
final class TimelineRequest extends TimelineDateChange {
  const TimelineRequest();
}

/// "Bitişi bugüne çek" (`…/pull-end-date`, WORK-K43): tamamlanmış, planı daha önce çekilmemiş
/// ([TaskItem.plannedEnd] yok) ve bitişi bugünden sonra olan görev.
bool canPullEndToToday(TaskItem t, DateTime today) {
  if (!t.isDone || t.plannedEnd != null) return false;
  final due = DateTime.utc(t.due.year, t.due.month, t.due.day);
  return DateTime.utc(today.year, today.month, today.day).isBefore(due);
}
