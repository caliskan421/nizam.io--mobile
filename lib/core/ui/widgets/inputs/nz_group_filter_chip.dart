import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';

/// Bir filtre türünü düzenleme ve tüm seçimlerini kaldırma hedefleri.
class NzGroupFilterChip extends StatelessWidget {
  const NzGroupFilterChip({
    super.key,
    this.label,
    required this.value,
    required this.editLabel,
    required this.removeLabel,
    required this.onEdit,
    required this.onRemove,
  });
  final String? label;
  final String value;
  final String editLabel;
  final String removeLabel;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = context.text.caption.copyWith(fontSize: 12, height: 14 / 12);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: NzMotion.of(context, const Duration(milliseconds: 350)),
      curve: const Cubic(.22, 1, .36, 1),
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.scale(scale: .94 + .06 * v, child: child),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              button: true,
              label: editLabel,
              onTap: onEdit,
              excludeSemantics: true,
              child: InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(9999),
                child: SizedBox(
                  height: 24,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (label != null) ...[
                          Text(
                            label!,
                            style: style.copyWith(color: c.textFaint),
                          ),
                          const Gap(4),
                        ],
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 150),
                          child: Text(
                            value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: style.copyWith(color: c.text),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Semantics(
              button: true,
              label: removeLabel,
              onTap: onRemove,
              excludeSemantics: true,
              child: InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(9999),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: NzIcon(NzIcons.close, size: 12, color: c.textFaint),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
