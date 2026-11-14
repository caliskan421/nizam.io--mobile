import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../meetings/meetings.dart';
import '../../../tasks/tasks.dart';
import '../../application/member_home.dart';
import 'home_coordinator.dart';
import 'home_coordinator_sections.dart';
import 'home_member_cards.dart';
import 'home_wide.dart';

/// Ana sayfanın üye bölümleri (tasarım §4.1; ayrı sayfa değil, [HomeCoordinatorFeed] emsali):
/// odak kartı, iade kartı (varsa), Görevlerim (istatistik + en çok 5 açık satır), Yaklaşanlar
/// (7 gün: toplantılar + kendi bitişleri). Hızlı işlem, KPI, genel durum ve koordinatörlük kartı
/// üyede çizilmez. Geniş düzende `pair(odak, iade)` ve `pair(görevlerim, yaklaşanlar)`; iade
/// yoksa odak tam genişlik.
class HomeMemberFeed extends ConsumerWidget {
  const HomeMemberFeed({super.key, required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(memberHomeProvider);
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    if (home == null || catalog == null) {
      return const NzSkeleton.block(height: 190);
    }
    final l = context.l10n;
    final c = context.colors;
    final today = catalog.today;
    String? code(TaskItem t) =>
        catalog.coordinatorship(t.coordinatorship)?.label;
    final focus = HomeMemberFocusCard(
      task: home.focus,
      today: today,
      code: switch (home.focus) {
        final t? => code(t),
        null => null,
      },
    );
    final Widget? returned = switch (home.returned) {
      final t? => HomeMemberReturnedCard(task: t, code: code(t)),
      null => null,
    };
    final tasks = HomeSectionFrame(
      title: l.uiHomeMemberTasksTitle,
      count: home.open.length,
      onAll: context.appNav.openTasks,
      empty: l.uiHomeMemberTasksEmpty,
      below: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeMemberStats(stats: home.stats, truncated: home.truncated),
          if (home.truncated) ...[
            const Gap(NizamioSpacing.space2),
            Text(
              l.uiListsTruncated,
              style: context.text.bodySm.copyWith(color: c.textMuted),
            ),
          ],
        ],
      ),
      children: [
        for (final t in home.open.take(MemberHome.rows))
          HomeMemberTaskRow(task: t, code: code(t)),
      ],
    );
    final upcoming = _MemberUpcoming(home: home, today: today, code: code);
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, w) in [focus, ?returned, tasks, upcoming].indexed) ...[
            if (i > 0) const Gap(NizamioSpacing.gapXl),
            w,
          ],
        ],
      );
    }
    Widget pair(Widget a, Widget b) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const Gap(homeWideGap),
        Expanded(child: b),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (returned == null) focus else pair(focus, returned),
        const Gap(NizamioSpacing.gapXl),
        pair(tasks, upcoming),
      ],
    );
  }
}

/// Yaklaşanlar: toplantı listesi hatası yalnız bu bölümü etkiler (bölüm içi hata + yeniden
/// dene); sayfa düşmez.
class _MemberUpcoming extends ConsumerWidget {
  const _MemberUpcoming({
    required this.home,
    required this.today,
    required this.code,
  });

  final MemberHome home;
  final DateTime today;
  final String? Function(TaskItem t) code;

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
        final items = memberUpcoming(
          home.tasks,
          b.visible,
          today: today,
          now: now,
          live: HomeUpcomingMeetings.isLive,
        );
        return HomeSectionFrame(
          title: l.uiHomeMemberUpcomingTitle,
          count: items.length,
          onAll: nav.openCalendar,
          allLabel: l.uiHomeModuleCalendar,
          empty: l.uiHomeMemberUpcomingEmpty,
          children: [
            for (final x in items)
              if (x.meeting case final m?)
                HomeMeetingRow(
                  meeting: m,
                  now: now,
                  live: HomeUpcomingMeetings.isLive(m),
                  codes: [
                    for (final d in m.departments)
                      catalog?.coordinatorship(d.id)?.label ?? d.name,
                  ],
                  onTap: () => nav.openMeeting(m.id),
                )
              else if (x.task case final t?)
                HomeMemberDueRow(task: t, today: today, code: code(t)),
          ],
        );
      },
    );
  }
}
