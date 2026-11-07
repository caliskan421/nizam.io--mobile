import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../domain/coordinatorship_board.dart';
import '../domain/coordinatorship_overview.dart';
import 'coord_detail_texts.dart';
import 'coord_parts.dart';
import 'coord_people_sheet.dart';
import 'coord_texts.dart';
import 'coord_widgets.dart';

/// Genel bölümü (prototip `.cd-genw`): dört özet kartı (Görevler, Ekip, Arşiv, Toplantı;
/// dokununca bölüm), hakkında, sorumlular ve bilgiler. Genişte kartlar 4'lü, alt kısım iki sütun.
class CoordGeneralTab extends ConsumerWidget {
  const CoordGeneralTab({
    super.key,
    required this.detail,
    required this.pulse,
    required this.people,
  });

  final CoordinatorshipDetail detail;
  final CoordPulse pulse;
  final List<CoordPerson> people;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final code = detail.stats.code;
    final commands = ref.read(
      coordinatorshipDetailControllerProvider(code).notifier,
    );
    final files = ref.watch(coordinatorshipFilesProvider(code)).value;
    final meetings = ref.watch(coordinatorshipMeetingsProvider(code)).value;
    final now = DateTime.now();
    final upcoming = [...?meetings?.where((m) => !m.at.isBefore(now))];
    final past = (meetings?.length ?? 0) - upcoming.length;
    final leads = people.where((p) => p.lead).toList();
    final bytes = files?.fold<int>(0, (a, f) => a + f.sizeBytes) ?? 0;
    void go(CoordinatorshipTab t) => commands.selectTab(t);

    final cards = [
      NzKpiTile(
        icon: NzIcons.tasks,
        tone: c.inProgress,
        label: l.uiCoordTabTasks,
        value: '${pulse.total}',
        segments: [
          NzBarSegment(pulse.done, c.primary),
          NzBarSegment(pulse.doing, c.inProgress),
          NzBarSegment(pulse.late, c.danger),
          NzBarSegment(pulse.todo, c.surfaceOverlay),
        ],
        caption: l.coordOpenLate(pulse),
        onTap: () => go(CoordinatorshipTab.tasks),
      ),
      NzKpiTile(
        icon: NzIcons.group,
        tone: c.accentText,
        label: l.uiCoordOvTeam,
        value: '${people.length}',
        footer: Align(
          alignment: Alignment.centerLeft,
          child: NzAvatarStack(names: [for (final p in people) p.name], max: 4),
        ),
        caption: l.coordLeadsMembers(
          leads.length,
          people.length - leads.length,
        ),
        onTap: () => go(CoordinatorshipTab.members),
      ),
      NzKpiTile(
        icon: NzIcons.folder,
        tone: c.warning,
        label: l.uiCoordTabArchive,
        value: files == null ? '—' : '${files.length}',
        segments: [
          for (final k in CoordFileKind.values)
            NzBarSegment(
              files?.where((f) => f.kind == k).length ?? 0,
              coordKindColor(context, k),
            ),
        ],
        caption: files == null ? '—' : l.coordFilesSize(bytes),
        onTap: () => go(CoordinatorshipTab.archive),
      ),
      NzKpiTile(
        icon: NzIcons.event,
        tone: c.info,
        label: l.uiCoordTabMeetings,
        value: meetings == null ? '—' : '${upcoming.length}',
        segments: [
          NzBarSegment(upcoming.length, c.info),
          NzBarSegment(past, c.surfaceOverlay),
        ],
        caption: meetings == null
            ? '—'
            : l.coordNextMeeting(upcoming.firstOrNull),
        onTap: () => go(CoordinatorshipTab.meetings),
      ),
    ];
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth >= coordWideWidth;
        final grid = wide
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 10,
                  children: [for (final k in cards) Expanded(child: k)],
                ),
              )
            : Column(
                spacing: 10,
                children: [
                  for (var i = 0; i < cards.length; i += 2)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 10,
                        children: [
                          Expanded(child: cards[i]),
                          Expanded(child: cards[i + 1]),
                        ],
                      ),
                    ),
                ],
              );
        final about = _About(detail: detail);
        final side = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: NizamioSpacing.gapXl,
          children: [
            CoordBlock(
              label: l.uiCoordLeads,
              child: CoordRows(
                children: [
                  for (final p in leads)
                    CoordListRow(
                      leading: NzAvatar.initials(
                        name: p.name,
                        extent: NzAvatarSize.md,
                      ),
                      title: p.name,
                      subtitle: l.uiCoordLeadRole,
                      onTap: () => showCoordPersonSheet(context, ref, code, p),
                    ),
                  if (leads.isEmpty)
                    CoordListRow(
                      leading: const NzAvatar.icon(
                        icon: NzIcons.personAdd,
                        extent: NzAvatarSize.md,
                      ),
                      title: l.uiCoordUnassigned,
                      subtitle: l.uiCoordUnassignedPick,
                      onTap: () => go(CoordinatorshipTab.members),
                    ),
                ],
              ),
            ),
            CoordBlock(
              label: l.uiCoordFacts,
              child: _Facts(detail: detail),
            ),
          ],
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            grid,
            const Gap(22),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: NizamioSpacing.gapXl,
                children: [
                  Expanded(flex: 115, child: about),
                  Expanded(flex: 100, child: side),
                ],
              )
            else ...[
              about,
              const Gap(NizamioSpacing.gapXl),
              side,
            ],
          ],
        );
      },
    );
  }
}

