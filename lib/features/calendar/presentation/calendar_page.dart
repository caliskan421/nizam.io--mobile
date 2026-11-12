import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/cache_owner.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/motion/page_content_entrance.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/widgets/feedback/nz_pick_record.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../meetings/meetings.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/calendar_controller.dart';
import '../application/calendar_index_controller.dart';
import '../domain/calendar.dart';
import 'calendar/calendar_day.dart';
import 'calendar/calendar_grid.dart';
import 'calendar/calendar_texts.dart';
import 'calendar/calendar_week.dart';

/// Takvim (prototip `calendar`): başlık + "Bugün" + "Seçili güne ekle" (toplantı ya da görev), ay/hafta
/// ızgarası ve seçili günün kayıtları. Seçili gün, ay ve kip denetleyicide yaşar; pencere
/// ölçüsüne bağlı değildir (yeniden boyutlanmada ve modül değişiminde korunur).
///
/// Tablette açık kayıt yokken sayfa tam genişliktir; [calendarWideMinWidth] üstünde ızgara solda,
/// seçili gün sağda yan yana durur.
///
/// "Toplantı planla" seçili günle ortak toplantı penceresini açar; [onPlanMeeting] verilirse
/// (ör. tablet merkezi modal) onu çağırır.
/// Takvimden "bu gün başlayan görev"in varsayılan süresi (yeni görev formuyla aynı, 14 gün).
const _taskSpanDays = 14;

