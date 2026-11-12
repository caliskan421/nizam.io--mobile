import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../application/calendar_controller.dart';
import '../../domain/calendar.dart';
import 'calendar_grid.dart';
import 'calendar_texts.dart';

/// Seçili gün (prototip "Seçili gün"): başlık + bugüne göre uzaklık, türlere göre bölümler
/// (toplantılar, görevler, tarih talepleri); boş günde "Toplantı planla". Toplantı satırı
/// toplantı ayrıntısını, görev ve talep satırı görev ayrıntısını açar.
class CalendarDay extends ConsumerWidget {
  const CalendarDay({
    super.key,
    required this.index,
    this.onPlanMeeting,
    this.onAdd,
    this.emptyMessage,
    this.divided = true,
  });

  /// Verilirse boş günün düğmesi "Bu güne ekle" olur ve bunu çağırır (toplantı + görev
  /// menüsü); yoksa [onPlanMeeting] ile "Toplantı planla".
  final VoidCallback? onAdd;

  final CalendarIndex index;

  /// Izgaranın altındaysa üst çizgi + boşluk; geniş düzende yan sütunda çizgisiz.
  final bool divided;
  final VoidCallback? onPlanMeeting;
  final String? emptyMessage;

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
    final groups = index.groups(day);
    final dayTasks = index.on(day).whereType<TaskEntry>();
    final tasks = {
      TaskEdge.end: [...dayTasks.where((e) => e.edge == TaskEdge.end)],
      TaskEdge.start: [...dayTasks.where((e) => e.edge == TaskEdge.start)],
      TaskEdge.ongoing: index.ongoing(day),
    };
    Widget card(List<CalendarEntry> entries) => ClipRRect(
      borderRadius: BorderRadius.circular(NizamioRadius.row),
      child: ColoredBox(
        color: c.surfaceRaised,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, e) in entries.indexed)
              _EntryRow(entry: e, first: i == 0, index: index),
          ],
        ),
      ),
    );
    return Semantics(
      label: title,
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: divided
              ? Border(
                  top: BorderSide(
                    color: c.border,
                    width: NizamioSize.borderWidth,
                  ),
                )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: divided ? NizamioSpacing.space4 : 0),
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
              for (final g in groups)
                if (g.kind == CalendarKind.meeting) ...[
                  const Gap(14),
                  NzKicker('${l.groupLabel(g.kind)} · ${g.entries.length}'),
                  const Gap(NizamioSpacing.space2),
                  card(g.entries),
                ],
              // Görevler toplantılardan sonra, taleplerden önce; süren görev varsa bölüm bitiş/
              // başlangıç olmayan günde de görünür (süzgeç açılabilsin).
              if (tasks.values.any((e) => e.isNotEmpty))
                _TaskSection(tasks: tasks, card: card),
              for (final g in groups)
                if (g.kind == CalendarKind.request) ...[
                  const Gap(14),
                  NzKicker('${l.groupLabel(g.kind)} · ${g.entries.length}'),
                  const Gap(NizamioSpacing.space2),
                  card(g.entries),
                ],
              if (groups.isEmpty) ...[
                const Gap(14 + 28),
                Text(
                  emptyMessage ?? l.uiCalendarEmpty,
                  textAlign: TextAlign.center,
                  style: t.bodyMd.copyWith(color: c.textMuted),
                ),
                const Gap(14),
                if (onAdd != null)
                  Center(
                    child: NzButton.secondary(
                      label: l.uiCalendarAddDay,
                      onPressed: onAdd,
                    ),
                  )
                else if (onPlanMeeting != null)
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

/// Görev bölümü: başlık + süzgeç (Bitecek / Başlayacak / Devam eden, sayılı; seçim
/// denetleyicide, günler arasında korunur) ve seçili türlerin alt bölümleri.
class _TaskSection extends ConsumerWidget {
  const _TaskSection({required this.tasks, required this.card});

  final Map<TaskEdge, List<TaskEntry>> tasks;
  final Widget Function(List<CalendarEntry>) card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final edges = ref.watch(
      calendarControllerProvider.select((v) => v.taskEdges),
    );
    final ctrl = ref.read(calendarControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Gap(14),
        NzKicker(l.groupLabel(CalendarKind.task)),
        const Gap(NizamioSpacing.space1),
        Semantics(
          label: l.uiCalendarTaskFilter,
          container: true,
          explicitChildNodes: true,
          child: Wrap(
            spacing: NizamioSpacing.space2,
            children: [
              for (final e in TaskEdge.values)
                _EdgeChip(
                  label: l.edgeFilter(e),
                  count: tasks[e]!.length,
                  selected: edges.contains(e),
                  onTap: () => ctrl.toggleTaskEdge(e),
                ),
            ],
          ),
        ),
        for (final e in TaskEdge.values)
          if (edges.contains(e) && tasks[e]!.isNotEmpty) ...[
            const Gap(NizamioSpacing.space2),
            Padding(
              padding: const EdgeInsets.only(left: NizamioSpacing.space1),
              child: Text(
                '${l.edgeSection(e)} · ${tasks[e]!.length}',
                style: context.text.monoSm.copyWith(color: c.textFaint),
              ),
            ),
            const Gap(NizamioSpacing.space1 + 2),
            card(tasks[e]!),
          ],
      ],
    );
  }
}

