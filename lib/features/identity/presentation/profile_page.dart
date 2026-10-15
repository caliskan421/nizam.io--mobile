import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/current_account_controller.dart';
import 'sign_out_button.dart';

/// Profil sekmesi: hesap e-postası (`GET /v1/me`) ve çıkış.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return NzPage(
      title: l.uiIdentityProfileTitle,
      width: NzContentWidth.reading,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space6),
        children: [
          NzAsyncView(
            value: ref.watch(currentAccountControllerProvider),
            onRetry: () => ref.invalidate(currentAccountControllerProvider),
            data: (account) => NzCard.outlined(
              child: MergeSemantics(
                child: Wrap(
                  spacing: NizamioSpacing.space2,
                  children: [
                    Text(
                      l.uiIdentityProfileEmail,
                      style: context.text.bodyMd.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
                    Text(account.email, style: context.text.labelLg),
                  ],
                ),
              ),
            ),
          ),
          const Gap(NizamioSpacing.space6),
          const SignOutButton(),
        ],
      ),
    );
  }
}
