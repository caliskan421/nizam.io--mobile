import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/calendar_controller.dart';
import '../../domain/calendar.dart';
import 'calendar_grid.dart';
import 'calendar_preview_sheet.dart';
import 'calendar_texts.dart';

/// Seçili gün (prototip "Seçili gün"): başlık + bugüne göre uzaklık, sezon şeritleri, türlere
/// göre bölümler (toplantılar, görevler, talepler, tablo kayıtları); boş günde "Toplantı
/// planla". Görev satırı görev ayrıntısını açar; diğerleri önizleme penceresini.
class CalendarDay extends ConsumerWidget {
  const CalendarDay({
    super.key,
    required this.index,
    required this.onPlanMeeting,
  });

  final CalendarIndex index;
  final VoidCallback onPlanMeeting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final day = ref.watch(
      calendarControllerProvider.select((v) => v.selectedOn(index.today)),
    );
    final rel = calendarDiff(day, index.today);
    final title = l.dayTitle(day);
    final seasons = index.seasons(day);
    final groups = index.groups(day);
    return Semantics(
      label: title,
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: c.border, width: NizamioSize.borderWidth),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: NizamioSpacing.space4),
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
                      child: Text(title, style: t.titleSm),
                    ),
                  ),
                  const Gap(NizamioSpacing.gapMd),
                  Text(
                    l.relative(rel),
                    style: t.monoSm.copyWith(
                      fontSize: 12,
                      color: rel == 0 ? c.accentText : c.textFaint,
                    ),
                  ),
                ],
              ),
              for (final s in seasons) ...[
                const Gap(NizamioSpacing.gapMd),
                _SeasonStrip(title: s.title),
              ],
              for (final g in groups) ...[
                const Gap(14),
                NzKicker('${l.groupLabel(g.kind)} · ${g.entries.length}'),
                const Gap(NizamioSpacing.space2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(NizamioRadius.row),
                  child: ColoredBox(
                    color: c.surfaceRaised,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final (i, e) in g.entries.indexed)
                          _EntryRow(entry: e, first: i == 0, index: index),
                      ],
                    ),
                  ),
                ),
              ],
              if (groups.isEmpty) ...[
                const Gap(14 + 28),
                Text(
                  l.uiCalendarEmpty,
                  textAlign: TextAlign.center,
                  style: t.bodyMd.copyWith(color: c.textMuted),
                ),
                const Gap(14),
                Center(
                  child: NzButton.secondary(
                    label: l.uiCalendarPlan,
                    onPressed: onPlanMeeting,
                  ),
                ),
                const Gap(NizamioSpacing.space2),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Sezon şeridi: `danger` %13 zemin, 8 px nokta, sağda mono "sezon".
class _SeasonStrip extends StatelessWidget {
  const _SeasonStrip({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Container(
      constraints: const BoxConstraints(minHeight: NizamioSize.tap),
      padding: const EdgeInsets.symmetric(horizontal: NizamioSpacing.rowPad),
      decoration: BoxDecoration(
        color: c.danger.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(NizamioRadius.attach),
      ),
      child: Row(
        children: [
          NzDot(color: c.danger),
          const Gap(NizamioSpacing.gapMd),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.bodyMd.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const Gap(NizamioSpacing.gapMd),
          Text(
            context.l10n.uiCalendarSeasonLc,
            style: t.monoSm.copyWith(color: c.danger),
          ),
        ],
      ),
    );
  }
}

/// Gün listesi satırı (62 | esnek | 16 ızgara, en az 62 yükseklik): renk noktası + mono
/// öncü (saat / kod), başlık + isteğe bağlı etiket, alt yazı, sağ ok.
class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.entry,
    required this.first,
    required this.index,
  });

  final CalendarEntry entry;
  final bool first;
  final CalendarIndex index;

  static const _lead = 62.0;
  static const _minHeight = 62.0;
  static const _leadDot = 6.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final e = entry;
    final (
      String lead,
      String title,
      String sub,
      String? tag,
      Color tagInk,
      Color tagFill,
    ) = switch (e) {
      MeetingEntry() => (
        l.clock(e),
        e.title,
        l.meetingSub(e),
        null,
        c.danger,
        c.surfaceOverlay,
      ),
      TaskEntry() => (
        e.code,
        e.title,
        '${e.edge == TaskEdge.end ? l.uiCalendarTaskEnds : l.uiCalendarTaskStarts}'
            ' · ${e.assignees.map(index.personName).join(', ')}',
        e.late ? l.uiCalendarLateLc : null,
        c.danger,
        c.danger.withValues(alpha: 0.16),
      ),
      RequestEntry() => (
        e.id,
        e.title,
        '${l.requestType(e.type)} · ${e.coordinatorship}'
            '${e.amount > 0 ? ' · ${l.money(e.amount)}' : ''}',
        l.requestState(e.state),
        e.state == RequestState.pending ? c.warning : c.textMuted,
        c.surfaceOverlay,
      ),
      SheetEntry() => (
        e.coordinatorship,
        e.label,
        '${e.table} · ${index.personName(e.person)}',
        e.done ? l.uiCalendarDoneLc : null,
        c.accentText,
        c.surfaceOverlay,
      ),
      SeasonEntry() => ('', e.title, '', null, c.danger, c.surfaceOverlay),
    };
    void open() {
      if (e is TaskEntry) {
        context.appNav.openTask(e.code);
      } else {
        showCalendarPreview(context, entry: e, index: index);
      }
    }

    return MergeSemantics(
      child: Semantics(
        button: true,
        onTap: open,
        child: NzPressable.card(
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
                    vertical: 9,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: _lead,
                        child: Row(
                          children: [
                            NzDot(color: c.kind(e.kind), size: _leadDot),
                            const Gap(7),
                            Flexible(
                              child: Text(
                                lead,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.monoSm.copyWith(
                                  fontSize: 12,
                                  color: e is MeetingEntry
                                      ? c.text
                                      : c.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(NizamioSpacing.gapMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodyMd.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (tag != null) ...[
                                  const Gap(NizamioSpacing.space2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tagFill,
                                      borderRadius: BorderRadius.circular(
                                        NizamioRadius.pill,
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: t.program.copyWith(
                                        height: 14 / 10,
                                        color: tagInk,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const Gap(2),
                            Text(
                              sub,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.caption.copyWith(color: c.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const Gap(NizamioSpacing.gapMd),
                      NzPathIcon(
                        CalendarIcons.chevronRight,
                        size: NizamioSize.iconSizeSm,
                        color: c.textFaint,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
