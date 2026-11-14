import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/feedback/nz_load_strip.dart';
import '../../../../core/ui/widgets/nz_glyph.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../meetings/meetings.dart';
import '../../../tasks/tasks.dart';
import 'home_coordinator.dart';
import 'home_texts.dart';
import 'home_wide.dart';

/// Koordinatör özet kutuları (yönetici ana sayfasının dili ve sırası): gecikme, bekleyen tarih
/// taleplerim (talep sayfası), atanmamış, onay bekleyen, tamamlanma (yüzde), devam eden.
/// Dokunma görev listesini ilgili görünümle açar.
List<Widget> homeCoordinatorKpis(
  BuildContext context, {
  required CoordinatorBoard board,
  required int pendingRequests,
}) {
  final l = context.l10n;
  final c = context.colors;
  final nav = context.appNav;
  final s = board.summary;
  final more = board.truncated ? '≥' : '';
  final open = s.total - s.done;
  double ratio(int a, int b) => b == 0 ? 0 : a / b;
  Widget tile(
    NzGlyph glyph,
    Color tone,
    String label,
    String value,
    double progress,
    VoidCallback onTap, {
    bool danger = false,
  }) => NzKpiTile(
    glyph: glyph,
    tone: tone,
    label: label,
    value: value,
    valueColor: danger ? c.danger : null,
    progress: progress,
    onTap: onTap,
    semanticLabel: '$label: $value. ${l.uiHomeOpenList}',
  );
  return [
    tile(
      NzGlyphs.late,
      c.danger,
      l.uiHomeKpiLate,
      '$more${s.late}',
      ratio(s.late, open),
      () => nav.openTasks(view: NzTaskView.late),
      danger: true,
    ),
    tile(
      NzGlyphs.dateRequest,
      c.warning,
      l.uiHomeRequestsTitle,
      '$pendingRequests',
      ratio(pendingRequests, open),
      () => showDateRequestsSheet(context),
    ),
    tile(
      NzGlyphs.personAdd,
      c.info,
      l.uiHomeUnassignedTitle,
      '$more${s.unassigned}',
      ratio(s.unassigned, open),
      () => nav.openTasks(view: NzTaskView.unassigned),
    ),
    tile(
      NzGlyphs.review,
      c.warning,
      l.uiHomeKpiReview,
      '$more${s.review}',
      ratio(s.review, open),
      () => nav.openTasks(view: NzTaskView.review),
    ),
    tile(
      NzGlyphs.done,
      c.taskDone,
      l.uiHomeKpiDone,
      l.percent(ratio(s.done, s.total)),
      ratio(s.done, s.total),
      () => nav.openTasks(view: NzTaskView.done),
    ),
    tile(
      NzGlyphs.inProgress,
      c.inProgress,
      l.uiHomeKpiDoing,
      '$more${s.inProgress}',
      ratio(s.inProgress, s.total),
      () => nav.openTasks(view: NzTaskView.inProgress),
    ),
  ];
}

/// Koordinatörlüğün ekibi (tablet, yönetici "Ekip" kutularının dili): koordinatör ve üye
/// sayısı; dokunma görev listesini o kişilerle süzer. Ekip bilinmiyorsa boş.
List<Widget> homeCoordinatorTeamTiles(
  BuildContext context,
  CoordinatorshipRef? coord,
) {
  if (coord == null) return const [];
  final l = context.l10n;
  final c = context.colors;
  final nav = context.appNav;
  final total = coord.leads.length + coord.members.length;
  return [
    HomeTeamTile(
      dot: c.roleCoordinator,
      bar: c.roleCoordinator,
      count: coord.leads.length,
      total: total,
      label: l.uiHomeRoleCoordinator,
      onTap: () => nav.openTasks(people: coord.leads),
    ),
    HomeTeamTile(
      dot: c.roleMember,
      bar: c.roleMember,
      count: coord.members.length,
      total: total,
      label: l.uiHomeRoleMember,
      onTap: () => nav.openTasks(people: coord.members),
    ),
  ];
}

/// Ekip yükü: kişi başına açık görev şeridi ve "n açık · m geç". Şerit parçaları ayrıktır:
/// geciken (durumdan bağımsız), sonra devam, onayda, iade, başlamadı; şerit boyu en yüklü kişiye
/// göre ölçeklenir (kalanı iz rengi). Backend koordinatöre yük ucu açmaz; sayım görünen
/// görevlerden ([CoordinatorBoard.load], [CoordinatorBoard.tasks]).
class HomeTeamLoad extends ConsumerWidget {
  const HomeTeamLoad({super.key, required this.board, this.fill = false});

