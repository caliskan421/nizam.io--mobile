import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/feedback/nz_progress_bar.dart';
import '../../tasks/tasks.dart';
import 'admin_user_task_texts.dart';

/// Kaynak .us-card / .us-dbar / .us-dl: tek düz yüzey, tek 10 px bölümlü şerit.
class AdminUserTaskSummary extends StatelessWidget {
  const AdminUserTaskSummary({
    super.key,
    required this.tasks,
    required this.truncated,
  });
  final List<TaskItem> tasks;
  final bool truncated;
  @override
  Widget build(BuildContext context) {
    final statuses = TaskStatus.values
        .where((s) => tasks.any((t) => t.status == s))
        .toList();
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(NizamioRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(NizamioSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.uiUsersDistribution,
                    style: context.text.labelLg.copyWith(fontSize: 14),
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                Text(
                  '${tasks.length}${truncated ? '+' : ''} ${context.l10n.uiUsersTaskCountNoun}',
                  style: context.text.monoSm.copyWith(color: c.textMuted),
                ),
              ],
            ),
            const Gap(NizamioSpacing.space3),
            NzProgressBar.segments(
              height: 10,
              segments: [
                for (final status in statuses)
                  NzBarSegment(
                    tasks.where((t) => t.status == status).length,
                    userTaskStatusColor(context, status),
                  ),
              ],
            ),
            for (final (i, status) in statuses.indexed) ...[
              Gap(i == 0 ? NizamioSpacing.space3 : NizamioSpacing.space2),
              Row(
                children: [
                  SizedBox.square(
                    dimension: 7,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: userTaskStatusColor(context, status),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      userTaskStatusLabel(context, status),
                      style: context.text.bodyMd.copyWith(
                        fontSize: 13,
                        color: c.textMuted,
                      ),
                    ),
                  ),
                  Text(
                    '${tasks.where((t) => t.status == status).length}',
                    style: context.text.monoSm.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
