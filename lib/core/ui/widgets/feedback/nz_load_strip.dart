import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';
import '../surfaces/nz_avatar.dart';
import 'nz_progress_bar.dart';

/// Ekip yükü satırı (prototip ana sayfa "Ekip yükü"): avatar, ad, sağda özet ("3 açık · 1
/// geç"), altında parçalı yük şeridi (devam, onayda, geciken, iade). [onTap] verilirse satır
/// dokunulabilir.
class NzLoadRow extends StatelessWidget {
  const NzLoadRow({
    super.key,
    required this.name,
    required this.caption,
    required this.segments,
    this.captionDanger = false,
    this.onTap,
  });

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
          padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space2),
          child: Row(
            children: [
              NzAvatar.initials(
                name: name,
                size: NzSize.sm,
                tone: NzAvatar.toneOf(name),
              ),
              const Gap(NizamioSpacing.gapMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.bodySm.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Gap(NizamioSpacing.space2),
                        Text(
                          caption,
                          style: t.caption.copyWith(
                            color: captionDanger ? c.danger : c.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const Gap(NizamioSpacing.space1),
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
