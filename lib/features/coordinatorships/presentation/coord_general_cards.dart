import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../domain/coordinatorship_board.dart';
import '../domain/coordinatorship_overview.dart';
import 'coord_detail_texts.dart';
import 'coord_parts.dart';
import 'coord_people_sheet.dart';
import 'coord_texts.dart';
import 'coord_widgets.dart';

/// Genel bölümü kartı (prototip `.cd-card2`): başlık satırı (ad + sağda ek), satırlar.
class CoordGenCard extends StatelessWidget {
  const CoordGenCard({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => CoordPanel(
    padding: const EdgeInsets.only(
      top: NizamioSpacing.space4,
      bottom: NizamioSpacing.space1,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NizamioSpacing.rowPad,
            0,
            NizamioSpacing.rowPad,
            NizamioSpacing.space1,
          ),
          child: Row(
            children: [
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: context.text.labelLg.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (trailing case final w?) ...[
                const Gap(NizamioSpacing.space3),
                Expanded(
                  child: Align(alignment: Alignment.centerRight, child: w),
                ),
              ],
            ],
          ),
        ),
        ...children,
      ],
    ),
  );
}

/// Akış (prototip `.cd-flow`): son geciken teslimler, bugün çizgisi, yaklaşan toplantılar ve
/// teslimler; solda dikey zaman çizgisi.
class CoordFlowCard extends StatelessWidget {
  const CoordFlowCard({
    super.key,
    required this.catalog,
    required this.tasks,
    required this.meetings,
  });

  final TaskCatalog catalog;
  final List<TaskItem> tasks;
  final List<CoordMeeting> meetings;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final nav = context.appNav;
    final today = catalog.today;
    final flow = coordFlow(tasks, meetings, DateTime.now());
    String who(TaskItem t) {
      final names = [
        for (final id in t.assignees) ?catalog.nameOf(id)?.split(' ').first,
      ];
      return names.isEmpty ? l.uiCoordNobody : names.join(', ');
    }

