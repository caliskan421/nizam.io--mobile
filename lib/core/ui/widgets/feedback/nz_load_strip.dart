import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../surfaces/nz_avatar.dart';
import 'nz_progress_bar.dart';

/// Ekip yükü satırı (prototip ana sayfa "Ekip yükü"): avatar, ad (+ [selfLabel] "sen"
/// etiketi), sağda mono özet ("3 açık · 1 geç"), altında kalın parçalı yük şeridi (devam,
/// onayda, geciken, iade). Satır kendi dolgusunu taşır ([NzTableCard] içinde ayraçlı durur).
/// [onTap] verilirse satır dokunulabilir.
class NzLoadRow extends StatelessWidget {
  const NzLoadRow({
    super.key,
    required this.name,
    required this.caption,
    required this.segments,
    this.captionDanger = false,
    this.selfLabel,
    this.onTap,
  });

  /// Kişi oturum sahibiyse adın yanındaki gri etiket ("sen"); değilse null.
  final String? selfLabel;

  final String name;
  final String caption;

  /// Sağdaki özet gecikme rengiyle.
  final bool captionDanger;
  final List<NzBarSegment> segments;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      container: true,
      button: onTap != null,
      label: '$name, $caption',
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space4,
            vertical: NizamioSpacing.space3,
          ),
          child: Row(
            children: [
              NzAvatar.initials(name: name),
              const Gap(NizamioSpacing.gapMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.bodyLg.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (selfLabel case final self?) ...[
                                const Gap(NizamioSpacing.space2),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: c.surfaceOverlay,
                                    borderRadius: BorderRadius.circular(
                                      NizamioRadius.bubbleTail,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: NizamioSpacing.space2,
                                      vertical: NizamioSpacing.space1 / 2,
                                    ),
                                    child: Text(
                                      self,
                                      style: t.monoSm.copyWith(
                                        color: c.textMuted,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Gap(NizamioSpacing.space2),
                        Text(
                          caption,
                          maxLines: 1,
                          style: t.mono.copyWith(
                            color: captionDanger ? c.danger : c.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const Gap(NizamioSpacing.space2),
                    NzProgressBar.segments(segments: segments),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
