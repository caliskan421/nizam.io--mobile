import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/calendar_controller.dart';
import '../../domain/calendar.dart';
import 'calendar_grid.dart';
import 'calendar_texts.dart';

/// "Bu hafta": bugünden pazara kadar kaydı olan günler tek kartta. Solda gün bloğu (kısa gün
/// adı + gün; bugün vurgulu, seçili gün zeminli; dokununca gün seçilir), sağda o günün en çok
/// [_perDay] kaydı (nokta, saat/kod, başlık, görev ucu); fazlası "+N daha" ile güne gider.
/// Kayıt satırı toplantı ya da görev ayrıntısını açar.
class CalendarWeekAhead extends ConsumerWidget {
  const CalendarWeekAhead({super.key, required this.index});

  final CalendarIndex index;

  static const _perDay = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final today = index.today;
    final selected = ref.watch(
      calendarControllerProvider.select((v) => v.selectedOn(today)),
    );
    final ctrl = ref.read(calendarControllerProvider.notifier);
    final days = [
      for (final d in weekAhead(today))
        if (index.count(d) > 0)
          (day: d, entries: [for (final g in index.groups(d)) ...g.entries]),
    ];
    final total = days.fold(0, (a, d) => a + d.entries.length);
    return Semantics(
      label: l.uiCalendarWeekAhead,
      container: true,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NzKicker(
            total == 0
                ? l.uiCalendarWeekAhead
                : '${l.uiCalendarWeekAhead} · $total',
          ),
          const Gap(NizamioSpacing.space2),
          ClipRRect(
            borderRadius: BorderRadius.circular(NizamioRadius.row),
            child: ColoredBox(
              color: c.surfaceRaised,
              child: days.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(NizamioSpacing.rowPad),
                      child: Text(
                        l.uiCalendarWeekAheadEmpty,
                        style: context.text.bodySm.copyWith(color: c.textMuted),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final (i, d) in days.indexed)
                          _DayRow(
                            day: d.day,
                            entries: d.entries,
                            first: i == 0,
                            today: d.day == today,
                            selected: d.day == selected,
                            limit: _perDay,
                            index: index,
                            onPick: () => ctrl.pick(d.day),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.entries,
    required this.first,
    required this.today,
    required this.selected,
    required this.limit,
    required this.index,
    required this.onPick,
  });

  final DateTime day;
  final List<CalendarEntry> entries;
  final bool first;
  final bool today;
  final bool selected;
  final int limit;
  final CalendarIndex index;
  final VoidCallback onPick;

  static const _block = 48.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final shown = entries.take(limit).toList();
    final more = entries.length - shown.length;
    final ink = today ? c.accentText : c.text;
    return DecoratedBox(
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          NizamioSpacing.space2,
          NizamioSpacing.space2,
          NizamioSpacing.rowPad,
          NizamioSpacing.space2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              button: true,
              selected: selected,
              label: l.cellLabel(day, today: today, count: entries.length),
              excludeSemantics: true,
              onTap: onPick,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onPick,
                child: Container(
                  width: _block,
                  padding: const EdgeInsets.symmetric(
                    vertical: NizamioSpacing.space2,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? c.surfaceOverlay : null,
                    borderRadius: BorderRadius.circular(NizamioRadius.group),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l.weekdaysShort[day.weekday - 1],
                        style: t.monoSm.copyWith(
                          color: today ? c.accentText : c.textFaint,
                        ),
                      ),
                      Text(
                        '${day.day}',
                        style: t.labelLg.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(NizamioSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final e in shown) _Line(entry: e),
                  if (more > 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onPick,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: NizamioSpacing.space1,
                          ),
                          child: Text(
                            '+$more ${l.uiCalendarMoreLc}',
                            style: t.monoSm.copyWith(color: c.textMuted),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kompakt kayıt satırı (36 en az): tür noktası, mono saat/kod, başlık, sağda görev ucu.
class _Line extends StatelessWidget {
  const _Line({required this.entry});

  final CalendarEntry entry;

  static const _lead = 44.0;
  static const _minHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final e = entry;
    final (String lead, String title, String? tail) = switch (e) {
      MeetingEntry() => (l.clock(e), e.title, null),
      TaskEntry() => (e.code, e.title, l.edgeLead(e)),
      RequestEntry() => (e.code, e.title, l.uiCalendarRequestLc),
    };
    void open() => switch (e) {
      MeetingEntry() => context.appNav.openMeeting(e.id),
      TaskEntry() => context.appNav.openTask(e.code),
      RequestEntry() => context.appNav.openTask(e.code),
    };
    return Semantics(
      button: true,
      label: [lead, title, ?tail].join(', '),
      excludeSemantics: true,
      onTap: open,
      child: InkWell(
        onTap: open,
        borderRadius: BorderRadius.circular(NizamioRadius.group),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _minHeight),
          child: Row(
            children: [
              NzDot(color: c.kind(e.kind), size: 6),
              const Gap(NizamioSpacing.space2),
              SizedBox(
                width: _lead,
                child: Text(
                  lead,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.monoSm.copyWith(
                    color: e is MeetingEntry ? c.text : c.textMuted,
                  ),
                ),
              ),
              const Gap(NizamioSpacing.space2),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodySm.copyWith(
                    color: c.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (tail != null) ...[
                const Gap(NizamioSpacing.space2),
                Text(
                  tail,
                  maxLines: 1,
                  style: t.caption.copyWith(color: c.textFaint),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