/// Görev süzgeci hapı (36 görsel, 44 dokunma): seçili dolu (`text` zemin, ters yazı),
/// seçilmemiş çerçeveli; etiket + mono sayı.
class _EdgeChip extends StatelessWidget {
  const _EdgeChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  static const _fade = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final ink = selected ? c.background : c.textMuted;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label, $count',
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: (NizamioSize.tap - NizamioSize.controlSm) / 2,
          ),
          child: AnimatedContainer(
            duration: NzMotion.of(context, _fade),
            curve: Curves.ease,
            height: NizamioSize.controlSm,
            padding: const EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space3,
            ),
            decoration: BoxDecoration(
              color: selected ? c.text : c.text.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(NizamioRadius.pill),
              border: Border.all(
                color: selected ? c.text : c.border,
                width: NizamioSize.borderWidth,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: t.bodySm.copyWith(
                    color: ink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(NizamioSpacing.space1 + 2),
                Text(
                  '$count',
                  style: t.monoSm.copyWith(
                    color: selected
                        ? c.background.withValues(alpha: 0.6)
                        : c.textFaint,
                  ),
                ),
              ],
            ),
          ),
        ),
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
        '${l.edgeLead(e)}'
            ' · ${e.status == null ? e.assignees.map((a) => index.personName(a) ?? l.uiTasksUnknownPerson).join(', ') : switch (e.status!) {
                    TaskStatus.todo => l.uiTasksStatusTodo,
                    TaskStatus.inProgress => l.uiTasksStatusDoing,
                    TaskStatus.review => l.uiTasksStatusReview,
                    TaskStatus.returned => l.uiTasksStatusReturned,
                    TaskStatus.done => l.uiTasksStatusDone,
                    TaskStatus.unknown => l.uiUsersUnknownStatus,
                  }}',
        e.late ? l.uiCalendarLateLc : null,
        c.danger,
        c.danger.withValues(alpha: 0.16),
      ),
      RequestEntry() => (
        e.code,
        e.title,
        l.requestSub(e),
        l.uiCalendarStatePending,
        c.warning,
        c.surfaceOverlay,
      ),
    };
    void open() => switch (e) {
      MeetingEntry() => context.appNav.openMeeting(e.id),
      TaskEntry() => context.appNav.openTask(e.code),
      RequestEntry() => context.appNav.openTask(e.code),
    };

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
                      NzIcon(
                        NzIcons.chevronRight,
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
