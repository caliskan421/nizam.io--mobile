import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../tasks/tasks.dart';

/// Seçili görevin alt görevleri (web'deki gibi): ayrıntı okunur ([taskDetailsProvider]) ve
/// kataloğa eklenen alt görevler listelenir. Alt görevi olmayan görevde hiçbir şey çizilmez.
class TimelineSelectionSubtasks extends ConsumerStatefulWidget {
  const TimelineSelectionSubtasks({super.key, required this.task});

  final TaskItem task;

  @override
  ConsumerState<TimelineSelectionSubtasks> createState() => _SubtasksState();
}

class _SubtasksState extends ConsumerState<TimelineSelectionSubtasks> {
  bool _expanded = false;

  @override
  void didUpdateWidget(TimelineSelectionSubtasks oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.code != widget.task.code) _expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    ref.watch(taskDetailsProvider(task.code));
    final subtasks = task.subtasks;
    if (subtasks.isEmpty) return const SizedBox.shrink();
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: _expanded,
            child: Material(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.group),
              child: InkWell(
                borderRadius: BorderRadius.circular(NizamioRadius.group),
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.uiTasksTabSubtasks,
                          style: context.text.labelMd,
                        ),
                      ),
                      Text(
                        '${task.subtasksDone}/${subtasks.length}',
                        style: context.text.caption.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                      const Gap(8),
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: c.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_expanded)
            for (final s in subtasks)
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: c.surfaceRaised,
                  borderRadius: BorderRadius.circular(NizamioRadius.tile),
                ),
                child: Row(
                  children: [
                    Icon(
                      s.done
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
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