/// Hakkında (açıklama; uzunsa "Devamı"). Açıklama yoksa bölüm gösterilmez.
class _About extends ConsumerWidget {
  const _About({required this.detail});

  final CoordinatorshipDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final about = detail.profile.about;
    if (about.isEmpty) return const SizedBox.shrink();
    final l = context.l10n;
    final provider = coordinatorshipDetailControllerProvider(detail.stats.code);
    final open = ref.watch(provider.select((v) => v.aboutOpen));
    final long = about.length > 110;
    return CoordBlock(
      label: l.uiCoordAbout,
      child: CoordPanel(
        padding: const EdgeInsets.all(NizamioSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: NizamioSpacing.space2,
          children: [
            Text(
              about,
              maxLines: open || !long ? null : 3,
              overflow: open || !long ? null : TextOverflow.ellipsis,
              style: context.text.bodyMd.copyWith(height: 22 / 14.5),
            ),
            if (long)
              CoordLink(
                label: open ? l.uiCoordLess : l.uiCoordMore,
                onTap: ref.read(provider.notifier).toggleAbout,
              ),
          ],
        ),
      ),
    );
  }
}

/// Bilgiler (prototip `.cd-dl`): kod, tür, üst birim, kuruluş (bilinenler), görünürlük.
class _Facts extends StatelessWidget {
  const _Facts({required this.detail});

  final CoordinatorshipDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final p = detail.profile;
    final facts = [
      if (detail.stats.shortCode case final code?) (l.uiCoordFactCode, code),
      (l.uiCoordFactKind, l.uiCoordKindCoord),
      if (p.parent.isNotEmpty) (l.uiCoordFactParent, p.parent),
      if (p.founded case final f?) (l.uiCoordFactFounded, l.coordDate(f)),
      (l.uiCoordFactVisibility, l.uiCoordVisibilityAll),
    ];
    return CoordRows(
      children: [
        for (final (k, v) in facts)
          MergeSemantics(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 46),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NizamioSpacing.rowPad,
                  vertical: NizamioSpacing.space2,
                ),
                child: Row(
                  children: [
                    Text(k, style: t.bodyMd.copyWith(color: c.textMuted)),
                    const Gap(NizamioSpacing.space4),
                    Expanded(
                      child: Text(
                        v,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMd,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
