import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_avatar.dart';
import '../../tasks/tasks.dart';
import 'admin_user_identity.dart';

class AdminUserHero extends StatelessWidget {
  const AdminUserHero({
    super.key,
    required this.identity,
    required this.catalog,
    required this.programId,
    required this.nameKey,
    this.email,
  });
  final AdminUserIdentity identity;
  final String? email;
  final TaskCatalog catalog;
  final String? programId;
  final GlobalKey nameKey;
  static const _heroGap = 16.0;
  static const _badgeGap = 6.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = identity.user;
    final names = identity.departmentNames(catalog, programId);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NzAvatar.initials(
          name: user.fullName,
          extent: NzAvatarSize.profile,
          fillColor: identity.fill(context),
          foregroundColor: identity.ink(context),
        ),
        const Gap(_heroGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  user.fullName,
                  key: nameKey,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMd.copyWith(
                    letterSpacing: -0.015 * NizamioTypography.h1Detail.size,
                  ),
                ),
              ),
              if (email != null && email!.isNotEmpty) ...[
                const Gap(NizamioSpacing.space1 / 2),
                Text(
                  email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.caption.copyWith(
                    fontSize: 12.5,
                    height: 17 / 12.5,
                    color: context.colors.textMuted,
                  ),
                ),
              ],
              const Gap(_badgeGap),
              LayoutBuilder(
                builder: (context, constraints) => Wrap(
                  spacing: _badgeGap,
                  runSpacing: _badgeGap,
                  children: [
                    if (identity.companyAdmin)
                      _IdentityBadge(
                        label: l.uiUsersAdmin,
                        dot: context.colors.roleAdmin,
                        maxWidth: constraints.maxWidth,
                      ),
                    if (identity.coordinator)
                      _IdentityBadge(
                        label: l.uiUsersCoordinator,
                        dot: context.colors.avatar1,
                        maxWidth: constraints.maxWidth,
                      ),
                    if (identity.member)
                      _IdentityBadge(
                        label: l.uiUsersMember,
                        dot: context.colors.roleMember,
                        maxWidth: constraints.maxWidth,
                      ),
                    _IdentityBadge(
                      label: names.isEmpty
                          ? l.uiUsersUnassigned
                          : names.join(', '),
                      icon: NzIcons.coordinatorships,
                      maxWidth: constraints.maxWidth,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IdentityBadge extends StatelessWidget {
  const _IdentityBadge({
    required this.label,
    this.dot,
    this.icon,
    required this.maxWidth,
  });
  final String label;
  final Color? dot;
  final IconData? icon;
  final double maxWidth;
  static const _labelSize = 11.5;
  static const _dotSize = 7.0;
  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(maxWidth: maxWidth),
    padding: const EdgeInsets.symmetric(
      horizontal: NizamioSpacing.space2 + NizamioSize.borderWidth,
      vertical: NizamioSpacing.space1,
    ),
    decoration: BoxDecoration(
      color: context.colors.surfaceRaised,
      borderRadius: BorderRadius.circular(NizamioRadius.pill),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot != null)
          ExcludeSemantics(
            child: Container(
              width: _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
          ),
        if (icon != null)
          NzIcon(
            icon,
            size: NizamioSpacing.space3,
            color: context.colors.textMuted,
          ),
        const Gap(6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.caption.copyWith(
              fontSize: _labelSize,
              height: 16 / _labelSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