  final CoordinatorBoard board;

  /// Bkz. [HomeSectionFrame.fill].
  final bool fill;

  static const maxRows = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final rows = [
      for (final p in board.load)
        if (p.open > 0) p,
    ].take(maxRows).toList();
    // İade: geciken kırmızısının koyu tonu (prototip `.ld-back`).
    final returnedColor = c.danger.withValues(alpha: 0.5);
    final widest = rows.fold(0, (m, p) => p.open > m ? p.open : m);
    List<NzBarSegment> segments(String id, int open) {
      final mine = [
        for (final t in board.tasks)
          if (!t.isDone && t.assignees.contains(id)) t,
      ];
      final late = mine.where(isTaskLate).length;
      int count(TaskStatus s) =>
          mine.where((t) => !isTaskLate(t) && t.status == s).length;
      final doing = count(TaskStatus.inProgress);
      final review = count(TaskStatus.review);
      final returned = count(TaskStatus.returned);
      return [
        NzBarSegment(doing, c.inProgress),
        NzBarSegment(review, c.warning),
        NzBarSegment(late, c.danger),
        NzBarSegment(returned, returnedColor),
        NzBarSegment(open - late - doing - review - returned, c.textFaint),
        NzBarSegment(widest - open, c.surfaceOverlay),
      ];
    }

    Widget legend(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NzDot(color: color),
        const Gap(NizamioSpacing.space2),
        Text(label, style: context.text.bodySm.copyWith(color: c.textMuted)),
      ],
    );
    return HomeSectionFrame(
      fill: fill,
      title: l.uiHomeLoadTitle,
      count: rows.length,
      onAll: context.appNav.openUsers,
      empty: l.uiHomeLoadEmpty,
      children: [
        for (final p in rows)
          NzLoadRow(
            name: catalog?.nameOf(p.personId) ?? l.uiTasksUnknownPerson,
            selfLabel: p.personId == catalog?.me ? l.uiUsersTeamYou : null,
            caption:
                '${p.open} ${l.uiHomeLoadOpenTail}'
                '${p.late > 0 ? ' · ${p.late} ${l.uiHomeLoadLateTail}' : ''}',
            captionDanger: p.late > 0,
            segments: segments(p.personId, p.open),
            // Hızlı erişim: kişinin görevleri.
            onTap: () => context.appNav.openTasks(people: [p.personId]),
          ),
        if (rows.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(NizamioSpacing.space4),
            child: Wrap(
              spacing: NizamioSpacing.space4,
              runSpacing: NizamioSpacing.space1,
              children: [
                legend(c.inProgress, l.uiHomeLoadDoing),
                legend(c.warning, l.uiHomeLoadReview),
                legend(c.danger, l.uiHomeChipLate),
                legend(returnedColor, l.uiHomeLoadReturned),
              ],
            ),
          ),
      ],
    );
  }
}

/// Yaklaşan toplantılar (en çok 3; toplantılar modülünün görünür listesinden): toplantılar
/// sayfasındaki kartın aynısı ([MeetingCard]); boşsa boş metinli kart. Canlı konferansı olan
/// toplantı başlangıcı geçmiş olsa da listede kalır.
class HomeUpcomingMeetings extends ConsumerWidget {
  const HomeUpcomingMeetings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final nav = context.appNav;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    return NzAsyncView<MeetingsBoard>(
      value: ref.watch(meetingsBoardControllerProvider),
      onRetry: () => ref.invalidate(meetingsBoardControllerProvider),
      loading: const NzSkeleton.block(height: 120),
      data: (b) {
        final now = DateTime.now();
        final next = [
          for (final m in b.visible)
            if (isLive(m) || !m.meetingDate.toLocal().isBefore(now)) m,
        ]..sort((a, z) => a.meetingDate.compareTo(z.meetingDate));
        if (next.isEmpty) {
          return HomeSectionFrame(
            title: l.uiHomeMeetingsTitle,
            count: 0,
            onAll: nav.openMeetings,
            empty: l.uiHomeMeetingsEmpty,
            children: const [],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NzSectionHeader(
              l.uiHomeMeetingsTitle,
              count: next.length,
              onAll: nav.openMeetings,
              allLabel: l.uiHomeSeeAll,
            ),
            const Gap(NizamioSpacing.gapMd),
            for (final (i, m)
                in next.take(HomeCoordinatorFeed.rowsPerSection).indexed) ...[
              if (i > 0) const Gap(NizamioSpacing.gapMd),
              MeetingCard(
                meeting: m,
                catalog: catalog,
                onTap: () => nav.openMeeting(m.id),
              ),
            ],
          ],
        );
      },
    );
  }

  /// Toplantıda canlı konferans var mı (üye yaklaşanlarıyla ortak).
  static bool isLive(Meeting m) =>
      m.summary?.conferenceStatus == SummaryConferenceStatus.live;
}

