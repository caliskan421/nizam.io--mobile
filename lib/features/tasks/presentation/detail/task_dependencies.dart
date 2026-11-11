import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/task_catalog_controller.dart';
import '../../application/task_lifecycle_controller.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_permissions.dart';
import '../task_texts.dart';

/// Görevin beklediği ve bu görevi bekleyen görevler.
class TaskDependencies extends ConsumerWidget {
  const TaskDependencies({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final task = catalog?.task(code);
    if (task == null || catalog == null) return const SizedBox.shrink();
    final canEdit = TaskPermissions.of(catalog.access, task).coordinator;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const NzKicker('Bağımlılıklar'),
        const Gap(NizamioSpacing.space2),
        NzAsyncView(
          value: ref.watch(taskDependenciesProvider(code)),
          skeletonOnReload: true,
          onRetry: () => ref.invalidate(taskDependenciesProvider(code)),
          data: (links) {
            Widget group(String label, List<Widget> rows) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: NizamioSpacing.space2,
                  ),
                  child: Text(
                    label,
                    style: context.text.caption.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                ),
                if (rows.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: NizamioSpacing.space2,
                    ),
                    child: Text(
                      'Görev yok',
                      style: context.text.caption.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
                  )
                else
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      border: Border.all(color: context.colors.border),
                      borderRadius: BorderRadius.circular(NizamioRadius.card),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(NizamioRadius.card),
                      child: Column(
                        children: [
                          for (final (index, row) in rows.indexed) ...[
                            if (index > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: context.colors.border,
                                ),
                              ),
                            row,
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                group('Bağımlı olduğu görevler', [
                  for (final link in links.dependencies)
                    _DependencyRow(
                      today: catalog.today,
                      task: catalog.tasks
                          .where((t) => t.id == link.dependsOnId)
                          .firstOrNull,
                      onRemove: canEdit && !busy
                          ? () => change(remove: link.id)
                          : null,
                    ),
                ]),
                if (canEdit)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: busy
                          ? null
                          : () async {
                              final candidates = catalog.tasks.where(
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
                                        onPressed: () => Navigator.pop(
                                          context,
                                          candidate.id,
                                        ),
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
                      icon: const Icon(Icons.add),
                      label: const Text('Ön görev ekle'),
                    ),
                  ),
                const Gap(NizamioSpacing.space2),
                group('Bu göreve bağımlı görevler', [
                  for (final link in links.dependents)
                    _DependencyRow(
                      today: catalog.today,
                      task: catalog.tasks
                          .where((t) => t.id == link.workItemId)
                          .firstOrNull,
                    ),
                ]),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DependencyRow extends StatelessWidget {
  const _DependencyRow({
    required this.task,
    required this.today,
    this.onRemove,
  });
  final TaskItem? task;
  final DateTime today;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final item = task;
    final c = context.colors;
    final l = context.l10n;
    final days = item == null
        ? 0
        : DateUtils.dateOnly(item.due)
              .difference(DateUtils.dateOnly(today))
              .inDays;
    final note = item == null
        ? ''
        : item.isDone
        ? l.uiUsersTaskCompleted
        : item.isOverdue
        ? '${item.overdueDays} ${l.uiUsersTaskLateDays}'
        : days == 0
        ? l.uiUsersTaskToday
        : days > 0
        ? '$days ${l.uiUsersTaskRemainingDays}'
        : '';
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: item == null ? null : () => context.appNav.openTask(item.code),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: LayoutBuilder(
              builder: (context, constraints) => Row(
                children: [
                  SizedBox.square(
                    dimension: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: item == null
                            ? c.textMuted
                            : statusTone(item.status).color(c),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item?.title ?? 'Başka koordinatörlüğün görevi',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.bodyMd.copyWith(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (item != null) ...[
                          const Gap(2),
                          Text(
                            '${item.displayCode} · ${l.statusLabel(item.status)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.caption.copyWith(
                              fontSize: 12,
                              color: c.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (item != null) ...[
                    const Gap(12),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * .42,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat('dd.MM.yyyy').format(item.due),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.monoSm.copyWith(fontSize: 12),
                          ),
                          if (note.isNotEmpty) ...[
                            const Gap(2),
                            Text(
                              note,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.caption.copyWith(
                                fontSize: 11.5,
                                color: item.isOverdue && !item.isDone
                                    ? c.danger
                                    : c.textFaint,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  if (onRemove != null)
                    IconButton(
                      tooltip: 'Bağımlılığı kaldır',
                      onPressed: onRemove,
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
