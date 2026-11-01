import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/widgets/feedback/nz_skeleton.dart';

/// Ana sayfa özetinin ilk yükleme iskeleti: gerçek akışın düzenine benzer (karşılama: tarih +
/// iki satır ad, 2×2 özet kutuları, hızlı işlemler başlığı + 4 kutucuk, iki kart). Tek
/// [NzShimmer] kapsamında aynı bantla parlar. Ölçüler yaklaşıktır (veri gelince içerik yerine
/// oturur); test edilmez.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  static const _kickerWidth = 0.4;
  static const _nameWidth = 0.55;
  static const _kpiHeight = 128.0;
  static const _actionHeight = 76.0;
  static const _historyHeight = 120.0;
  static const _coordHeight = 168.0;

  @override
  Widget build(BuildContext context) {
    Widget row(int n, double height, double gap, double radius) => Row(
      spacing: gap,
      children: [
        for (var i = 0; i < n; i++)
          Expanded(
            child: NzSkeleton.block(height: height, radius: radius),
          ),
      ],
    );
    Widget fraction(double f, double height) => FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: f,
      child: NzSkeleton.block(height: height, radius: NizamioRadius.pill),
    );
    return NzShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          fraction(_kickerWidth, NizamioSpacing.space3),
          const Gap(NizamioSpacing.space3),
          fraction(_nameWidth, NizamioSpacing.space8),
          const Gap(NizamioSpacing.space2),
          fraction(_nameWidth + 0.15, NizamioSpacing.space8),
          const Gap(NizamioSpacing.gapXl),
          row(2, _kpiHeight, NizamioSpacing.gapMd, NizamioRadius.card),
          const Gap(NizamioSpacing.gapMd),
          row(2, _kpiHeight, NizamioSpacing.gapMd, NizamioRadius.card),
          const Gap(NizamioSpacing.gapXl),
          fraction(_kickerWidth * 0.75, NizamioSpacing.space3),
          const Gap(NizamioSpacing.gapMd),
          row(4, _actionHeight, NizamioSpacing.space2, NizamioRadius.tile),
          const Gap(NizamioSpacing.gapXl),
          const NzSkeleton.block(
            height: _historyHeight,
            radius: NizamioRadius.card,
          ),
          const Gap(NizamioSpacing.gapXl),
          const NzSkeleton.block(
            height: _coordHeight,
            radius: NizamioRadius.card,
          ),
        ],
      ),
    );
  }
}
