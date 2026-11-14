import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import 'home_coordinator_sections.dart';
import 'home_wide.dart';
import 'module_menu_texts.dart';

/// Ana sayfanın koordinatör bölümleri (prototip `home`, `hm.isK`): koordinatörlük özeti +
/// çipler, onay bekleyenler (İade / Onayla), atanmamış (Üstlen / Ata), ekip yükü, yaklaşan
/// toplantılar, tarih taleplerim. Kaynak etkin koordinatörlüğün görevleri
/// ([coordinatorBoardProvider]); ayrı sayfa değil, ana sayfanın koordinatör görünümüdür.
/// Geniş düzende iki sütun (karar listeleri solda, ekip ve takvim sağda).
class HomeCoordinatorFeed extends ConsumerWidget {
  const HomeCoordinatorFeed({super.key, required this.wide});

  final bool wide;

  /// Bölüm başına gösterilen satır.
  static const rowsPerSection = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(coordinatorBoardProvider);
    final today = ref.watch(
      taskCatalogControllerProvider.select((s) => s.value?.today),
    );
    if (board == null || today == null) {
      return const NzSkeleton.block(height: 190);
    }
    final l = context.l10n;
    final summary = HomeCoordinatorSummary(board: board);
    final queue = HomeSectionFrame(
      title: l.uiHomeQueueTitle,
      count: board.queue.length,
      onAll: board.queue.length > rowsPerSection
          ? () => showReviewQueueSheet(context)
          : null,
      empty: l.uiHomeQueueEmpty,
      children: [
        for (final t in board.queue.take(rowsPerSection))
          TaskQueueRow(task: t, today: today),
      ],
    );
    final Widget? unassigned = board.unassigned.isEmpty
        ? null
        : HomeSectionFrame(
            title: l.uiHomeUnassignedTitle,
            count: board.unassigned.length,
            onAll: board.unassigned.length > rowsPerSection
                ? () => context.appNav.openTasks(view: NzTaskView.unassigned)
                : null,
            children: [
              for (final t in board.unassigned.take(rowsPerSection))
                TaskUnassignedRow(task: t, today: today),
            ],
          );
    final left = [
      queue,
      if (unassigned != null) ...[const Gap(NizamioSpacing.gapXl), unassigned],
    ];
    final right = [
      HomeTeamLoad(board: board),
      const Gap(NizamioSpacing.gapXl),
      const HomeUpcomingMeetings(),
      const Gap(NizamioSpacing.gapXl),
      const HomeMyDateRequests(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        summary,
        const Gap(NizamioSpacing.gapXl),
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: left,
                ),
              ),
              const Gap(homeWideGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: right,
                ),
              ),
            ],
          )
        else ...[
          ...left,
          const Gap(NizamioSpacing.gapXl),
          ...right,
        ],
      ],
    );
  }
}

/// Bölüm iskeleti: kicker (sayaç ya da "Tümü"), satırlar arası boşluk, boş metni.
class HomeSectionFrame extends StatelessWidget {
  const HomeSectionFrame({
    super.key,
    required this.title,
    required this.children,
    this.count,
    this.onAll,
    this.empty,
  });

  final String title;
  final int? count;
  final List<Widget> children;
  final VoidCallback? onAll;
  final String? empty;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final onAll = this.onAll;
    final empty = this.empty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (onAll != null)
          NzKicker(
            title,
            action: NzButton.ghost(
              label: l.uiHomeSeeAll,
              size: NzSize.sm,
              onPressed: onAll,
            ),
          )
        else
          NzKicker(title, trailing: count == null ? null : '$count'),
        const Gap(NizamioSpacing.gapMd),
        if (children.isEmpty && empty != null)
          Text(empty, style: context.text.bodySm.copyWith(color: c.textMuted))
        else
          for (final (i, w) in children.indexed) ...[
            if (i > 0) const Gap(NizamioSpacing.space2),
            w,
          ],
      ],
    );
  }
}

/// Karşılamanın altındaki etkin görünüm satırı: rol noktası + "Koordinatör · Altyapı ve
/// tesisat".
class HomeViewLine extends StatelessWidget {
  const HomeViewLine({super.key, required this.view});

  final EffectiveAccess view;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        NzDot(color: effectiveRoleColor(c, view.role)),
        const Gap(NizamioSpacing.space2),
        Expanded(
          child: Text(
            context.l10n.viewCaption(view),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodySm.copyWith(color: c.textMuted),
          ),
        ),
      ],
    );
  }
}
