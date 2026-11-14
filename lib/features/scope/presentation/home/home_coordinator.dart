import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import 'home_coordinator_sections.dart';
import 'home_overview.dart';
import 'home_sections.dart';
import 'home_wide.dart';
import 'module_menu_texts.dart';

/// Ana sayfanın koordinatör bölümleri; yönetici ana sayfasının dili (genel durum halkası, özet
/// kutuları) etkin koordinatörlüğün görevleriyle ([coordinatorBoardProvider]). Dar düzen tek
/// sütun: genel durum (koordinatörlük adı), hızlı işlemler, 2×2 özet kutusu, bekleyen işler
/// (onay / atanmamış / tarih talebi sekmeleri), ekip yükü, yaklaşan toplantılar. Geniş düzen:
/// genel durum + 2×2 hızlı işlemler; dört özet kutusu tek satır; bekleyen işler + ekip yükü
/// (aynı yükseklik); yaklaşan toplantılar.
class HomeCoordinatorFeed extends ConsumerWidget {
  const HomeCoordinatorFeed({super.key, required this.wide, this.quick});

  final bool wide;

  /// Hızlı işlemler (boşsa null; bölüm çizilmez). Geniş düzende 2×2 kart, darda tek satır.
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
    final overview = HomeOverview(
      statuses: [for (final t in board.tasks) t.status],
      truncated: board.truncated,
      title: board.departmentName,
      legendGrid: wide && quick != null,
    );
    final kpis = HomeGrid(
      columns: wide ? 4 : 2,
      gap: NizamioSpacing.gapMd,
      children: homeCoordinatorKpis(context, board: board),
    );
    const meetings = HomeUpcomingMeetings();
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, w) in [
            overview,
            ?quick,
            kpis,
            HomePendingWork(board: board, today: today),
            HomeTeamLoad(board: board),
            meetings,
          ].indexed) ...[if (i > 0) const Gap(NizamioSpacing.gapXl), w],
        ],
      );
    }
    // Yan yana iki öğe aynı yükseklikte (veri az/boş olsa da); kartlar `fill` ile uzar.
    Widget pair(Widget a, Widget b, {int flexA = 1, int flexB = 1}) =>
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: flexA, child: a),
              const Gap(homeWideGap),
              Expanded(flex: flexB, child: b),
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (quick case final q?)
          pair(overview, q, flexA: 5, flexB: 3)
        else
          overview,
        const Gap(NizamioSpacing.gapXl),
        kpis,
        const Gap(NizamioSpacing.gapXl),
        pair(
          HomePendingWork(board: board, today: today, fill: true),
          HomeTeamLoad(board: board, fill: true),
          flexA: 3,
          flexB: 2,
        ),
        const Gap(NizamioSpacing.gapXl),
        meetings,
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
