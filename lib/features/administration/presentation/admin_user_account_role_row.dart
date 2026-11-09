import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';

class AdminUserAccountRoleRow extends StatelessWidget {
  const AdminUserAccountRoleRow({
    required this.label,
    required this.description,
    required this.dot,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final String description;
  final Color dot;
  final bool? selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: onTap != null,
      checked: selected,
      enabled: onTap != null,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 58),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.rowPad,
                vertical: NizamioSpacing.space2,
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dot,
                    ),
                  ),
                  const Gap(NizamioSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: context.text.bodyMd),
                        Text(
                          description,
                          style: context.text.caption.copyWith(
                            fontSize: 11.5,
                            color: c.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(NizamioSpacing.space3),
                  Container(
                    width: NizamioSpacing.space5,
                    height: NizamioSpacing.space5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected == true ? c.primary : c.surfaceOverlay,
                      border: selected == true
                          ? null
                          : Border.all(color: c.borderStrong),
                    ),
                    alignment: Alignment.center,
                    child: selected == null
                        ? Text(
                            '—',
                            style: context.text.caption.copyWith(
                              color: c.textMuted,
                            ),
                          )
                        : selected!
                        ? NzIcon(
                            NzIcons.check,
                            size: NizamioSize.iconSizeSm,
                            color: c.onPrimary,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
