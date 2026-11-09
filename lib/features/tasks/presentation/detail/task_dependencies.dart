import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../application/task_catalog_controller.dart';
import '../../application/task_lifecycle_controller.dart';
import '../../domain/task_permissions.dart';

class TaskDependencies extends ConsumerWidget {
  const TaskDependencies({super.key, required this.code});
  final String code;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final task = catalog?.task(code);
    if (task == null) return const SizedBox.shrink();
    final canEdit = TaskPermissions.of(catalog?.access, task).coordinator;
    final busy = ref.watch(taskDependencyCommandProvider);
    Future<void> change({String? add, String? remove}) async {
      try {
        await ref
            .read(taskDependencyCommandProvider.notifier)
            .change(code, addTaskId: add, removeEdgeId: remove);
      } on Object catch (e) {
        if (context.mounted) NzToast.error(context, toApiError(e));
      }
    }

    return ExpansionTile(
      title: const Text('Bağımlılıklar'),
      children: [
        NzAsyncView(
          value: ref.watch(taskDependenciesProvider(code)),
          skeletonOnReload: true,
          onRetry: () => ref.invalidate(taskDependenciesProvider(code)),
          data: (links) => Column(
            children: [
              if (links.dependencies.isEmpty) const Text('Ön görev yok.'),
              for (final link in links.dependencies)
                ListTile(
                  title: Text(
                    catalog?.task(link.dependsOnId)?.title ??
                        'Başka koordinatörlüğün görevi',
                  ),
                  trailing: canEdit
                      ? TextButton(
                          onPressed: busy
                              ? null
                              : () => change(remove: link.id),
                          child: const Text('Kaldır'),
                        )
                      : null,
                ),
              if (canEdit)
                TextButton(
                  onPressed: busy
                      ? null
                      : () async {
                          final candidates = catalog!.tasks.where(
                            (t) =>
                                t.id != task.id &&
                                !links.dependencies.any(
                                  (d) => d.dependsOnId == t.id,
                                ),
                          );
                          final id = await showDialog<String>(
                            context: context,
                            builder: (context) => SimpleDialog(
                              title: const Text('Ön görev seç'),
                              children: [
                                for (final candidate in candidates)
                                  SimpleDialogOption(
                                    onPressed: () =>
                                        Navigator.pop(context, candidate.id),
                                    child: Text(candidate.title),
                                  ),
                                SimpleDialogOption(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Vazgeç'),
                                ),
                              ],
                            ),
                          );
                          if (id != null) await change(add: id);
                        },
                  child: const Text('Ön görev ekle'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
