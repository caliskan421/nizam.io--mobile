import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/providers.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/layout/nz_pane.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../domain/home_dashboard.dart';
import '../../domain/module_menu.dart';
import '../../domain/program.dart';
import 'home_drawer_header.dart';
import 'home_sections.dart';
import 'module_menu_texts.dart';
import 'scope_switcher.dart';

// Tablet çekmecesi iç dolgusu (kaynak `aside`): üst 52, alt 28.
const _tabletTop = 52.0;
const _tabletBottom = 28.0;

/// Alt menüde "Ana sayfa"ya yeniden dokununca açılan kısayol menüsü: yalnız hızlı işlemler
/// (işlem geçmişi de hızlı işlemdir).
Future<void> showHomeShortcuts(
  BuildContext context, {
  required ValueChanged<HomeQuickAction> onQuickAction,
  required List<HomeQuickAction> actions,
}) {
  final l = context.l10n;
  return NzFlyoutMenu.show(
    context,
    semanticLabel: l.uiHomeShortcuts,
    entries: [
      NzFlyoutSection(l.uiHomeQuickActions),
      for (final a in actions)
        NzFlyoutItem(
          label: quickActionLongLabel(l, a),
          icon: quickActionIcon(a),
          onSelected: () => onQuickAction(a),
        ),
    ],
  );
}

