import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/calendar_controller.dart';
import '../../domain/calendar.dart';
import 'calendar_grid.dart';
import 'calendar_texts.dart';

/// "Bu hafta" (bugünün haftası, pazartesi–pazar): başlık + aralık, dört sayaçlı şerit
/// (Bitecek, Başlayacak, Devam, Toplantı; her biri süzgeç — görev türleri gün listesiyle
/// ortak, "Devam" varsayılan kapalı) ve açık türlerin bölümleri. Satır: solda gün (toplantıda
/// saat, süren görevde bitiş), tür noktası, başlık + alt yazı, gecikmede "gecikti".
class CalendarThisWeek extends ConsumerWidget {
  const CalendarThisWeek({super.key, required this.index});

  final CalendarIndex index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final view = ref.watch(calendarControllerProvider);
    final ctrl = ref.read(calendarControllerProvider.notifier);
    final days = weekOf(index.today);
    final w = index.week(index.today);
    final sections = <(String, List<CalendarEntry>)>[
      if (view.taskEdges.contains(TaskEdge.end)) (l.uiCalendarWeekEnds, w.ends),
      if (view.taskEdges.contains(TaskEdge.start))
        (l.uiCalendarWeekStarts, w.starts),
      if (view.taskEdges.contains(TaskEdge.ongoing))
        (l.uiCalendarWeekOngoing, w.ongoing),
      if (view.weekMeetings) (l.uiCalendarGroupMeetings, w.meetings),
    ].where((s) => s.$2.isNotEmpty).toList();
    return Semantics(
      label: l.uiCalendarThisWeek,
      container: true,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(l.uiCalendarThisWeek, style: t.titleSm),
                ),
              ),
              Text(
                l.weekRange(days.first, days.last),
                style: t.monoSm.copyWith(color: c.textFaint),
              ),
            ],
          ),
          const Gap(NizamioSpacing.space3),
          _StatStrip(
            stats: [
              (
                l.uiCalendarFilterEnds,
                w.ends.length,
                view.taskEdges.contains(TaskEdge.end),
                () => ctrl.toggleTaskEdge(TaskEdge.end),
              ),
              (
                l.uiCalendarFilterStarts,
                w.starts.length,
                view.taskEdges.contains(TaskEdge.start),
                () => ctrl.toggleTaskEdge(TaskEdge.start),
              ),
              (
                l.uiCalendarStatOngoing,
                w.ongoing.length,
                view.taskEdges.contains(TaskEdge.ongoing),
                () => ctrl.toggleTaskEdge(TaskEdge.ongoing),
              ),
              (
                l.uiCalendarStatMeetings,
                w.meetings.length,
                view.weekMeetings,
                ctrl.toggleWeekMeetings,
              ),
            ],
          ),
          if (sections.isEmpty) ...[
            const Gap(NizamioSpacing.space4),
            Text(
              l.uiCalendarThisWeekEmpty,
              textAlign: TextAlign.center,
              style: t.bodySm.copyWith(color: c.textMuted),
            ),
          ],
          for (final (label, entries) in sections) ...[
            const Gap(NizamioSpacing.gapLg),
            NzKicker('$label · ${entries.length}'),
            const Gap(NizamioSpacing.space2),
            ClipRRect(
              borderRadius: BorderRadius.circular(NizamioRadius.card),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.surfaceRaised,
                  border: Border.all(color: c.border),
                  borderRadius: BorderRadius.circular(NizamioRadius.card),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, e) in entries.indexed)
                      _WeekRow(entry: e, first: i == 0, index: index),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

typedef _Stat = (String label, int count, bool on, VoidCallback onTap);

/// Dört sayaç tek şeritte, aralarında ince çizgi; kapalı sayaç soluk.
class _StatStrip extends StatelessWidget {
  const _StatStrip({required this.stats});

  final List<_Stat> stats;