/// Izgara ve seçili günün yan yana durduğu en küçük içerik genişliği.
const calendarWideMinWidth = 840.0;

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key, this.onPlanMeeting});

  final ValueChanged<DateTime>? onPlanMeeting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dizin toplantı listesinden (o da kataloktan sonra) kurulur: liste başka hesabın/programın
    // ise takvim de görünmez (yükleniyor ya da yalnız hata).
    final owned = ref.read(meetingsBoardControllerProvider.notifier).ownsValue;
    final index = CacheOwnership.ownedOnly(
      ref.watch(calendarIndexProvider),
      owned: owned,
    );
    void plan() {
      final ix = index.value;
      if (ix == null) return;
      final day = ref.read(calendarControllerProvider).selectedOn(ix.today);
      final cb = onPlanMeeting;
      if (cb != null) {
        cb(day);
      } else {
        showMeetingSheet(context, date: day);
      }
    }

    // "+" ve boş günün "Bu güne ekle"si: seçili güne toplantı ya da görev (bu gün başlayan,
    // bu güne kadar bitecek). Görev açma yetkisi yoksa doğrudan toplantı planlanır.
    void add() {
      final ix = index.value;
      if (ix == null) return;
      if (!ref.read(canCreateTaskProvider)) {
        plan();
        return;
      }
      final l = context.l10n;
      final day = ref.read(calendarControllerProvider).selectedOn(ix.today);
      final spanEnd = DateTime(day.year, day.month, day.day + _taskSpanDays);
      final dueStart = day.isBefore(ix.today) ? day : ix.today;
      NzFlyoutMenu.show(
        context,
        semanticLabel: l.uiCalendarAdd,
        entries: [
          NzFlyoutSection(l.dayTitle(day)),
          NzFlyoutItem(
            label: l.uiCalendarPlan,
            caption: l.uiCalendarAddMeetingCaption,
            icon: NzIcons.video,
            onSelected: plan,
          ),
          NzFlyoutItem(
            label: l.uiCalendarAddTaskStart,
            caption: l.dayRange(day, spanEnd),
            icon: NzIcons.tasks,
            onSelected: () => showNewTaskSheet(
              context,
              resetTarget: true,
              start: day,
              end: spanEnd,
            ),
          ),
          NzFlyoutItem(
            label: l.uiCalendarAddTaskDue,
            caption: l.dayRange(dueStart, day),
            icon: NzIcons.flag,
            onSelected: () => showNewTaskSheet(
              context,
              resetTarget: true,
              start: dueStart,
              end: day,
            ),
          ),
        ],
      );
    }

    // Yeniden deneme yalnız dokunuşla (A3): hata veren kaynak yeniden okunur.
    void retry() {
      if (ref.read(meetingsBoardControllerProvider).hasError) {
        ref.invalidate(meetingsBoardControllerProvider);
      }
      if (ref.read(taskCatalogControllerProvider).hasError) {
        ref.invalidate(taskCatalogControllerProvider);
      }
    }

    // Yeniden ziyaret: takvimin iki kaynağı (toplantı listesi, görev kataloğu) bayatsa arka
    // planda yeniden okunur; dizin onları izlediği için eski takvim yerinde güncellenir.
    void revisit() {
      ref.read(meetingsBoardControllerProvider.notifier).refreshIfStale();
      ref.read(taskCatalogControllerProvider.notifier).refreshIfStale();
    }

    // Aşağı çekerek yenileme: iki kaynak birlikte yeniden okunur. Önce katalog başlar (toplantı
    // listesi onun erişim bilgisini okur). İlk hata fırlar ve ortak yenileme kabuğunda tek
    // bildirim olur; önceki takvim yerinde kalır.
    Future<void> refresh() => Future.wait([
      ref.read(taskCatalogControllerProvider.notifier).refresh(),
      ref.read(meetingsBoardControllerProvider.notifier).refresh(),
    ]);

    return NzPage.feed(
      width: NzContentWidth.wide,
      onRetry: retry,
      onRefresh: refresh,
      onRevisit: revisit,
      topBar: const RootTopBar(),
      children: [
        _Header(onAdd: add),
        // Prototip: bölüm aralığı 16, ızgara -6.
        const Gap(NizamioSpacing.gapMd),
        NzAsyncView<CalendarIndex>(
          value: index,
          onRetry: retry,
          data: (ix) => LayoutBuilder(
            builder: (context, box) {
              // İlk veri gelişinde ızgara ve gün listesi kademeli girer (iskelet animasyonsuz
              // yer değiştirmesin). [replay] verinin bugünü: gün/ay seçimi yeniden oynatmaz.
              Widget enter(int index, Widget child) =>
                  NzEntrance(replay: ix.today, index: index, child: child);
              final grid = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CalendarGrid(index: ix),
                  // Kesik kaynak (toplantı listesi ya da katalog): boş gün gerçekte boş
                  // olmayabilir.
                  if (ix.truncated) ...[
                    const Gap(NizamioSpacing.space2),
                    Text(
                      context.l10n.uiListsTruncated,
                      textAlign: TextAlign.center,
                      style: context.text.caption.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
                  ],
                ],
              );
              if (box.maxWidth < calendarWideMinWidth) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    enter(0, grid),
                    const Gap(NizamioSpacing.space4),
                    enter(
                      1,
                      CalendarDay(index: ix, onPlanMeeting: plan, onAdd: add),
                    ),
                    const Gap(NizamioSpacing.gapLg),
                    enter(2, CalendarThisWeek(index: ix)),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sol sütun: ızgara + "bu hafta" (ızgaranın altındaki boşluk); sağda gün.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        enter(0, grid),
                        const Gap(NizamioSpacing.gapLg),
                        enter(2, CalendarThisWeek(index: ix)),
                      ],
                    ),
                  ),
                  const Gap(NizamioSpacing.space10),
                  Expanded(
                    child: enter(
                      1,
                      CalendarDay(
                        index: ix,
                        onPlanMeeting: plan,
                        onAdd: add,
                        divided: false,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.onAdd});

  final VoidCallback onAdd;

  static const _fade = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final today = ref.watch(
      calendarIndexProvider.select((v) => v.value?.today),
    );
    final isToday = ref.watch(
      calendarControllerProvider.select(
        (v) => today == null || v.isTodayOn(today),
      ),
    );
    final ctrl = ref.read(calendarControllerProvider.notifier);
    final fade = NzMotion.of(context, _fade);
    return NzPageHeader(
      title: l.uiCalendarTitle,
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              button: true,
              enabled: !isToday,
              label: l.uiCalendarToday,
              excludeSemantics: true,
              onTap: isToday ? null : ctrl.goToday,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isToday ? null : ctrl.goToday,
                child: AnimatedContainer(
                  duration: fade,
                  curve: Curves.ease,
                  height: NizamioSize.tap,
                  padding: const EdgeInsets.symmetric(
                    horizontal: NizamioSpacing.space4,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(NizamioRadius.pill),
                    border: Border.all(
                      color: isToday ? c.border : c.borderControl,
                    ),
                  ),
                  child: AnimatedDefaultTextStyle(
                    duration: fade,
                    curve: Curves.ease,
                    style: t.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isToday ? c.textFaint : c.text,
                    ),
                    child: Text(l.uiCalendarToday),
                  ),
                ),
              ),
            ),
            const Gap(NizamioSpacing.space2),
            Semantics(
              button: true,
              label: l.uiCalendarAdd,
              excludeSemantics: true,
              onTap: onAdd,
              child: Material(
                color: c.primary,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onAdd,
                  child: SizedBox.square(
                    dimension: NizamioSize.tap,
                    child: Center(
                      child: NzIcon(
                        NzIcons.add,
                        size: NizamioSize.iconSizeSm,
                        color: c.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Tablet sağ bölmesinde takvimin varsayılanı (prototip `TB_DEF.calendar = 'empty'`).
class CalendarEmptyDetail extends StatelessWidget {
  const CalendarEmptyDetail({super.key});

  @override
  Widget build(BuildContext context) => NzPickRecord(
    title: context.l10n.uiCalendarPickTitle,
    message: context.l10n.uiCalendarPickBody,
  );
}
