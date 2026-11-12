import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../domain/coordinatorship_board.dart';
import 'coord_detail_texts.dart';
import 'coord_parts.dart';
import 'coord_people_sheet.dart';
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
    // Koyu temada soluk lime (önceki görünüm); açık temada tamamlanma yeşili.
    final done = Theme.of(context).brightness == Brightness.dark
        ? Color.alphaBlend(c.primary.withValues(alpha: .45), c.surfaceOverlay)
        : c.taskDone;
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
