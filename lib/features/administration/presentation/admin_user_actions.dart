import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_button.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/organization_admin.dart';
import 'admin_forms.dart';

class AdminUserActions extends ConsumerWidget {
  const AdminUserActions({super.key, required this.user});
  final KnownUser user;
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
    return Wrap(
      spacing: NizamioSpacing.space2,
      runSpacing: NizamioSpacing.space2,
      children: [
        NzButton.secondary(
          label: 'Kullanıcıyı düzenle',
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
        NzButton.secondary(
          label: 'Hesabı düzenle',
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
        NzButton.secondary(
          label: 'Parolayı sıfırla',
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
        NzButton.secondary(
          label: 'Kilidi kaldır',
          onPressed: () => run(
            () => command.run((o, p) async {
              await o.unlockAccount(user.accountId);
            }),
          ),
        ),
        NzButton.danger(
          label: 'Kullanıcıyı sil',
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
        NzButton.danger(
          label: 'Hesabı sil',
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
      ],
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
  await showInviteSheet(context);
  if (!context.mounted ||
      session != ref.read(sessionGenerationProvider) ||
      scope != ref.read(scopeStateProvider)) {
    return;
  }
  ref.invalidate(adminUsersProvider);
  ref.invalidate(adminUserProfileProvider);
}
