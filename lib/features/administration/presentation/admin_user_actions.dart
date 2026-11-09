import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../scope/scope.dart';
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
      children: [
        TextButton(
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
          child: const Text('Kullanıcıyı düzenle'),
        ),
        TextButton(
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
          child: const Text('Hesabı düzenle'),
        ),
        TextButton(
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
          child: const Text('Parolayı sıfırla'),
        ),
        TextButton(
          onPressed: () => run(
            () => command.run((o, p) async {
              await o.unlockAccount(user.accountId);
            }),
          ),
          child: const Text('Kilidi kaldır'),
        ),
        TextButton(
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
          child: const Text('Kullanıcıyı sil'),
        ),
        TextButton(
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
          child: const Text('Hesabı sil'),
        ),
      ],
    );
  }
}

class AdminCreateUser extends ConsumerWidget {
  const AdminCreateUser({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
    onPressed: () async {
      final catalog = ref.read(taskCatalogControllerProvider).value;
      final program = ref.read(currentProgramControllerProvider).value;
      final session = ref.read(sessionGenerationProvider);
      final scope = ref.read(scopeStateProvider);
      if (catalog == null || program == null) {
        return;
      }
      final department = await showDialog<String>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Koordinatörlük seç'),
          children: [
            for (final d in catalog.coordinatorships)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, d.code),
                child: Text(d.name),
              ),
          ],
        ),
      );
      if (department == null ||
          !context.mounted ||
          session != ref.read(sessionGenerationProvider) ||
          scope != ref.read(scopeStateProvider)) {
        return;
      }
      final values = await adminForm(context, 'Kullanıcı oluştur', [
        (label: 'Ad soyad', initial: '', secret: false, required: true),
        (label: 'E-posta', initial: '', secret: false, required: true),
      ]);
      if (values == null || !context.mounted) {
        return;
      }
      try {
        await ref.read(adminCommandProvider.notifier).run((o, p) async {
          await o.createUser(
            email: values[1],
            fullName: values[0],
            programId: program.id,
            departmentId: department,
            role: DepartmentRole.member,
          );
        });
        if (context.mounted) {
          NzToast.show(context, 'Kullanıcı oluşturuldu.');
        }
      } on Object catch (e) {
        if (context.mounted) {
          NzToast.error(context, toApiError(e));
        }
      }
    },
    child: const Text('Koordinatörlüğe kullanıcı oluştur'),
  );
}
