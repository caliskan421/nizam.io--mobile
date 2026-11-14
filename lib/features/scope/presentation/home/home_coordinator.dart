import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import 'home_coordinator_sections.dart';
import 'home_wide.dart';
import 'module_menu_texts.dart';

/// Ana sayfanın koordinatör bölümleri (prototip `home`, `hm.isK`): koordinatörlük özeti +
/// çipler, onay bekleyenler (İade / Onayla), atanmamış (Üstlen / Ata), ekip yükü, yaklaşan
/// toplantılar, tarih taleplerim. Kaynak etkin koordinatörlüğün görevleri
/// ([coordinatorBoardProvider]); ayrı sayfa değil, ana sayfanın koordinatör görünümüdür.
/// Geniş düzen: özet + hızlı işlemler ([quick]); onay bekleyenler tam genişlik; atanmamış +
/// tarih taleplerim; ekip yükü + yaklaşan toplantılar. Dar düzende tek sütun.
class HomeCoordinatorFeed extends ConsumerWidget {
  const HomeCoordinatorFeed({super.key, required this.wide, this.quick});

  final bool wide;

  /// Hızlı işlemler kartı (boşsa null; bölüm çizilmez).
  final Widget? quick;

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
    final quickSection = quick;
    final queue = HomeSectionFrame(
      title: l.uiHomeQueueTitle,
      count: board.queue.length,
      onAll: board.queue.length > rowsPerSection
          ? () => showReviewQueueSheet(context)
          : null,
      empty: l.uiHomeQueueEmpty,
      table: (l.uiHomeTableTask, l.uiHomeTableDue),
      children: [
        for (final t in board.queue.take(rowsPerSection))
          TaskQueueRow(task: t, today: today, flat: true, inline: wide),
      ],
    );
    final Widget? unassigned = board.unassigned.isEmpty
        ? null
        : HomeSectionFrame(
            fill: wide,
            title: l.uiHomeUnassignedTitle,
            count: board.unassigned.length,
            onAll: board.unassigned.length > rowsPerSection
                ? () => context.appNav.openTasks(view: NzTaskView.unassigned)
                : null,
            table: const (null, null),
            children: [
              for (final t in board.unassigned.take(rowsPerSection))
                TaskUnassignedRow(task: t, today: today, flat: true),
            ],
          );
    final rest = [
      HomeTeamLoad(board: board, fill: wide),
      HomeUpcomingMeetings(fill: wide),
      HomeMyDateRequests(fill: wide),
    ];
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, w) in [
            summary,
            ?quickSection,
            queue,
            ?unassigned,
            ...rest,
          ].indexed) ...[if (i > 0) const Gap(NizamioSpacing.gapXl), w],
        ],
      );
    }
    // Yan yana iki öğe aynı yükseklikte (veri az/boş olsa da); kartlar `fill` ile uzar.
    Widget pair(Widget a, Widget? b, {int flexA = 1, int flexB = 1}) =>
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: flexA, child: a),
              const Gap(homeWideGap),
              Expanded(flex: flexB, child: b ?? const SizedBox.shrink()),
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Özet geniş, hızlı işlemler 2×2 kare dokunaç (4:1); ikisi aynı yükseklikte.
        if (quickSection == null)
          summary
        else
          pair(summary, quickSection, flexA: 4, flexB: 1),
        const Gap(NizamioSpacing.gapXl),
        queue,
        const Gap(NizamioSpacing.gapXl),
        // Atanmamış yoksa tarih talepleri sola oturur; sağda boş sütun kalmaz.
        if (unassigned == null)
          pair(rest[2], null)
        else
          pair(unassigned, rest[2]),
        const Gap(NizamioSpacing.gapXl),
        pair(rest[0], rest[1]),
      ],
    );
  }
}

/// Bölüm iskeleti: [NzSectionHeader] (başlık, sayı, "Tümü ›") ve tek [NzTableCard] içinde
/// ayraçlı satırlar (satırlar kendi dolgusunu taşır); boşsa boş metni de kart içinde. [table]
/// sütun adlarıdır (verilmezse şeritsiz). [below] başlık ile kart arasına girer (üyede
/// istatistik şeridi).
class HomeSectionFrame extends StatelessWidget {
  const HomeSectionFrame({
    super.key,
    required this.title,
    required this.children,
    this.count,
    this.onAll,
    this.empty,
    this.table,
    this.below,
    this.allLabel,
    this.fill = false,
  });

  final String title;
  final int? count;
  final List<Widget> children;
  final VoidCallback? onAll;
  final String? empty;
  final (String?, String?)? table;
  final Widget? below;

  /// "Tümü" yerine bağlantı metni (ör. "Takvim").
  final String? allLabel;

  /// Verilen yüksekliği kartla doldurur (yan yana çiftte iki kart aynı boyda; içerik üstten).
  /// Yalnız sınırlı yükseklikte (çiftin `IntrinsicHeight` satırı) açılır.
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final empty = this.empty;
    final table = this.table;
    final card = children.isEmpty && empty != null
        ? NzTableCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(NizamioSpacing.space4),
                child: Text(
                  empty,
                  style: context.text.bodyMd.copyWith(color: c.textMuted),
                ),
              ),
            ],
          )
        : NzTableCard(
            leading: table?.$1,
            trailing: table?.$2,
            children: children,
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzSectionHeader(
          title,
          count: count,
          onAll: onAll,
          allLabel: allLabel ?? l.uiHomeSeeAll,
        ),
        const Gap(NizamioSpacing.gapMd),
        if (below case final w?) ...[w, const Gap(NizamioSpacing.gapMd)],
        if (fill) Expanded(child: card) else card,
      ],
    );
  }
}

/// Karşılamanın altındaki etkin görünüm kapsülü: rol noktası + "Koordinatör · Altyapı ve
/// tesisat".
class HomeViewLine extends StatelessWidget {
  const HomeViewLine({super.key, required this.view});

  final EffectiveAccess view;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: NzDotChip(
        color: effectiveRoleColor(context.colors, view.role),
        label: context.l10n.viewCaption(view),
      ),
    );
  }
}
