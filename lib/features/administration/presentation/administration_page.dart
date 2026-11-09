import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../application/admin_controller.dart';
import 'admin_deleted_records.dart';
import 'admin_forms.dart';
import 'admin_program_actions.dart';
import 'admin_transfer_panel.dart';
import 'admin_user_actions.dart';

class AdministrationPage extends ConsumerWidget {
  const AdministrationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final command = ref.read(adminCommandProvider.notifier);
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

    return NzPage(
      title: 'Yönetim',
      loading: ref.watch(adminCommandProvider),
      body: NzAsyncView(
        value: ref.watch(adminUsersProvider),
        skeletonOnReload: true,
        onRetry: () => ref.invalidate(adminUsersProvider),
        data: (users) => ListView(
          children: [
            const AdminProgramActions(),
            const AdminTransferPanel(),
            const AdminCreateUser(),
            TextButton(
              onPressed: () async {
                final values = await adminForm(context, 'Hesap aç', [
                  (
                    label: 'Ad soyad',
                    initial: '',
                    secret: false,
                    required: true,
                  ),
                  (
                    label: 'E-posta',
                    initial: '',
                    secret: false,
                    required: true,
                  ),
                  (
                    label: 'Geçici parola (ilk girişte değiştirilir)',
                    initial: '',
                    secret: true,
                    required: true,
                  ),
                ]);
                if (values == null || !context.mounted) {
                  return;
                }
                await run(
                  () => command.run((o, p) async {
                    await o.openAccount(
                      fullName: values[0],
                      email: values[1],
                      password: values[2],
                      forcePasswordChange: true,
                    );
                  }),
                );
              },
              child: const Text('Hesap aç'),
            ),
            TextButton(
              onPressed: () async {
                if (await adminConfirm(
                  context,
                  'Giriş kilitlerini sıfırla',
                  'Bütün hesapların giriş kilitleri kaldırılacak.',
                )) {
                  await run(
                    () => command.run((o, p) async {
                      await o.resetLockouts();
                    }),
                  );
                }
              },
              child: const Text('Bütün giriş kilitlerini kaldır'),
            ),
            if (users.items.isEmpty) const Text('Kullanıcı bulunamadı.'),
            for (final user in users.items)
              ExpansionTile(
                title: Text(user.fullName),
                subtitle: Text(user.memberships.join(' · ')),
                children: [AdminUserActions(user: user)],
              ),
            if (users.nextCursor != null)
              TextButton(
                onPressed: () =>
                    run(() => ref.read(adminUsersProvider.notifier).loadMore()),
                child: const Text('Daha fazla göster'),
              ),
            const AdminDeletedRecords(),
          ],
        ),
      ),
    );
  }
}
