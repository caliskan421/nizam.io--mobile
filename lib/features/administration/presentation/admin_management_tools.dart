import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../application/admin_controller.dart';
import 'admin_forms.dart';
import 'admin_program_actions.dart';
import 'admin_transfer_panel.dart';
import 'admin_user_actions.dart';

class AdminManagementTools extends ConsumerWidget {
  const AdminManagementTools({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final command = ref.read(adminCommandProvider.notifier);
    Future<void> run(Future<void> Function() call) async {
      try {
        await call();
        if (context.mounted) {
          NzToast.show(context, 'İşlem tamamlandı.');
        }
      } on Object catch (e, st) {
        // Rapor, bağlam korumasından ÖNCE.
        final api = toReportedApiError(
          e,
          st,
          source: ReportSource.administration,
        );
        if (context.mounted) NzToast.error(context, api);
      }
    }

    return Column(
      children: [
        const AdminProgramActions(),
        const AdminTransferPanel(),
        const AdminCreateUser(),
        TextButton(
          onPressed: () async {
            final values = await adminForm(context, 'Hesap aç', [
              (label: 'Ad soyad', initial: '', secret: false, required: true),
              (label: 'E-posta', initial: '', secret: false, required: true),
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
        TextButton(
          onPressed: context.appNav.openDeletedTasks,
          child: const Text('Silinenler'),
        ),
      ],
    );
  }
}
