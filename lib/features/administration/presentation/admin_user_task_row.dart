import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../tasks/tasks.dart';
import '../domain/admin_user_tasks.dart';
import 'admin_user_task_texts.dart';

/// .us-trow: tarih ve gün sağda, durum noktası solda. Her satır ayrı tembel feed
/// öğesidir; komşu satırlar aynı yüzeyi ve yalnız iç ayırıcıyı paylaşır.
class AdminUserTaskRow extends StatelessWidget {
  const AdminUserTaskRow({
    super.key,
    required this.task,
    required this.today,
    required this.first,
    required this.last,
    this.coordinatorship,
  });
  final TaskItem task;

  /// Koordinatörlük adı (alt satırın başı; görev kimliği gösterilmez).
  final String? coordinatorship;
  final DateTime today;
  final bool first;
  final bool last;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.vertical(
      top: first ? const Radius.circular(NizamioRadius.card) : Radius.zero,
      bottom: last ? const Radius.circular(NizamioRadius.card) : Radius.zero,
    );
    final days = userTaskDueDays(task, today);
    final note = task.isDone
        ? context.l10n.uiUsersTaskCompleted
        : task.isOverdue
        ? '${task.overdueDays} ${context.l10n.uiUsersTaskLateDays}'
        : days == 0
        ? context.l10n.uiUsersTaskToday
        : days > 0
        ? '$days ${context.l10n.uiUsersTaskRemainingDays}'
        : '';
    final subtitle = [
      ?coordinatorship, userTaskStatusLabel(context, task.status),
      // Liste ucu dosya sayısı taşımaz. Yalnız ayrıntıdan gerçekten okunan pozitif
      // kayıtları göster; varsayılan `files: 0` kullanıcıya olgu diye sunulmaz.
      if (task.fileEntries.isNotEmpty)
        '${task.fileEntries.length} ${context.l10n.uiUsersTaskFilesCount}',
    ].join(' · ');
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: radius,
        border: Border.all(color: c.border),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 1,
          right: 1,
          top: first ? 1 : 0,
          bottom: last ? 1 : 0,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Material(
            type: MaterialType.transparency,
            child: MergeSemantics(
              child: Semantics(
                button: true,
                child: InkWell(
                  onTap: () => context.appNav.openTask(task.code),
                  splashFactory: NoSplash.splashFactory,
                  child: Stack(
                    children: [
                      if (!first)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 1,
                          child: ColoredBox(color: c.surface),
                        ),
                      if (!last)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 1,
                          child: ColoredBox(color: c.surface),
                        ),
                      if (!first)
                        Positioned(
                          top: 0,
                          left: 16,
                          right: 0,
                          height: 1,
                          child: ColoredBox(color: c.border),
                        ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 64),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) => Row(
                              children: [
                                ExcludeSemantics(
                                  child: SizedBox.square(
                                    dimension: 8,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: userTaskStatusColor(
                                          context,
                                          task.status,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        task.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.text.bodyMd.copyWith(
                                          fontSize: 14,
                                          height: 20 / 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Gap(2),
                                      Text(
                                        subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.text.caption.copyWith(
                                          fontSize: 12,
                                          color: c.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                        DateFormat('dd.MM.yyyy')
                                            .format(task.due),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.text.monoSm.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                      if (note.isNotEmpty) ...[
                                        const Gap(2),
                                        Text(
                                          note,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.text.caption.copyWith(
                                            fontSize: 11.5,
                                            color:
                                                task.isOverdue && !task.isDone
                                                ? c.danger
                                                : c.textFaint,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
