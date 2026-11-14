import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../archive/archive.dart';
import '../../calendar/calendar.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../domain/coordinatorship_board.dart';
import 'coord_detail_texts.dart';
import 'coord_parts.dart';
import 'coord_widgets.dart';

/// Arşiv bölümü (prototip `tArc`): dosya sayısı ve boyutu, tür dağılımı, son yüklenen beş
/// dosya ve "Arşivde tümünü gör". Kaynak sunucu arşivi (bu birimin görevlerine bağlı dosyalar).
class CoordArchiveTab extends ConsumerWidget {
  const CoordArchiveTab({super.key, required this.code, required this.catalog});

  final String code;

  final TaskCatalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    Future<void> openArchive() async {
      try {
        final folders = await ref.read(archiveFoldersControllerProvider.future);
        if (!context.mounted) return;
        final target =
            folders.where((f) => f.code == code).firstOrNull ??
            folders.where((f) => f.isVirtual).firstOrNull;
        if (target == null) {
          context.appNav.openArchive();
        } else {
          context.appNav.openArchiveFolder(target.code);
        }
      } on Object catch (e, st) {
        reportUnexpected(e, st, source: ReportSource.coordinatorships);
        if (context.mounted) context.appNav.openArchive();
      }
    }

    Future<void> openFile(CoordFile file) async {
      try {
        final folders = await ref.read(archiveFoldersControllerProvider.future);
        if (!context.mounted) return;
        final target =
            folders.where((f) => f.code == code).firstOrNull ??
            folders.where((f) => f.isVirtual).firstOrNull;
        if (target == null) {
          NzToast.show(context, l.uiArchiveEmptyFiles);
          return;
        }
        await openArchiveFile(
          context,
          folderCode: target.code,
          workItemId: file.workItemId,
          fileId: file.id,
          taskTitle: (id) => catalog.task(id)?.title,
        );
      } on Object catch (error, st) {
        // Rapor, bağlam korumasından ÖNCE.
        final api = toReportedApiError(
          error,
          st,
          source: ReportSource.coordinatorships,
        );
        if (context.mounted) NzToast.error(context, api);
      }
    }

