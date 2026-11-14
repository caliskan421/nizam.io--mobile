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
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../meetings/meetings.dart';
import '../../../tasks/tasks.dart';
import 'home_coordinator.dart';

/// Koordinatörlük özeti: ad, tamamlanma yüzdesi, "9 / 17 görev bitti", beş renkli durum
/// şeridi ve tıklanır çipler (geciken, onayında, iade, atanmamış, tarih talebi yöneticide; 0
/// olanlar gizli). Çipler görev listesini ilgili görünümle açar.
class HomeCoordinatorSummary extends ConsumerWidget {
  const HomeCoordinatorSummary({super.key, required this.board});

  final CoordinatorBoard board;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final nav = context.appNav;
    final s = board.summary;
    final pending = (ref.watch(myDateRequestsProvider).value ?? const [])
        .where((r) => r.isPending)
        .length;
    final pct = s.total == 0 ? 0 : (s.done * 100 / s.total).round();
    final more = board.truncated ? '≥' : '';
    Widget chip(int n, String label, Color color, VoidCallback onTap) =>
        NzDotChip(color: color, count: '$more$n', label: label, onTap: onTap);
    final chips = [
      if (s.late > 0)
        chip(
          s.late,
          l.uiHomeChipLate,
          c.danger,
          () => nav.openTasks(view: NzTaskView.late),
        ),
      if (s.review > 0)
        chip(
          s.review,
          l.uiHomeChipReview,
          c.warning,
          () => nav.openTasks(view: NzTaskView.review),
        ),
      if (s.returned > 0)
        chip(
          s.returned,
          l.uiHomeChipReturned,
          c.danger,
          () => nav.openTasks(view: NzTaskView.inProgress),
        ),
      if (s.unassigned > 0)
        chip(
          s.unassigned,
          l.uiHomeChipUnassigned,
          c.warning,
          () => nav.openTasks(view: NzTaskView.unassigned),
        ),
      if (pending > 0)
        chip(
          pending,
          l.uiHomeChipRequests,
          c.inProgress,
          () => showDateRequestsSheet(context),
        ),
    ];
    return NzCard.outlined(
      size: NzSize.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            board.departmentName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.titleSm,
          ),
          const Gap(NizamioSpacing.space3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('%$pct', style: t.displayLg),
              const Gap(NizamioSpacing.space3),
              Expanded(
                child: Text(
                  '${s.done} / $more${s.total} ${l.uiHomeCoordDoneTail}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodySm.copyWith(color: c.textMuted),
                ),
              ),
            ],
          ),
          const Gap(NizamioSpacing.space4),
          NzProgressBar.segments(
            segments: [
              NzBarSegment(s.done, c.taskDone),
              NzBarSegment(s.review, c.warning),
              NzBarSegment(s.inProgress, c.inProgress),
              NzBarSegment(s.returned, c.danger),
              NzBarSegment(s.todo, c.textFaint),
            ],
          ),
          if (chips.isNotEmpty) ...[
            const Gap(NizamioSpacing.space4),
            Wrap(
              spacing: NizamioSpacing.space2,
              runSpacing: NizamioSpacing.space2,
              children: chips,
            ),
          ],
        ],
      ),
    );
  }
}

/// Ekip yükü: kişi başına açık görev şeridi ve "n açık · m geç". Şerit parçaları ayrıktır:
/// geciken (durumdan bağımsız), sonra devam, onayda, iade, başlamadı; şerit boyu en yüklü kişiye
/// göre ölçeklenir (kalanı iz rengi). Backend koordinatöre yük ucu açmaz; sayım görünen
/// görevlerden ([CoordinatorBoard.load], [CoordinatorBoard.tasks]).
class HomeTeamLoad extends ConsumerWidget {
  const HomeTeamLoad({super.key, required this.board});

  final CoordinatorBoard board;

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

/// Yaklaşan toplantılar (en çok 3; toplantılar modülünün görünür listesinden). Canlı
/// konferansı olan toplantı başlangıcı geçmiş olsa da listede kalır.
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
        return HomeSectionFrame(
          title: l.uiHomeMeetingsTitle,
          count: next.length,
          onAll: nav.openMeetings,
          empty: l.uiHomeMeetingsEmpty,
          children: [
            for (final m in next.take(HomeCoordinatorFeed.rowsPerSection))
              HomeMeetingRow(
                meeting: m,
                now: now,
                live: isLive(m),
                codes: [
                  for (final d in m.departments)
                    catalog?.coordinatorship(d.id)?.label ?? d.name,
                ],
                onTap: () => nav.openMeeting(m.id),
              ),
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
  const HomeMyDateRequests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    return NzAsyncView<List<DateChangeRequest>>(
      value: ref.watch(myDateRequestsProvider),
      onRetry: () => ref.invalidate(myDateRequestsProvider),
      loading: const NzSkeleton.block(height: 96),
      data: (all) => HomeSectionFrame(
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
