import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../application/task_lifecycle_controller.dart';

class DeletedTasksPage extends ConsumerWidget {
  const DeletedTasksPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => NzPage(
    title: 'Silinen görevler',
    body: NzAsyncView(
      value: ref.watch(deletedTasksProvider),
      skeletonOnReload: true,
      onRetry: () => ref.invalidate(deletedTasksProvider),
      data: (page) => ListView(
        children: [
          if (page.items.isEmpty) const Text('Silinmiş görev yok.'),
          for (final task in page.items)
            ListTile(
              title: Text(task.title),
              trailing: TextButton(
                onPressed: () async {
                  try {
                    await ref.read(deletedTasksProvider.notifier).restore(task);
                  } on Object catch (e) {
                    if (context.mounted) NzToast.error(context, toApiError(e));
                  }
                },
                child: const Text('Geri yükle'),
              ),
            ),
          if (page.nextCursor != null)
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(deletedTasksProvider.notifier).loadMore();
                } on Object catch (e) {
                  if (context.mounted) NzToast.error(context, toApiError(e));
                }
              },
              child: const Text('Daha fazla göster'),
            ),
        ],
      ),
    ),
  );
}
