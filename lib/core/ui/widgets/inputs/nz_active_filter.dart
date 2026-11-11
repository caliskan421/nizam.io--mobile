import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';

/// Etkin filtre ve erişilebilir tekil kaldırma hedefi.
class NzActiveFilter extends StatelessWidget {
  const NzActiveFilter({
    super.key,
    required this.label,
    required this.removeLabel,
    required this.onRemove,
  });
  final String label;
  final String removeLabel;
  final VoidCallback onRemove;
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.sizeOf(context).width - NizamioSpacing.space8,
    ),
    child: Semantics(
      button: true,
      label: removeLabel,
      excludeSemantics: true,
      onTap: onRemove,
      child: InkWell(
        onTap: onRemove,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.border),
            borderRadius: BorderRadius.circular(NizamioRadius.tile),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(NizamioSpacing.space2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.caption,
                ),
              ),
              SizedBox(
                width: NizamioSize.tap,
                height: NizamioSize.tap,
                child: Center(
                  child: NzIcon(
                    NzIcons.close,
                    size: NizamioSize.iconSizeSm,
                    color: context.colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
