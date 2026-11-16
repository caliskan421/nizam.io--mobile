import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../domain/current_account.dart';

class ProfileIdentity extends StatelessWidget {
  const ProfileIdentity({super.key, required this.account});
  final CurrentAccount account;

  @override
  Widget build(BuildContext context) => NzCard.outlined(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            NzAvatar.initials(
              name: account.fullName,
              extent: NzAvatarSize.profile,
              tone: NzAvatar.toneOf(account.fullName),
            ),
            const Gap(NizamioSpacing.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(account.fullName, style: context.text.titleMd),
                  ),
                  if (account.companyAdmin) ...[
                    const Gap(NizamioSpacing.space2),
                    NzBadge.neutral(label: context.l10n.uiUsersAdmin),
                  ],
                ],
              ),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        Text(
          context.l10n.uiIdentityProfileEmail,
          style: context.text.caption.copyWith(color: context.colors.textMuted),
        ),
        const Gap(NizamioSpacing.space1),
        Text(account.email, style: context.text.bodyMd),
      ],
    ),
  );
}

/// Her ekip satırında rol ile koordinatörlük birlikte kalır; global rol tahmini yoktur.
class ProfileMemberships extends StatelessWidget {
  const ProfileMemberships({
    super.key,
    required this.program,
    required this.catalog,
  });
  final Program program;
  final TaskCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final seats = catalog.access?.seatsIn(program.id) ?? const <TeamSeat>[];
    return NzSection(
      title: l.uiUsersMemberships,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(program.name, style: context.text.labelLg),
          const Gap(NizamioSpacing.space1),
          Text(
            l.uiIdentityProfileRolesIntro,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
          const Gap(NizamioSpacing.space4),
          NzMenuGroup(
            rows: [
              if (seats.isEmpty)
                NzListTile(
                  title: catalog.access == null
                      ? l.uiUsersMembershipUnknown
                      : l.uiIdentityProfileNoMemberships,
                ),
              for (final seat in seats)
                NzListTile(
                  title: seat.departmentName,
                  subtitle: switch (seat.role) {
                    SeatRole.coordinator => l.uiUsersCoordinator,
                    SeatRole.member => l.uiUsersMember,
                    SeatRole.unknown => l.uiUsersMembershipUnknown,
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
