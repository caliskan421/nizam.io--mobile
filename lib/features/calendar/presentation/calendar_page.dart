import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/widgets/feedback/nz_pick_record.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/calendar_controller.dart';
import '../application/calendar_index_controller.dart';
import '../domain/calendar.dart';
import 'calendar/calendar_day.dart';
import 'calendar/calendar_grid.dart';

/// Takvim (prototip `calendar`): başlık + "Bugün" + "Seçili güne toplantı planla", ay/hafta
/// ızgarası ve seçili günün kayıtları. Seçili gün, ay ve kip denetleyicide yaşar; pencere
/// ölçüsüne bağlı değildir (yeniden boyutlanmada ve modül değişiminde korunur).
///
/// "Toplantı planla" seçili günle ortak toplantı penceresini açar; [onPlanMeeting] verilirse
/// (ör. tablet merkezi modal) onu çağırır.
class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key, this.onPlanMeeting});

  final ValueChanged<DateTime>? onPlanMeeting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(calendarIndexProvider);
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

    void retry() => ref.invalidate(calendarSourcesProvider);
    return NzPage.feed(
      onRetry: retry,
      topBar: const RootTopBar(),
      children: [
        _Header(onPlan: plan),
        // Prototip: bölüm aralığı 16, ızgara -6.
        const Gap(NizamioSpacing.gapMd),
        NzAsyncView<CalendarIndex>(
          value: index,
          onRetry: retry,
          data: (ix) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CalendarGrid(index: ix),
              const Gap(NizamioSpacing.space4),
              CalendarDay(index: ix, onPlanMeeting: plan),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.onPlan});

  final VoidCallback onPlan;

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
              label: l.uiCalendarPlanMeeting,
              excludeSemantics: true,
              onTap: onPlan,
              child: Material(
                color: c.primary,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onPlan,
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
