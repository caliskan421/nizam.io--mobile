import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/feedback/nz_progress_bar.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/calendar_controller.dart';
import '../../domain/calendar.dart';
import 'calendar_grid.dart';

/// Dönem kartları (ana sayfa / koordinatörlük KPI kutucuğu): Geçen hafta (bitişi düşen
/// görevlerin tamamlanan/geciken oranı), Bugün ve Gelecek hafta (biten, başlayan görev ve
/// toplantı). Dokunuş takvimde o dönemin ilk gününü seçer. Genişte yan yana, darda alt alta.
class CalendarPeriods extends ConsumerWidget {
  const CalendarPeriods({super.key, required this.index});

  final CalendarIndex index;

  /// Üç kartın yan yana sığdığı en küçük genişlik.
  static const _rowMinWidth = 600.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final ctrl = ref.read(calendarControllerProvider.notifier);
    final today = index.today;
    final last = weekOf(DateTime(today.year, today.month, today.day - 7));
    final next = weekOf(DateTime(today.year, today.month, today.day + 7));
    final past = index.period(last.first, last.last);
    final now = index.period(today, today);
    final ahead = index.period(next.first, next.last);

    // Yaklaşan dönem: biten (violet), başlayan (soluk), toplantı (toplantı rengi).
    NzKpiTile upcoming({
      required IconData icon,
      required Color tone,
      required String label,
      required CalendarPeriod p,
      required VoidCallback onTap,
    }) {
      final total = p.due + p.starts + p.meetings;
      final caption = [
        '${p.due} ${l.uiCalendarLeadEnd}',
        '${p.starts} ${l.uiCalendarLeadStart}',
        '${p.meetings} ${l.uiCalendarMeetingLc}',
      ].join(' · ');
      return NzKpiTile(
        icon: icon,
        tone: tone,
        label: label,
        value: '$total',
        segments: [
          NzBarSegment(p.due, c.kind(CalendarKind.task)),
          NzBarSegment(p.starts, c.textFaint),
          NzBarSegment(p.meetings, c.kind(CalendarKind.meeting)),
        ],
        caption: caption,
        onTap: onTap,
        semanticLabel: '$label: $total. $caption',
      );
    }

    final pastCaption = [
      '${past.done} ${l.uiCalendarDoneLc}',
      if (past.late > 0) '${past.late} ${l.uiCalendarLateLc}',
      '${past.meetings} ${l.uiCalendarMeetingLc}',
    ].join(' · ');
    final cards = [
      NzKpiTile(
        icon: NzIcons.history,
        tone: c.taskDone,
        label: l.uiCalendarLastWeek,
        value: '${past.done}/${past.due}',
        segments: [
          NzBarSegment(past.done, c.taskDone),
          NzBarSegment(past.late, c.danger),
        ],
        caption: pastCaption,
        onTap: () => ctrl.pick(last.first),
        semanticLabel:
            '${l.uiCalendarLastWeek}: ${past.done}/${past.due}. $pastCaption',
      ),
      upcoming(
        icon: NzIcons.calendar,
        tone: c.accentText,
        label: l.uiCalendarToday,
        p: now,
        onTap: ctrl.goToday,
      ),
      upcoming(
        icon: NzIcons.calendarMonth,
        tone: c.inProgress,
        label: l.uiCalendarNextWeekCard,
        p: ahead,
        onTap: () => ctrl.pick(next.first),
      ),
    ];
    return Semantics(
      label: l.uiCalendarPeriods,
      container: true,
      explicitChildNodes: true,
      child: LayoutBuilder(
        builder: (context, box) => box.maxWidth < _rowMinWidth
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: NizamioSpacing.gapMd,
                children: cards,
              )
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, card) in cards.indexed) ...[
                      if (i > 0) const Gap(NizamioSpacing.gapMd),
                      Expanded(child: card),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
