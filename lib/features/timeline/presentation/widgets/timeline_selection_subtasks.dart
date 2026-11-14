import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';

/// Seçili görevin alt görevleri (web'deki gibi): ayrıntı okunur ([taskDetailsProvider]) ve
/// kataloğa eklenen alt görevler listelenir. Alt görevi olmayan görevde hiçbir şey çizilmez.
class TimelineSelectionSubtasks extends ConsumerWidget {
  const TimelineSelectionSubtasks({super.key, required this.task});

  final TaskItem task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(taskDetailsProvider(task.code));
    final subtasks = task.subtasks;
    if (subtasks.isEmpty) return const SizedBox.shrink();
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NzKicker(
            context.l10n.uiTasksTabSubtasks,
            trailing: '${task.subtasksDone}/${subtasks.length}',
          ),
          const Gap(4),
          for (final s in subtasks)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(
                    s.done
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    size: 18,
                    color: s.done ? c.taskDone : c.textMuted,
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      s.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySm,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