/// Toplantı satırı: tarih kutusu (gün / mono saat; bugün vurgulu), başlık, koordinatörlük
/// kodları (ilki kalın) + katılımcı sayısı (veride varsa), canlıysa "● Canlı" hapı.
class HomeMeetingRow extends StatelessWidget {
  const HomeMeetingRow({
    super.key,
    required this.meeting,
    required this.now,
    required this.live,
    required this.codes,
    required this.onTap,
  });

  final Meeting meeting;
  final DateTime now;
  final bool live;
  final List<String> codes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final at = meeting.meetingDate.toLocal();
    final today = DateUtils.isSameDay(at, now);
    final people = meeting.summary?.participantCount ?? 0;
    final meta = t.bodyMd.copyWith(color: c.textMuted);
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(NizamioSpacing.space4),
          child: Row(
            children: [
              HomeDateBox(
                top: today
                    ? l.uiMeetingsGroupToday
                    : DateFormat('EEE d', 'tr').format(at),
                bottom: DateFormat.Hm('tr').format(at),
                highlight: today,
              ),
              const Gap(NizamioSpacing.gapMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodyLg.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const Gap(NizamioSpacing.space1),
                    Text.rich(
                      TextSpan(
                        children: [
                          for (final (i, code) in codes.indexed)
                            TextSpan(
                              text: i == 0 ? code : ' $code',
                              style: i == 0
                                  ? t.bodyMd.copyWith(
                                      fontWeight: FontWeight.w700,
                                    )
                                  : meta,
                            ),
                          if (people > 0)
                            TextSpan(
                              text: ' · $people ${l.uiMeetingsPeopleTail}',
                              style: meta,
                            ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (live) ...[
                const Gap(NizamioSpacing.space2),
                NzDotChip(color: c.success, label: l.uiMeetingsConfLive),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Satır başı tarih kutusu: üstte gün ("Bugün" / "Per 14"), altta mono satır (saat ya da
/// etiket); [highlight] bugünü vurgular.
class HomeDateBox extends StatelessWidget {
  const HomeDateBox({
    super.key,
    required this.top,
    required this.bottom,
    this.highlight = false,
  });

  final String top;
  final String bottom;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: highlight ? c.primary.withValues(alpha: 0.16) : c.surfaceOverlay,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
      ),
      child: SizedBox(
        width: NizamioSize.controlMd * 1.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space2),
          child: Column(
            children: [
              Text(
                top,
                maxLines: 1,
                style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(bottom, maxLines: 1, style: t.mono),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tarih taleplerim (en çok 3; durum hapıyla, düz satır).
class HomeMyDateRequests extends ConsumerWidget {
  const HomeMyDateRequests({super.key, this.fill = false});

  /// Bkz. [HomeSectionFrame.fill].
  final bool fill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    return NzAsyncView<List<DateChangeRequest>>(
      value: ref.watch(myDateRequestsProvider),
      onRetry: () => ref.invalidate(myDateRequestsProvider),
      loading: const NzSkeleton.block(height: 96),
      data: (all) => HomeSectionFrame(
        fill: fill,
        title: l.uiHomeRequestsTitle,
        count: all.length,
        onAll: all.isEmpty ? null : () => showDateRequestsSheet(context),
        empty: l.uiHomeRequestsEmpty,
        children: [
          for (final r in all.take(HomeCoordinatorFeed.rowsPerSection))
            DateRequestRow(
              request: r,
              title: catalog?.task(r.workItemId ?? '')?.title,
              code: switch (catalog?.task(r.workItemId ?? '')) {
                final t? => catalog?.coordinatorship(t.coordinatorship)?.label,
                null => null,
              },
              flat: true,
            ),
        ],
      ),
    );
  }
}
