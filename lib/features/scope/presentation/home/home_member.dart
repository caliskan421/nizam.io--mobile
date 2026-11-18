import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../meetings/meetings.dart';
import '../../../tasks/tasks.dart';
import '../../application/member_home.dart';
import 'home_coordinator.dart';
import 'home_coordinator_sections.dart';
import 'home_member_cards.dart';
import 'home_overview.dart';
import 'home_sections.dart';
import 'home_wide.dart';

/// Ana sayfanın üye bölümleri (tasarım §4.1; yönetici/koordinatör ana sayfasının dili): genel durum,
/// odak kartı, iade kartı (varsa), dört özet kutusu (gecikme, onayda, iade, tamamlanma), Yaklaşanlar
/// (toplantılar kartla + kendi bitişleri; 7 gün). Hızlı işlem, ekip yükü ve bekleyen işler
/// üyede yok (yetki/veri üyeye kapalı). Geniş düzen: genel durum (kendi görevleri) + odak kartı
/// aynı yükseklikte; kutular tek satır; iade ve Yaklaşanlar tam genişlik.
class HomeMemberFeed extends ConsumerWidget {
  const HomeMemberFeed({super.key, required this.wide});

  final bool wide;

  /// Yaklaşanlar alt bölümlerinde gösterilen en çok öğe.
  static const upcomingRows = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(memberHomeProvider);
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    if (home == null || catalog == null) {
      return const NzSkeleton.block(height: 190);
    }
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
    final kpis = HomeGrid(
      columns: wide ? 4 : 2,
      gap: NizamioSpacing.gapMd,
      children: homeMemberKpis(
        context,
        stats: home.stats,
        truncated: home.truncated,
      ),
    );
    final upcoming = _MemberUpcoming(home: home, today: today, code: code);
    final overview = HomeOverview(
      statuses: [for (final t in home.tasks) t.status],
      truncated: home.truncated,
      legendGrid: wide,
    );
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, w) in [
            overview,
            focus,
            ?returned,
            kpis,
            upcoming,
          ].indexed) ...[if (i > 0) const Gap(NizamioSpacing.gapXl), w],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Genel durum (kendi görevleri) + odak kartı aynı yükseklikte.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 5, child: overview),
              const Gap(homeWideGap),
              Expanded(flex: 4, child: focus),
            ],
          ),
        ),
        const Gap(NizamioSpacing.gapXl),
        kpis,
        if (returned != null) ...[const Gap(NizamioSpacing.gapXl), returned],
        const Gap(NizamioSpacing.gapXl),
        upcoming,
      ],
    );
  }
}

/// Yaklaşanlar (7 gün): "Toplantılar" toplantılar sayfasının kartıyla ([MeetingCard]), "Son
/// tarihler" kendi görevlerinin bitişleri; her alt bölümde en çok
/// [HomeMemberFeed.upcomingRows]. Toplantı listesi hatası yalnız bu bölümü etkiler.
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
        final items = memberUpcoming(
          home.tasks,
          b.visible,
          today: today,
          now: DateTime.now(),
          live: HomeUpcomingMeetings.isLive,
          limit: 100,
        );
        final meetings = [for (final x in items) ?x.meeting];
        final dues = [for (final x in items) ?x.task];
        if (meetings.isEmpty && dues.isEmpty) {
          return HomeSectionFrame(
            title: l.uiHomeMemberUpcomingTitle,
            count: 0,
            onAll: nav.openMeetings,
            allLabel: l.uiHomeSeeAll,
            empty: l.uiHomeMemberUpcomingEmpty,
            children: const [],
          );
        }
        const n = HomeMemberFeed.upcomingRows;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NzSectionHeader(
              l.uiHomeMemberUpcomingTitle,
              count: meetings.length + dues.length,
              onAll: nav.openMeetings,
              allLabel: l.uiHomeSeeAll,
            ),
            if (meetings.isNotEmpty) ...[
              const Gap(NizamioSpacing.gapMd),
              for (final (i, m) in meetings.take(n).indexed) ...[
                if (i > 0) const Gap(NizamioSpacing.gapMd),
                MeetingCard(
                  meeting: m,
                  catalog: catalog,
                  onTap: () => nav.openMeeting(m.id),
                ),
              ],
            ],
            if (dues.isNotEmpty) ...[
              const Gap(NizamioSpacing.gapMd),
              NzKicker(l.uiHomeMemberUpcomingDues),
              const Gap(NizamioSpacing.space2),
              NzTableCard(
                children: [
                  for (final t in dues.take(n))
                    HomeMemberDueRow(task: t, today: today, code: code(t)),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
