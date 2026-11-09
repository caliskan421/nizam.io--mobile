import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import 'admin_forms.dart';

class AdminProgramActions extends ConsumerWidget {
  const AdminProgramActions({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = ref.watch(currentProgramControllerProvider).value;
    if (program == null) {
      return const SizedBox.shrink();
    }
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
    return ExpansionTile(
      title: Text(program.name),
      subtitle: const Text('Program yönetimi'),
      children: [
        TextButton(
          onPressed: () async {
            final values = await adminForm(context, 'Programı düzenle', [
              (
                label: 'Ad',
                initial: program.name,
                secret: false,
                required: true,
              ),
              (
                label: 'Yıl',
                initial: program.year?.toString() ?? '',
                secret: false,
                required: false,
              ),
              (
                label: 'Açıklama',
                initial: program.description ?? '',
                secret: false,
                required: false,
              ),
            ]);
            if (values == null || !context.mounted) {
              return;
            }
            if (values[1].isNotEmpty && int.tryParse(values[1]) == null) {
              NzToast.show(context, 'Geçerli bir yıl girin.');
              return;
            }
            await run(() async {
              await command.run((o, p) async {
                await p.updateProgram(
                  program.id,
                  name: values[0],
                  year: int.tryParse(values[1]),
                  description: values[2],
                );
              });
              ref.invalidate(currentProgramControllerProvider);
            });
          },
          child: const Text('Bilgileri düzenle'),
        ),
        TextButton(
          onPressed: () async {
            final values = await adminForm(context, 'Program oluştur', [
              (label: 'Ad', initial: '', secret: false, required: true),
              (
                label: 'Yıl (isteğe bağlı)',
                initial: '',
                secret: false,
                required: false,
              ),
              (label: 'Açıklama', initial: '', secret: false, required: false),
            ]);
            if (values == null || !context.mounted) {
              return;
            }
            if (values[1].isNotEmpty && int.tryParse(values[1]) == null) {
              NzToast.show(context, 'Geçerli bir yıl girin.');
              return;
            }
            await run(
              () => command.run((o, p) async {
                await p.createProgram(
                  name: values[0],
                  year: int.tryParse(values[1]),
                  description: values[2],
                );
              }),
            );
          },
          child: const Text('Program oluştur'),
        ),
        TextButton(
          onPressed: () async {
            final values = await adminForm(
              context,
              'Dönemi sıfırla: ${program.name}',
              [
                (
                  label: 'Parolanız (dönem içeriği kalıcı silinir)',
                  initial: '',
                  secret: true,
                  required: true,
                ),
              ],
            );
            if (values == null || !context.mounted) {
              return;
            }
            await run(() async {
              await command.run((o, p) async {
                await p.resetProgram(program.id, password: values[0]);
              });
              await ref.read(taskCatalogControllerProvider.notifier).reload();
            });
          },
          child: const Text('Dönem içeriğini sıfırla'),
        ),
        TextButton(
          onPressed: () async {
            final values = await adminForm(
              context,
              'Programı sil: ${program.name}',
              [
                (
                  label: 'Parolanız (program ve içerik kalıcı silinir)',
                  initial: '',
                  secret: true,
                  required: true,
                ),
              ],
            );
            if (values == null || !context.mounted) {
              return;
            }
            await run(() async {
              await command.run((o, p) async {
                await p.deleteProgram(program.id, password: values[0]);
              });
              await ref.read(scopeSelectionControllerProvider.notifier).clear();
            });
          },
          child: const Text('Programı sil'),
        ),
      ],
    );
  }
}