    return NzAsyncView<List<CoordFile>>(
      value: ref.watch(coordinatorshipFilesProvider(code)),
      onRetry: () => ref.invalidate(coordinatorshipFilesProvider(code)),
      data: (files) {
        final bytes = files.fold<int>(0, (a, f) => a + f.sizeBytes);
        final kinds = [
          for (final k in CoordFileKind.values)
            (k, files.where((f) => f.kind == k).length),
        ].where((k) => k.$2 > 0).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: NizamioSpacing.gapXl,
          children: [
            CoordPanel(
              padding: const EdgeInsets.all(NizamioSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: NizamioSpacing.space3,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${files.length}',
                        style: t.numeral.copyWith(fontSize: 28),
                      ),
                      const Gap(NizamioSpacing.space2),
                      Expanded(
                        child: Text(
                          l.coordFilesSize(bytes),
                          style: t.caption.copyWith(color: c.textMuted),
                        ),
                      ),
                    ],
                  ),
                  NzProgressBar.segments(
                    segments: [
                      for (final (k, n) in kinds)
                        NzBarSegment(n, coordKindColor(context, k)),
                    ],
                  ),
                  Wrap(
                    spacing: NizamioSpacing.space4,
                    runSpacing: 6,
                    children: [
                      for (final (k, n) in kinds)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 6,
                          children: [
                            NzDot(color: coordKindColor(context, k)),
                            Text(
                              '${l.coordKindLabel(k)} $n',
                              style: t.caption.copyWith(color: c.textMuted),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            CoordBlock(
              label: l.uiCoordRecentFiles,
              child: CoordRows(
                children: [
                  for (final f in files.take(5))
                    CoordListRow(
                      leading: CoordKindTile(kind: f.kind),
                      title: f.name,
                      subtitle: [
                        catalog.task(f.workItemId)?.title,
                        catalog.nameOf(f.uploaderId)?.split(' ').first,
                        l.coordBytes(f.sizeBytes),
                      ].nonNulls.join(' · '),
                      chevron: false,
                      onTap: () => openFile(f),
                    ),
                  if (files.isEmpty) CoordEmpty(l.uiCoordNoFiles),
                  CoordRow(
                    onTap: openArchive,
                    semanticLabel: l.uiCoordAllInArchive,
                    minHeight: 48,
                    child: Center(
                      child: Text(
                        l.uiCoordAllInArchive,
                        style: t.bodySm.copyWith(color: c.textMuted),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Takvim bölümü (prototip `cdetail` Takvim): koordinatörlüğün ay takvimi (görev bitişleri ve
/// toplantılar) + toplantı listesi ve "Toplantı planla" ([CoordMeetingsTab]).
class CoordCalendarTab extends StatelessWidget {
  const CoordCalendarTab({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: NizamioSpacing.gapXl,
    children: [
      CoordinatorshipCalendar(code: code),
      CoordMeetingsTab(code: code),
    ],
  );
}

/// Toplantı bölümü (prototip `tMeet`): sayım + "Toplantı planla", sıradaki toplantı kartı,
/// sonraki üç toplantı, açılır geçmiş toplantılar. Kaynak sunucu (`listMeetings`).
class CoordMeetingsTab extends ConsumerWidget {
  const CoordMeetingsTab({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final provider = coordinatorshipDetailControllerProvider(code);
    final pastOpen = ref.watch(provider.select((v) => v.pastOpen));
    final nav = context.appNav;
    return NzAsyncView<List<CoordMeeting>>(
      value: ref.watch(coordinatorshipMeetingsProvider(code)),
      onRetry: () => ref.invalidate(coordinatorshipMeetingsProvider(code)),
      data: (all) {
        final now = DateTime.now();
        final up = all.where((m) => !m.at.isBefore(now)).toList();
        final past = all.where((m) => m.at.isBefore(now)).toList().reversed;
        final next = up.firstOrNull;
        Widget date(CoordMeeting m, {bool faded = false}) => Opacity(
          opacity: faded ? .6 : 1,
          child: SizedBox(
            width: 36,
            child: Column(
              children: [
                Text('${m.at.day}', style: t.labelLg.copyWith(fontSize: 15)),
                Text(
                  l.coordMonth(m.at),
                  style: t.monoSm.copyWith(fontSize: 9.5, color: c.textFaint),
                ),
              ],
            ),
          ),
        );
        CoordListRow row(CoordMeeting m, {bool faded = false}) => CoordListRow(
          leading: date(m, faded: faded),
          title: m.title,
          titleColor: faded ? c.textMuted : null,
          subtitle: l.coordMeetMeta(m),
          chevron: !faded,
          onTap: () => nav.openMeeting(m.id),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: NizamioSpacing.gapXl,
          children: [
            CoordSubhead(
              label: Text(
                l.coordMeetCount(up.length, past.length),
                style: t.bodySm.copyWith(color: c.textMuted),
              ),
              actions: [
                if (ref.watch(coordManagesTeamProvider(code)) &&
                    ref.watch(
                      effectiveAccessProvider.select((a) => a.canCreateMeeting),
                    ))
                  NzIconButton.circle(
                    icon: NzIcons.add,
                    semanticLabel: l.uiCoordMenuMeeting,
                    onPressed: () =>
                        showMeetingSheet(context, coordinatorship: code),
                  ),
              ],
            ),
            if (next != null) _NextMeeting(meeting: next, now: now),
            if (up.length > 1)
              CoordBlock(
                label: l.uiCoordLater,
                child: CoordRows(
                  children: [for (final m in up.skip(1).take(3)) row(m)],
                ),
              ),
            if (past.isNotEmpty)
              CoordRows(
                children: [
                  CoordRow(
                    onTap: ref.read(provider.notifier).togglePast,
                    semanticLabel: l.uiCoordPastMeetings,
                    expanded: pastOpen,
                    minHeight: 58,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.uiCoordPastMeetings,
                            style: t.labelLg.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '${past.length}',
                          style: t.monoSm.copyWith(color: c.textMuted),
                        ),
                        const Gap(NizamioSpacing.space2),
                        AnimatedRotation(
                          turns: pastOpen ? .5 : 0,
                          duration: NizamioMotion.durSheet,
                          child: NzIcon(
                            NzIcons.chevronDown,
                            size: NizamioSize.iconSizeSm,
                            color: c.textFaint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NzReveal(
                    open: pastOpen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final m in past) ...[
                          const CoordRowDivider(),
                          row(m, faded: true),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            if (all.isEmpty) CoordEmpty(l.uiCoordNoMeetings),
          ],
        );
      },
    );
  }
}

/// Sıradaki toplantı kartı (prototip `.cd-next`).
class _NextMeeting extends StatelessWidget {
  const _NextMeeting({required this.meeting, required this.now});

  final CoordMeeting meeting;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final m = meeting;
    return Semantics(
      button: true,
      label: [
        l.coordMeetWhen(m.at, now),
        m.title,
        l.coordMeetMeta(m),
      ].join(', '),
      excludeSemantics: true,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: c.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 3,
              colors: [c.inProgress.withValues(alpha: .10), c.surface],
              stops: const [0, .6],
            ),
          ),
          child: InkWell(
            onTap: () => context.appNav.openMeeting(meeting.id),
            child: Padding(
              padding: const EdgeInsets.all(NizamioSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: NizamioSpacing.space3,
                children: [
                  Text(
                    l.coordMeetWhen(m.at, now),
                    style: t.monoSm.copyWith(color: c.textFaint),
                  ),
                  Row(
                    spacing: 14,
                    children: [
                      Container(
                        width: 52,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: c.surfaceRaised,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${m.at.day}',
                              style: t.numeral.copyWith(fontSize: 24),
                            ),
                            Text(
                              l.coordMonth(m.at),
                              style: t.monoSm.copyWith(
                                fontSize: 10,
                                color: c.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text(
                              m.title,
                              style: t.labelLg.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              l.coordMeetMeta(m),
                              style: t.caption.copyWith(color: c.textMuted),
                            ),
                          ],
                        ),
                      ),
                      NzIcon(
                        NzIcons.chevronRight,
                        size: NizamioSize.iconSizeSm,
                        color: c.textFaint,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