    return CoordGenCard(
      title: l.uiCoordFlow,
      trailing: Text(
        l.uiCoordFlowSub,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.caption.copyWith(color: c.textMuted),
      ),
      children: [
        Stack(
          children: [
            // Düğüm merkezlerinden geçen çizgi (prototip `.cd-tl::before`).
            Positioned(
              left: NizamioSpacing.rowPad + 15,
              top: 18,
              bottom: 22,
              width: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [c.danger.withValues(alpha: .4), c.border],
                    stops: const [0, .45],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: NizamioSpacing.space1,
                bottom: NizamioSpacing.space2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final t in flow.late)
                    _FlowRow(
                      icon: NzIcons.warning,
                      tone: c.danger,
                      title: t.title,
                      meta: '${t.displayCode} · ${who(t)}',
                      date: l.coordShortDate(t.due),
                      tag: l.coordDaysAgo(t.overdueDays),
                      tagColor: c.danger,
                      past: true,
                      onTap: () => nav.openTask(t.code),
                    ),
                  _Today(label: l.coordDayMonth(today)),
                  for (final e in flow.upcoming)
                    switch (e) {
                      CoordFlowMeeting(:final meeting) => _FlowRow(
                        icon: NzIcons.video,
                        tone: c.info,
                        title: meeting.title,
                        meta: l.coordFlowMeetingMeta(meeting),
                        date: l.coordShortDate(meeting.at),
                        tag: l.coordDaysLeft(meeting.at, today),
                        onTap: nav.openCalendar,
                      ),
                      CoordFlowTask(:final task) => _FlowRow(
                        icon: NzIcons.check,
                        tone: c.inProgress,
                        title: task.title,
                        meta: '${task.displayCode} · ${l.uiCoordDeadlineTag}',
                        date: l.coordShortDate(task.due),
                        tag: l.coordDaysLeft(task.due, today),
                        onTap: () => nav.openTask(task.code),
                      ),
                    },
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Bugün çizgisi (prototip `.cd-today`): yeşil hap, tarih, ince çizgi.
class _Today extends StatelessWidget {
  const _Today({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return SizedBox(
      height: 34,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: NizamioSpacing.rowPad),
        child: Row(
          spacing: NizamioSpacing.space2,
          children: [
            Container(
              height: 22,
              padding: const EdgeInsets.symmetric(horizontal: 9),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.primary,
                borderRadius: BorderRadius.circular(NizamioRadius.pill),
              ),
              child: Text(
                context.l10n.uiCoordTodayPill,
                style: t.caption.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: c.onPrimary,
                ),
              ),
            ),
            Text(
              label,
              style: t.monoSm.copyWith(fontSize: 11.5, color: c.textMuted),
            ),
            Expanded(
              child: Container(
                height: NizamioSize.borderWidth,
                color: c.primary.withValues(alpha: .45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowRow extends StatelessWidget {
  const _FlowRow({
    required this.icon,
    required this.tone,
    required this.title,
    required this.meta,
    required this.date,
    required this.tag,
    required this.onTap,
    this.tagColor,
    this.past = false,
  });

  final IconData icon;
  final Color tone;
  final String title;
  final String meta;
  final String date;
  final String tag;
  final Color? tagColor;
  final bool past;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return CoordRow(
      onTap: onTap,
      semanticLabel: [title, meta, date, tag].join(', '),
      minHeight: 58,
      vertical: 6,
      child: Row(
        spacing: NizamioSpacing.space3,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.surface,
              border: Border.all(color: tone.withValues(alpha: .7), width: 1.5),
            ),
            child: NzIcon(icon, size: 15, color: tone),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.labelLg.copyWith(
                    fontWeight: FontWeight.w500,
                    color: past ? c.textMuted : null,
                  ),
                ),
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.caption.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 1,
            children: [
              Text(date, style: t.monoSm.copyWith(color: c.text)),
              Text(
                tag,
                style: t.caption.copyWith(
                  fontSize: 11.5,
                  color: tagColor ?? c.textFaint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// İş yükü (prototip `.cd-load`): atanan başına geciken/açık/biten çubuğu (en yükünün
/// toplamına göre), kişi sayfası; altta "Tüm ekip".
class CoordLoadCard extends ConsumerWidget {
  const CoordLoadCard({
    super.key,
    required this.code,
    required this.catalog,
    required this.tasks,
    required this.people,
  });

  final String code;
  final TaskCatalog catalog;
  final List<TaskItem> tasks;
  final List<CoordPerson> people;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final rows = coordLoad(tasks);
    final most = rows.fold(1, (a, r) => r.total > a ? r.total : a);
    final done = Color.alphaBlend(
      c.primary.withValues(alpha: .45),
      c.surfaceOverlay,
    );
    final commands = ref.read(
      coordinatorshipDetailControllerProvider(code).notifier,
    );
    Widget key(String label, Color color) => Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          label,
          style: t.caption.copyWith(fontSize: 11, color: c.textFaint),
        ),
      ],
    );
    return CoordGenCard(
      title: l.uiCoordLoad,
      trailing: ExcludeSemantics(
        child: Wrap(
          spacing: 10,
          alignment: WrapAlignment.end,
          children: [
            key(l.uiCoordLateTail, c.danger),
            key(l.uiCoordOpenTail, c.inProgress),
            key(l.uiCoordLoadDone, done),
          ],
        ),
      ),
      children: [
        for (final r in rows)
          CoordRow(
            onTap: () {
              final p = people.where((p) => p.id == r.id).firstOrNull;
              if (p != null) {
                showCoordPersonSheet(context, ref, code, p);
              } else {
                commands.showTasks(CoordTaskFilter.open, person: r.id);
              }
            },
            semanticLabel: [
              catalog.nameOf(r.id) ?? r.id,
              '${r.late + r.open} ${l.uiCoordOpenTail}',
              l.coordLoadSub(r),
            ].join(', '),
            minHeight: 0,
            vertical: 9,
            child: Row(
              spacing: NizamioSpacing.space3,
              children: [
                NzAvatar.initials(
                  name: catalog.nameOf(r.id) ?? r.id,
                  extent: NzAvatarSize.md,
                  tone: NzAvatar.toneOf(catalog.nameOf(r.id) ?? r.id),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 5,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              catalog.nameOf(r.id) ?? r.id,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.labelLg.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Gap(NizamioSpacing.space2),
                          Text(
                            '${r.late + r.open} ${l.uiCoordOpenTail}',
                            style: t.monoSm.copyWith(color: c.textMuted),
                          ),
                        ],
                      ),
                      NzProgressBar.segments(
                        segments: [
                          NzBarSegment(r.late, c.danger),
                          NzBarSegment(r.open, c.inProgress),
                          NzBarSegment(r.done, done),
                          NzBarSegment(most - r.total, c.surfaceRaised),
                        ],
                      ),
                      Text(
                        l.coordLoadSub(r),
                        style: t.caption.copyWith(
                          color: r.late > 0 ? c.danger : c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (rows.isEmpty) CoordEmpty(l.uiCoordNoLoad),
        const CoordRowDivider(),
        CoordRow(
          onTap: () => commands.selectTab(CoordinatorshipTab.members),
          semanticLabel: l.coordAllTeam(people.length),
          minHeight: 48,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: NizamioSpacing.space1,
              children: [
                Text(
                  l.coordAllTeam(people.length),
                  style: t.bodySm.copyWith(color: c.textMuted),
                ),
                NzIcon(
                  NzIcons.chevronRight,
                  size: NizamioSize.iconSizeSm,
                  color: c.textMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Son hareketler (prototip `.cd-act`): yapan, eylem, hedef ve gün.
class CoordActivityCard extends StatelessWidget {
  const CoordActivityCard({super.key, required this.feed});

  final List<FeedItem> feed;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    return CoordGenCard(
      title: l.uiCoordActivity,
      children: [
        for (final f in feed.take(4))
          MergeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.rowPad,
                vertical: 9,
              ),
              child: Row(
                spacing: NizamioSpacing.space3,
                children: [
                  NzAvatar.initials(
                    name: f.who,
                    extent: NzAvatarSize.md,
                    tone: NzAvatar.toneOf(f.who),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: f.who,
                                style: t.bodySm.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: c.text,
                                ),
                              ),
                              TextSpan(text: ' ${f.action}'),
                            ],
                          ),
                          style: t.bodySm.copyWith(color: c.textMuted),
                        ),
                        Text(
                          f.target,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.caption.copyWith(color: c.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    l.coordShortDate(f.at),
                    style: t.monoSm.copyWith(color: c.textMuted),
                  ),
                ],
              ),
            ),
          ),
        if (feed.isEmpty) CoordEmpty(l.uiCoordNoActivity),
      ],
    );
  }
}
