import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_avatar.dart';

/// One lazy row of the reference's single grouped surface. Adjacent rows share
/// side borders; only the first/last draw the outer rounding.
class AdminUserListRow extends StatelessWidget {
  const AdminUserListRow({
    super.key,
    required this.name,
    required this.roles,
    required this.departments,
    required this.avatarColor,
    required this.avatarForeground,
    required this.first,
    required this.last,
    required this.onOpen,
    required this.onQuick,
  });
  final String name;
  final String roles;
  final String departments;
  final Color avatarColor;
  final Color avatarForeground;
  final bool first;
  final bool last;
  final VoidCallback onOpen;
  final VoidCallback onQuick;

  // Original .us-row/.us-av/.cd-rsub dimensions, in logical CSS px.
  static const _rowHeight = 66.0;
  static const _nameSize = 14.0;
  static const _nameHeight = 19.0;
  static const _subtitleSize = 12.5;
  static const _subtitleHeight = 17.0;
  static const _gap = 12.0;
  static const _radius = 20.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.vertical(
      top: first ? const Radius.circular(_radius) : Radius.zero,
      bottom: last ? const Radius.circular(_radius) : Radius.zero,
    );
    return Semantics(
      button: true,
      excludeSemantics: true,
      onTap: onOpen,
      onLongPress: onQuick,
      label: '$name, $roles, $departments',
      hint: context.l10n.uiUsersRowHint,
      customSemanticsActions: {
        CustomSemanticsAction(label: context.l10n.uiUsersQuickActions): onQuick,
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: radius,
          border: Border.all(color: c.border),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: NizamioSize.borderWidth,
            right: NizamioSize.borderWidth,
            top: first ? NizamioSize.borderWidth : 0,
            bottom: last ? NizamioSize.borderWidth : 0,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onOpen,
                onLongPress: onQuick,
                onSecondaryTap: onQuick,
                splashFactory: NoSplash.splashFactory,
                child: Stack(
                  children: [
                    if (!first)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: NizamioSize.borderWidth,
                        child: ColoredBox(color: c.surface),
                      ),
                    if (!last)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: NizamioSize.borderWidth,
                        child: ColoredBox(color: c.surface),
                      ),
                    if (!first)
                      Positioned(
                        top: 0,
                        left: NizamioSpacing.space4,
                        right: 0,
                        child: Divider(
                          height: NizamioSize.borderWidth,
                          thickness: NizamioSize.borderWidth,
                          color: c.border,
                        ),
                      ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: _rowHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: NizamioSpacing.space4,
                          vertical: NizamioSpacing.gapMd,
                        ),
                        child: Row(
                          children: [
                            NzAvatar.initials(
                              name: name,
                              extent: NzAvatarSize.list,
                              fillColor: avatarColor,
                              foregroundColor: avatarForeground,
                            ),
                            const Gap(_gap),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.text.bodyMd.copyWith(
                                      fontSize: _nameSize,
                                      height: _nameHeight / _nameSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Gap(NizamioSpacing.space1 / 2),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: roles,
                                          style: context.text.caption.copyWith(
                                            fontSize: _subtitleSize,
                                            height:
                                                _subtitleHeight / _subtitleSize,
                                            color: c.text,
                                          ),
                                        ),
                                        TextSpan(
                                          text: departments.isEmpty
                                              ? ''
                                              : ' · $departments',
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.text.caption.copyWith(
                                      fontSize: _subtitleSize,
                                      height: _subtitleHeight / _subtitleSize,
                                      color: c.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(_gap),
                            NzIcon(
                              NzIcons.chevronRight,
                              size: NizamioSize.iconSizeSm,
                              color: c.textFaint,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