/// Sağdan açılan uygulama çekmecesi: hesap, üçlü seçici (program × rol × koordinatörlük,
/// [ScopeSwitcher]), etkin rolün modülleri ([modulesFor]; tek tanım), çıkış. Kök sayfaların
/// menü dairesinden (`NzAppNav.openMenu`) açılır; [current] bulunulan modül. Rol ya da
/// koordinatörlük değişince çekmece kapanır ve [onViewChanged] yeni görünüm başlığıyla çağrılır.
Future<void> showHomeDrawer(
  BuildContext context, {
  required HomeModule? current,
  required String greetingName,
  required String? programName,
  required ModuleCounts? counts,
  TeamRole? greetingRole,
  String? greetingEmail,
  String? programShortName,
  ProgramColor? programColor,
  String? version,
  String? productName,
  required ValueChanged<HomeModule> onModule,
  required VoidCallback onProfile,
  required VoidCallback onChangeScope,
  required ValueChanged<String> onViewChanged,
  required VoidCallback onSignOut,
}) {
  final l = context.l10n;
  return NzSideSheet.show<void>(
    context,
    semanticLabel: l.uiHomeMenu,
    builder: (sheet) => Consumer(
      builder: (sheet, ref, _) {
        final c = sheet.colors;
        final view = ref.watch(effectiveAccessProvider);
        final role = view.known ? view.role : null;
        // Başlık: "Rol · Koordinatörlük"; erişim bilinmiyorsa eski "Admin · e-posta".
        final legacyRole = switch (greetingRole) {
          TeamRole.admin => l.uiHomeRoleAdmin,
          TeamRole.coordinator => l.uiHomeRoleCoordinator,
          TeamRole.member => l.uiHomeRoleMember,
          null => null,
        };
        final accountCaption = view.known
            ? l.viewCaption(view)
            : [?legacyRole, ?greetingEmail].join(' · ');
        void close(VoidCallback then) {
          Navigator.of(sheet).pop();
          then();
        }

        Widget? trailing(HomeModule m) => switch (m) {
          HomeModule.tasks when counts != null => Row(
            mainAxisSize: MainAxisSize.min,
            spacing: NizamioSpacing.space1,
            children: [
              NzCountPill.warning(counts.tasksAwaitingApproval),
              NzCountPill.danger(counts.lateTasks),
            ],
          ),
          HomeModule.messages => switch (counts?.unreadMessages) {
            final n? => NzCountPill.neutral(n),
            null => null,
          },
          HomeModule.simulation => NzBadge.neutral(
            label: l.uiHomeBeta,
            size: NzSize.sm,
          ),
          _ => null,
        };

        // Tablet (kaynak `aside` `padding: 52px 14px 28px`; durum çubuğu payı dahil 52).
        final tablet = NzTabletMetrics.tabletVisualAt(
          MediaQuery.sizeOf(context).width,
        );
        // Çekmece güvenli alanı tüketmez: liste durum çubuğunun altına kadar kayar, açılışta
        // içerik güvenli alanın altında başlar.
        final safe = MediaQuery.paddingOf(sheet);
        final groups = modulesFor(role);
        return ListView(
          padding: EdgeInsets.fromLTRB(
            NizamioSpacing.rowPad,
            safe.top +
                (tablet
                    ? math.max(NizamioSpacing.space4, _tabletTop - safe.top)
                    : NizamioSpacing.space4),
            NizamioSpacing.rowPad,
            safe.bottom + (tablet ? _tabletBottom : NizamioSpacing.space6),
          ),
          children: [
            HomeDrawerHeader(
              name: greetingName,
              caption: accountCaption,
              tablet: tablet,
              onProfile: () => close(onProfile),
              onClose: () => Navigator.of(sheet).pop(),
            ),
            const Gap(NizamioSpacing.gapLg),
            ScopeSwitcher(
              programName: programName ?? l.uiScopeHomeChange,
              programShortName: programShortName,
              programColor: programColor,
              onChangeScope: () => close(onChangeScope),
              onViewChanged: (caption) => close(() => onViewChanged(caption)),
            ),
            for (final g in groups) ...[
              Gap(
                g.kind == ModuleGroupKind.footer
                    ? NizamioSpacing.gapLg
                    : g == groups.first
                    ? NizamioSpacing.gapLg
                    : NizamioSpacing.space4,
              ),
              NzMenuGroup(
                label: l.moduleGroupLabel(g.kind),
                rows: [
                  for (final m in g.modules)
                    NzMenuRow(
                      icon: homeModuleIcon(m),
                      label: l.homeModuleLabel(m, role),
                      current: m == current,
                      trailing: trailing(m),
                      onTap: () => close(() => onModule(m)),
                    ),
                  if (g.kind == ModuleGroupKind.footer)
                    NzMenuRow(
                      icon: NzIcons.logout,
                      label: l.uiIdentitySignOut,
                      danger: true,
                      onTap: () => close(onSignOut),
                    ),
                ],
              ),
            ],
            const Gap(NizamioSpacing.gapLg),
            const _AppearanceSwitch(),
            if (version != null) ...[
              const Gap(NizamioSpacing.gapLg),
              Text(
                '${productName ?? l.uiHomeAppName} ${l.uiHomeVersionPrefix}$version',
                textAlign: TextAlign.center,
                style: sheet.text.monoSm.copyWith(color: c.textFaint),
              ),
            ],
          ],
        );
      },
    ),
  );
}

/// Çekmece altındaki görünüm seçici: Koyu / Açık / Sistem; seçim kalıcı tema modudur.
class _AppearanceSwitch extends ConsumerWidget {
  const _AppearanceSwitch();

  static const _modes = [ThemeMode.dark, ThemeMode.light, ThemeMode.system];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space3,
          ),
          child: Semantics(
            header: true,
            child: Text(
              l.uiHomeAppearance,
              style: context.text.monoSm.copyWith(
                color: context.colors.textMuted,
              ),
            ),
          ),
        ),
        const Gap(NizamioSpacing.space1),
        NzPillTabs(
          semanticLabel: l.uiHomeAppearance,
          tabs: [
            NzPillTab(label: l.uiHomeThemeDark, icon: NzIcons.darkMode),
            NzPillTab(label: l.uiHomeThemeLight, icon: NzIcons.lightMode),
            NzPillTab(label: l.uiHomeThemeSystem, icon: NzIcons.desktop),
          ],
          selected: _modes.indexOf(ref.watch(themeModeProvider)),
          onSelected: (i) =>
              ref.read(themeModeControllerProvider).set(_modes[i]),
        ),
      ],
    );
  }
}