  static const _fade = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    return Semantics(
      label: l.uiCalendarThisWeekFilter,
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(NizamioRadius.card),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, (label, count, on, onTap)) in stats.indexed) ...[
                if (i > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: NizamioSpacing.space3,
                    ),
                    child: VerticalDivider(
                      width: NizamioSize.borderWidth,
                      thickness: NizamioSize.borderWidth,
                      color: c.border,
                    ),
                  ),
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: on,
                    label: '$label, $count',
                    excludeSemantics: true,
                    onTap: onTap,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onTap,
                      child: AnimatedOpacity(
                        opacity: on ? 1 : 0.38,
                        duration: NzMotion.of(context, _fade),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: NizamioSpacing.space3,
                            vertical: NizamioSpacing.gapMd,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$count',
                                style: t.titleSm.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                              Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.caption.copyWith(color: c.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Hafta satırı (en az 62): solda mono gün (toplantıda altında saat, süren görevde "→ bitiş"),
/// tür noktası, başlık + alt yazı (görevde kod · atananlar, toplantıda departmanlar),
/// gecikmede "gecikti" rozeti; dokunuş kaydı açar.
class _WeekRow extends StatelessWidget {
  const _WeekRow({
    required this.entry,
    required this.first,
    required this.index,
  });

  final CalendarEntry entry;
  final bool first;
  final CalendarIndex index;

  static const _lead = 64.0;
  static const _minHeight = 62.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final e = entry;
    final (
      String day,
      String? time,
      String title,
      String sub,
      bool late,
    ) = switch (e) {
      MeetingEntry() => (
        l.shortDay(e.date),
        l.clock(e),
        e.title,
        l.meetingSub(e),
        false,
      ),
      TaskEntry() => (
        e.edge == TaskEdge.ongoing
            ? '→ ${DateFormat('d MMM', 'tr').format(e.due ?? e.date)}'
            : l.shortDay(e.date),
        null,
        e.title,
        [
          e.code,
          ...e.assignees.map(
            (a) => index.personName(a) ?? l.uiTasksUnknownPerson,
          ),
        ].join(' · '),
        e.late,
      ),
      RequestEntry() => (
        l.shortDay(e.date),
        null,
        e.title,
        l.requestSub(e),
        false,
      ),
    };
    void open() => switch (e) {
      MeetingEntry() => context.appNav.openMeeting(e.id),
      TaskEntry() => context.appNav.openTask(e.code),
      RequestEntry() => context.appNav.openTask(e.code),
    };
    final mono = t.monoSm.copyWith(color: c.textMuted);
    return Semantics(
      button: true,
      label: [
        day,
        ?time,
        title,
        if (sub.isNotEmpty) sub,
        if (late) l.uiCalendarLateLc,
      ].join(', '),
      excludeSemantics: true,
      onTap: open,
      child: InkWell(
        onTap: open,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: first
                ? null
                : Border(
                    top: BorderSide(
                      color: c.border,
                      width: NizamioSize.borderWidth,
                    ),
                  ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _minHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.rowPad,
                vertical: NizamioSpacing.space2,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: _lead,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(day, maxLines: 1, style: mono),
                        if (time != null) Text(time, maxLines: 1, style: mono),
                      ],
                    ),
                  ),
                  const Gap(NizamioSpacing.space2),
                  NzDot(color: c.kind(e.kind), size: 7),
                  const Gap(NizamioSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyMd.copyWith(fontWeight: FontWeight.w500),
                        ),
                        if (sub.isNotEmpty)
                          Text(
                            sub,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.caption.copyWith(color: c.textMuted),
                          ),
                      ],
                    ),
                  ),
                  if (late) ...[
                    const Gap(NizamioSpacing.space2),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: c.danger.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(NizamioRadius.pill),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: NizamioSpacing.space2 + 2,
                          vertical: NizamioSpacing.space1,
                        ),
                        child: Text(
                          l.uiCalendarLateLc,
                          style: t.caption.copyWith(
                            color: c.danger,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
