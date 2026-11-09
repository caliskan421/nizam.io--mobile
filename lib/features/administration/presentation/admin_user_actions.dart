import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_button.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/lists/nz_list_tile.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../../../core/ui/widgets/surfaces/nz_card.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/organization_admin.dart';
import 'admin_forms.dart';

class AdminUserActions extends ConsumerWidget {
  const AdminUserActions({super.key, required this.user, this.grouped = false});
  final KnownUser user;
  final bool grouped;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> run(Future<void> Function() call) async {
      try {
        await call();
        if (context.mounted) {
          NzToast.show(context, 'İşlem tamamlandı.');
        }
      } on Object catch (e) {
        if (context.mounted) {
          NzToast.error(context, toApiError(e));
        }
      }
    }

    final command = ref.read(adminCommandProvider.notifier);
    Widget action({
      required String label,
      required VoidCallback onPressed,
      required IconData icon,
      bool danger = false,
    }) {
      if (grouped) {
        final leading = NzIcon(
          icon,
          size: NizamioSize.iconSizeSm,
          color: danger ? context.colors.danger : context.colors.textMuted,
        );
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 58),
          child: danger
              ? NzListTile.danger(
                  title: label,
                  leading: leading,
                  onTap: onPressed,
                  size: NzSize.sm,
                )
              : NzListTile(
                  title: label,
                  leading: leading,
                  onTap: onPressed,
                  size: NzSize.sm,
                ),
        );
      }
      return danger
          ? NzButton.danger(label: label, icon: icon, onPressed: onPressed)
          : NzButton.secondary(label: label, icon: icon, onPressed: onPressed);
    }

    final actions = <Widget>[
      action(
        label: 'Kullanıcıyı düzenle',
        icon: NzIcons.edit,
        onPressed: () async {
          final values = await adminForm(context, 'Kullanıcı bilgileri', [
            (
              label: 'Ad soyad',
              initial: user.fullName,
              secret: false,
              required: true,
            ),
            (
              label: 'Yeni e-posta (isteğe bağlı)',
              initial: '',
              secret: false,
              required: false,
            ),
          ]);
          if (values != null && context.mounted) {
            await run(
              () => command.run((o, p) async {
                await o.updateUser(
                  user.accountId,
                  fullName: values[0],
                  email: values[1].isEmpty ? null : values[1],
                );
              }),
            );
          }
        },
      ),
      action(
        label: 'Hesabı düzenle',
        icon: NzIcons.edit,
        onPressed: () async {
          final values = await adminForm(context, 'Hesap bilgileri', [
            (
              label: 'Ad soyad',
              initial: user.fullName,
              secret: false,
              required: true,
            ),
            (
              label: 'Yeni e-posta (isteğe bağlı)',
              initial: '',
              secret: false,
              required: false,
            ),
            (
              label: 'Yeni parola (isteğe bağlı)',
              initial: '',
              secret: true,
              required: false,
            ),
          ]);
          if (values != null && context.mounted) {
            await run(
              () => command.run((o, p) async {
                await o.updateAccount(
                  user.accountId,
                  fullName: values[0],
                  email: values[1].isEmpty ? null : values[1],
                  password: values[2].isEmpty ? null : values[2],
                );
              }),
            );
          }
        },
      ),
      action(
        label: 'Parolayı sıfırla',
        icon: NzIcons.mail,
        onPressed: () async {
          if (await adminConfirm(
            context,
            'Parolayı sıfırla',
            '${user.fullName} için parola sıfırlansın mı?',
          )) {
            await run(
              () => command.run((o, p) async {
                await o.updateUser(
                  user.accountId,
                  resetPassword: true,
                  forcePasswordChange: true,
                );
              }),
            );
          }
        },
      ),
      action(
        label: 'Kilidi kaldır',
        icon: NzIcons.checkCircle,
        onPressed: () => run(
          () => command.run((o, p) async {
            await o.unlockAccount(user.accountId);
          }),
        ),
      ),
      action(
        danger: true,
        label: 'Kullanıcıyı sil',
        icon: NzIcons.delete,
        onPressed: () async {
          if (await adminConfirm(
            context,
            'Kullanıcıyı sil',
            '${user.fullName} silinmiş kayıtlara taşınacak.',
          )) {
            await run(
              () => command.run((o, p) async {
                await o.deleteUser(user.accountId);
              }),
            );
          }
        },
      ),
      action(
        danger: true,
        label: 'Hesabı sil',
        icon: NzIcons.delete,
        onPressed: () async {
          if (await adminConfirm(
            context,
            'Hesabı sil',
            '${user.fullName} hesabı silinecek ve oturumları kapatılacak.',
          )) {
            await run(
              () => command.run((o, p) async {
                await o.deleteAccount(user.accountId);
              }),
            );
          }
        },
      ),
    ];
    if (!grouped) {
      return Wrap(
        spacing: NizamioSpacing.space2,
        runSpacing: NizamioSpacing.space2,
        children: actions,
      );
    }
    return NzCard.outlined(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0)
              Divider(
                height: NizamioSize.borderWidth,
                thickness: NizamioSize.borderWidth,
                indent: NizamioSpacing.space4,
                color: context.colors.border,
              ),
            actions[i],
          ],
        ],
      ),
    );
  }
}

class AdminCreateUser extends ConsumerWidget {
  const AdminCreateUser({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
    onPressed: () => showAdminCreateUser(context, ref),
    child: Text(context.l10n.uiUsersAdd),
  );
}

Future<void> showAdminCreateUser(BuildContext context, WidgetRef ref) async {
  final session = ref.read(sessionGenerationProvider);
  final scope = ref.read(scopeStateProvider);
  final changed = await showInviteSheet(context);
  if (!changed) return;
  if (!context.mounted ||
      session != ref.read(sessionGenerationProvider) ||
      scope != ref.read(scopeStateProvider)) {
    return;
  }
  ref.read(adminUsersProvider.notifier).invalidate();
  ref.invalidate(adminUserProfileProvider);
}
