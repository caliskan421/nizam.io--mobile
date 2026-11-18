import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../notifications/notifications.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/current_account_controller.dart';
import 'crash_reports_card.dart';
import 'profile_identity.dart';
import 'profile_password_sheet.dart';
import 'profile_work.dart';
import 'sign_out_button.dart';

/// Kabuk içi profil: ortak üst çubuk, sabitlenen sekmeler ve korunan alt gezinme.
/// Kimlik, kapsamlı roller, görünür iş özeti ve kişisel tercihler aynı veri akışını kullanır.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hasProgram = ref.watch(scopeStateProvider).hasProgram;
    return NzPage.feed(
      topBar: const RootTopBar(),
      width: NzContentWidth.reading,
      pinned: NzPillTabs(
        tabs: [
          NzPillTab(label: l.uiIdentityProfileGeneral),
          NzPillTab(label: l.uiIdentityProfileWork),
          NzPillTab(label: l.uiUsersAccount),
        ],
        selected: _tab,
        onSelected: (tab) => setState(() => _tab = tab),
      ),
      afterKey: ValueKey(_tab),
      after: [
        const Gap(NizamioSpacing.space6),
        if (_tab == 0 && hasProgram)
          NzAsyncView(
            value: ref.watch(currentProgramControllerProvider),
            onRetry: () => ref.invalidate(currentProgramControllerProvider),
            skeletonOnReload: true,
            data: (program) => program == null
                ? const SizedBox.shrink()
                : NzAsyncView(
                    value: ref.watch(taskCatalogControllerProvider),
                    skeletonOnReload: true,
                    onRetry: () =>
                        ref.invalidate(taskCatalogControllerProvider),
                    data: (catalog) =>
                        ProfileMemberships(program: program, catalog: catalog),
                  ),
          ),
        if (_tab == 1 && hasProgram)
          NzAsyncView(
            value: ref.watch(taskCatalogControllerProvider),
            skeletonOnReload: true,
            onRetry: () => ref.invalidate(taskCatalogControllerProvider),
            data: (catalog) => ProfileWork(catalog: catalog),
          ),
        if (_tab == 2) ...[
          NzMenuGroup(
            rows: [
              NzMenuRow(
                icon: NzIcons.key,
                label: l.uiIdentityPasswordTitle,
                onTap: () => showProfilePasswordSheet(context),
              ),
            ],
          ),
          const Gap(NizamioSpacing.space6),
          const NotificationPreferencesCard(),
          const CrashReportsCard(),
          const SignOutButton(),
        ],
      ],
      children: [
        NzPageHeader(title: l.uiIdentityProfileTitle),
        const Gap(NizamioSpacing.space6),
        NzAsyncView(
          value: ref.watch(currentAccountControllerProvider),
          onRetry: () => ref.invalidate(currentAccountControllerProvider),
          data: (account) => ProfileIdentity(account: account),
        ),
        const Gap(NizamioSpacing.space6),
      ],
    );
  }
}
