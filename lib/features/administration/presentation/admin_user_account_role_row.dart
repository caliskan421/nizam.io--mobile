import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';

class AdminUserAccountRoleChoice extends StatelessWidget {
  const AdminUserAccountRoleChoice({
    super.key,
    required this.label,
    required this.dot,
    required this.selected,
    required this.onTap,
    required this.hint,
  });
  final String label;
  final Color dot;
  final bool? selected;
  final VoidCallback? onTap;
  final String hint;
  static const _height = 46.0;
  static const _radius = 16.0;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: hint,
      child: Semantics(
        button: true,
        selected: selected == true,
        enabled: onTap != null,
        hint: hint,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: selected == true ? c.surfaceOverlay : c.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
                side: BorderSide(
                  color: selected == true ? c.textMuted : c.border,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: _height),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NizamioSpacing.space2,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dot,
                            ),
                          ),
                          const Gap(7),
                          Flexible(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.labelMd.copyWith(
                                color: onTap == null ? c.textMuted : c.text,
                              ),
                            ),
                          ),
                          if (selected == null) ...[
                            const Gap(NizamioSpacing.space1),
                            Text(
                              '—',
                              style: context.text.caption.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (selected == true)
              Positioned(
                top: -5,
                right: -5,
                child: ExcludeSemantics(
                  child: Container(
                    width: NizamioSpacing.space5,
                    height: NizamioSpacing.space5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.primary,
                    ),
                    alignment: Alignment.center,
                    child: NzIcon(
                      NzIcons.check,
                      size: NizamioSize.iconSizeSm,
                      color: c.onPrimary,
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
