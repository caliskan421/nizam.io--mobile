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
import '../../../../core/ui/widgets/lists/lists.dart';
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
    Widget chip(
      int n,
      String label,
      NzBadge Function(String) badge,
      VoidCallback onTap,
    ) => Semantics(
      button: true,
      label: '$n $label',
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: badge('$more$n $label'),
      ),
    );
    final chips = [
      if (s.late > 0)
        chip(
          s.late,
          l.uiHomeChipLate,
          (v) => NzBadge.danger(label: v),
          () => nav.openTasks(view: NzTaskView.late),
        ),
      if (s.review > 0)
        chip(
          s.review,
          l.uiHomeChipReview,
          (v) => NzBadge.warning(label: v),
          () => nav.openTasks(view: NzTaskView.review),
        ),
      if (s.returned > 0)
        chip(
          s.returned,
          l.uiHomeChipReturned,
          (v) => NzBadge.danger(label: v),
          () => nav.openTasks(view: NzTaskView.inProgress),
        ),
      if (s.unassigned > 0)
        chip(
          s.unassigned,
          l.uiHomeChipUnassigned,
          (v) => NzBadge.info(label: v),
          () => nav.openTasks(view: NzTaskView.unassigned),
        ),
      if (pending > 0)
        chip(
          pending,
          l.uiHomeChipRequests,
          (v) => NzBadge.neutral(label: v),
          () => showDateRequestsSheet(context),
        ),
    ];
    return NzCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  board.departmentName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Gap(NizamioSpacing.space2),
              Text('%$pct', style: t.titleSm),
            ],
          ),
          const Gap(NizamioSpacing.space1),
          Text(
            '${s.done} / $more${s.total} ${l.uiHomeCoordDoneTail}',
            style: t.caption.copyWith(color: c.textMuted),
          ),
          const Gap(NizamioSpacing.space3),
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
            const Gap(NizamioSpacing.space3),
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

/// Ekip yükü: kişi başına açık görev şeridi (devam, onayda, iade, başlamadı) ve "n açık · m
/// geç". Backend koordinatöre yük ucu açmaz; sayım görünen görevlerden ([CoordinatorBoard.load]).
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
    Widget legend(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NzDot(color: color),
        const Gap(NizamioSpacing.space1),
        Text(label, style: context.text.caption.copyWith(color: c.textMuted)),
      ],
    );
    return HomeSectionFrame(
      title: l.uiHomeLoadTitle,
      onAll: context.appNav.openUsers,
      empty: l.uiHomeLoadEmpty,
      children: [
        for (final p in rows)
          NzLoadRow(
            name: catalog?.nameOf(p.personId) ?? l.uiTasksUnknownPerson,
            caption:
                '${p.open} ${l.uiHomeLoadOpenTail}'
                '${p.late > 0 ? ' · ${p.late} ${l.uiHomeLoadLateTail}' : ''}',
            captionDanger: p.late > 0,
            segments: [
              NzBarSegment(p.inProgress, c.inProgress),
              NzBarSegment(p.review, c.warning),
              NzBarSegment(p.returned, c.danger),
              NzBarSegment(
                p.open - p.inProgress - p.review - p.returned,
                c.textFaint,
              ),
            ],
          ),
        if (rows.isNotEmpty)
          Wrap(
            spacing: NizamioSpacing.space3,
            runSpacing: NizamioSpacing.space1,
            children: [
              legend(c.inProgress, l.uiHomeLoadDoing),
              legend(c.warning, l.uiHomeLoadReview),
              legend(c.danger, l.uiHomeLoadReturned),
            ],
          ),
      ],
    );
  }
}

/// Yaklaşan toplantılar (en çok 3; toplantılar modülünün görünür listesinden).
class HomeUpcomingMeetings extends ConsumerWidget {
  const HomeUpcomingMeetings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final nav = context.appNav;
    return NzAsyncView<MeetingsBoard>(
      value: ref.watch(meetingsBoardControllerProvider),
      onRetry: () => ref.invalidate(meetingsBoardControllerProvider),
      loading: const NzSkeleton.block(height: 120),
      data: (b) {
        final now = DateTime.now();
        final next = [
          for (final m in b.visible)
            if (!m.meetingDate.toLocal().isBefore(now)) m,
        ]..sort((a, z) => a.meetingDate.compareTo(z.meetingDate));
        final fmt = DateFormat('d MMM EEE · HH:mm', 'tr');
        return HomeSectionFrame(
          title: l.uiHomeMeetingsTitle,
          onAll: nav.openMeetings,
          empty: l.uiHomeMeetingsEmpty,
          children: [
            for (final m in next.take(HomeCoordinatorFeed.rowsPerSection))
              NzListTile.navigation(
                title: m.title,
                subtitle: [
                  fmt.format(m.meetingDate.toLocal()),
                  ...m.departments.map((d) => d.name),
                ].join(' · '),
                size: NzSize.sm,
                onTap: () => nav.openMeeting(m.id),
              ),
          ],
        );
      },
    );
  }
}

/// Tarih taleplerim (en çok 3; durum rozetiyle). Bekleyen talep "Yöneticide bekliyor"dur.
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
        onAll: all.isEmpty ? null : () => showDateRequestsSheet(context),
        empty: l.uiHomeRequestsEmpty,
        children: [
          for (final r in all.take(HomeCoordinatorFeed.rowsPerSection))
            DateRequestRow(
              request: r,
              title: catalog?.task(r.workItemId ?? '')?.title,
            ),
        ],
      ),
    );
  }
}
