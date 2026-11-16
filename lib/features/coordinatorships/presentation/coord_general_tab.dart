import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_uniform_grid.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../activity/activity.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../domain/coordinatorship_board.dart';
import '../domain/coordinatorship_overview.dart';
import 'coord_detail_texts.dart';
import 'coord_general_cards.dart';
import 'coord_parts.dart';

/// Genel bölümü: eşit özet kartları, iş yükü ve (yalnız yönetici görünümünde; işlem geçmişi
/// koordinatöre kapalı, AUDIT-K10) son hareketler. Takvim kendi bölümündedir.
class CoordGeneralTab extends ConsumerWidget {
  const CoordGeneralTab({
    super.key,
    required this.detail,
    required this.pulse,
    required this.people,
    required this.catalog,
  });

  final CoordinatorshipDetail detail;
  final CoordPulse pulse;
  final List<CoordPerson> people;
  final TaskCatalog catalog;

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
    final manages = ref.watch(coordManagesTeamProvider(code));

    final cards = [
      NzKpiTile(
        icon: NzIcons.tasks,
        tone: c.inProgress,
        label: l.uiCoordTabTasks,
        value: '${pulse.total}',
        segments: [
          NzBarSegment(pulse.done, c.taskDone),
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
        caption: l.coordLeadsMembers(
          leads.length,
          people.length - leads.length,
        ),
        onTap: manages ? () => go(CoordinatorshipTab.members) : null,
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
        label: l.uiCoordTabCalendar,
        value: meetings == null ? '—' : '${upcoming.length}',
        segments: [
          NzBarSegment(upcoming.length, c.info),
          NzBarSegment(past, c.surfaceOverlay),
        ],
        caption: meetings == null
            ? '—'
            : l.coordNextMeeting(upcoming.firstOrNull),
        onTap: () => go(CoordinatorshipTab.calendar),
      ),
    ];
    final tasks = catalog.tasksOf(code);
    final audit = ref.watch(effectiveAccessProvider).canAdminister;
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth >= coordWideWidth;
        final load = CoordLoadCard(
          code: code,
          catalog: catalog,
          tasks: tasks,
          people: people,
        );
        // Prototip: özet kartları arası 10, özet ile kartlar arası 22, kartlar arası 12.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartlar içerik yüksekliğinde (sabit 220 yok); hepsi en uzununa eşitlenir.
            UniformGrid(columns: wide ? 4 : 2, gap: 10, children: cards),
            const Gap(22),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: NizamioSpacing.space3,
              children: [load, if (audit) const ActivityLogCard()],
            ),
          ],
        );
      },
    );
  }
}
