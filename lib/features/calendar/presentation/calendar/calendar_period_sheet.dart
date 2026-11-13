import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../domain/calendar.dart';
import 'calendar_grid.dart';
import 'calendar_texts.dart';

/// Dönem kartının penceresi (telefonda genişletilebilir alt sayfa, tablette ortada modal): [from]–[to]
/// aralığının bölümleri — bitiş, başlangıç, devam edenler, toplantılar (boş bölüm yok) —
/// görev ekle formundaki açılır satırlarla ([NzFormRows]; sağda sayı, tek bölüm açık).
/// Satıra dokunmak pencereyi kapatıp kaydı açar.
Future<void> showCalendarPeriodSheet(
  BuildContext context, {
  required CalendarIndex index,
  required String title,
  required DateTime from,
  required DateTime to,
}) {
  final l = context.l10n;
  final nav = context.appNav;
  final s = index.span(from, to);
  final sections = <(String, IconData, List<CalendarEntry>)>[
    (l.uiCalendarSecEnds, NzIcons.flag, s.ends),
    (l.uiCalendarSecStarts, NzIcons.tasks, s.starts),
    (l.uiCalendarSecOngoing, NzIcons.clock, s.ongoing),
    (l.uiCalendarSecMeetings, NzIcons.video, s.meetings),
  ].where((x) => x.$3.isNotEmpty).toList();
  // Görev ekle formundaki açılır satırlar: aynı anda tek bölüm açık; ilk bölüm açık başlar.
  final expanded = ValueNotifier<int?>(sections.isEmpty ? null : 0);
  return NzBottomSheet.show<void>(
    context,
    title: title,
    description: from == to ? l.dayTitle(from) : l.weekRange(from, to),
    // Görev ekle ve diğer form sayfalarıyla aynı: tutamak genişlet/daralt düğmesidir.
    expandable: true,
    builder: (sheet) {
      void open(CalendarEntry e) {
        Navigator.of(sheet).pop();
        switch (e) {
          case MeetingEntry():
            nav.openMeeting(e.id);
          case TaskEntry():
            nav.openTask(e.code);
          case RequestEntry():
            nav.openTask(e.code);
        }
      }

      final c = sheet.colors;
      if (sections.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space6),
          child: Text(
            l.uiCalendarPeriodEmpty,
            textAlign: TextAlign.center,
            style: sheet.text.bodyMd.copyWith(color: c.textMuted),
          ),
        );
      }
      return ValueListenableBuilder<int?>(
        valueListenable: expanded,
        builder: (context, open_, _) => Padding(
          padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
          child: NzFormRows(
            expandedIndex: open_,
            onToggle: (i) => expanded.value = open_ == i ? null : i,
            rows: [
              for (final (label, icon, entries) in sections)
                NzFormRow(
                  label: label,
                  icon: icon,
                  value: '${entries.length}',
                  valueSet: true,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (j, e) in entries.indexed)
                        _PeriodRow(
                          entry: e,
                          first: j == 0,
                          index: index,
                          onOpen: () => open(e),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(expanded.dispose);
}

/// Dönem satırı (en az 62): solda mono gün (toplantıda altında saat, süren görevde "→ bitiş"),
/// tür noktası, başlık + alt yazı (görevde koordinatörlük · atananlar, toplantıda
/// departmanlar), sağda "gecikti" ya da "tamamlandı" rozeti.
class _PeriodRow extends StatelessWidget {
  const _PeriodRow({
    required this.entry,
    required this.first,
    required this.index,
    required this.onOpen,
  });

  final CalendarEntry entry;
  final bool first;
  final CalendarIndex index;
  final VoidCallback onOpen;

  static const _lead = 64.0;
  static const _minHeight = 62.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final e = entry;
    final (String day, String? time, String title, String sub) = switch (e) {
      MeetingEntry() => (
        l.shortDay(e.date),
        l.clock(e),
        e.title,
        l.meetingSub(e),
      ),
      TaskEntry() => (
        e.edge == TaskEdge.ongoing
            ? '→ ${DateFormat('d MMM', 'tr').format(e.due ?? e.date)}'
            : l.shortDay(e.date),
        null,
        e.title,
        [
          ?index.coordinatorshipName(e.coordinatorship),
          ...e.assignees.map(
            (a) => index.personName(a) ?? l.uiTasksUnknownPerson,
          ),
        ].join(' · '),
      ),
      RequestEntry() => (l.shortDay(e.date), null, e.title, l.requestSub(e)),
    };
    final (String, Color)? tag = switch (e) {
      TaskEntry(late: true) => (l.uiCalendarLateLc, c.danger),
      TaskEntry(status: TaskStatus.done) => (l.uiCalendarDoneLc, c.taskDone),
      _ => null,
    };
    final mono = t.monoSm.copyWith(color: c.textMuted);
    return Semantics(
      button: true,
      label: [day, ?time, title, if (sub.isNotEmpty) sub, ?tag?.$1].join(', '),
      excludeSemantics: true,
      onTap: onOpen,
      child: InkWell(
        onTap: onOpen,
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
                  if (tag case (final label, final ink)) ...[
                    const Gap(NizamioSpacing.space2),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: ink.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(NizamioRadius.pill),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: NizamioSpacing.space2 + 2,
                          vertical: NizamioSpacing.space1,
                        ),
                        child: Text(
                          label,
                          style: t.caption.copyWith(
                            color: ink,
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
