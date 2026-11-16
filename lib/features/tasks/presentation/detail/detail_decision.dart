import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/surfaces/nz_decision_block.dart';
import '../../../../core/ui/widgets/surfaces/nz_lock_badge.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/effective_access.dart';
import '../../application/task_detail_controller.dart';
import '../../application/task_details_controller.dart';
import '../../application/task_lifecycle_controller.dart';
import '../../domain/coordinator_board.dart';
import '../../domain/task_catalog.dart';
import '../decision/task_decision_flows.dart';
import 'detail_member_band.dart';

/// Görev ayrıntısının koordinatör bölümü: onay bekleyen görevde karar bloğu (prototip `kd`:
/// özet, kanıt uyarısı, İade et / Onayla) ve bağımlılık kilit bandı (ön görev bitmeden
/// başlatılamaz). Üye görünümünde karar yerine üye bandı ([DetailMemberBand]). Karar yetkisi,
/// üye bandı ve kilit yoksa boş.
class DetailDecisionSection extends ConsumerWidget {
  const DetailDecisionSection({
    super.key,
    required this.task,
    required this.catalog,
  });

  final TaskItem task;
  final TaskCatalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    // Etkin görünüm değişince yetkiler yeniden okunur.
    final view = ref.watch(effectiveAccessProvider);
    final perms = ref
        .read(taskDetailControllerProvider(task.code).notifier)
        .permissions;
    final details = ref.watch(taskDetailsProvider(task.code));
    final links = ref.watch(taskDependenciesProvider(task.code)).value;
    final blocking = task.isDone || links == null
        ? const <TaskItem>[]
        : blockingPrerequisites(links, (id) {
            for (final t in catalog.tasks) {
              if (t.id == id) return t;
            }
            return null;
          });
    final decide = perms.canDecide(task);
    final member = !decide && view.isMemberView && !task.isDone;
    if (!decide && !member && blocking.isEmpty) return const SizedBox.shrink();
    final flows = TaskDecisionFlows(context, ref, task.code);
    // Kanıt sayısı yalnız ayrıntı okunduysa bilinir.
    final files = details.hasValue ? task.fileEntries.length : null;
    final subs = task.subtaskTotal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (blocking.isNotEmpty) ...[
          const Gap(NizamioSpacing.space4),
          _LockBand(titles: [for (final t in blocking) t.title]),
        ],
        if (member) ...[
          const Gap(NizamioSpacing.space4),
          DetailMemberBand(
            task: task,
            catalog: catalog,
            permissions: perms,
            blocking: blocking.length,
            files: files,
          ),
        ],
        if (decide) ...[
          const Gap(NizamioSpacing.space4),
          NzDecisionBlock(
            title: l.uiTasksDecisionKicker,
            summary: [
              l.uiTasksDecisionSubmitted,
              if (files != null) '$files ${l.uiTasksDecisionFilesTail}',
              if (subs > 0)
                '${l.uiTasksDecisionSubsHead} ${task.subtaskDoneTotal}/$subs',
            ].join(' · '),
            warning: files == 0 ? l.uiTasksDecisionNoEvidence : null,
            footnote: l.uiTasksDecisionFoot,
            returnLabel: l.uiTasksReturn,
            approveLabel: l.uiTasksApprove,
            onReturn: flows.returnTask,
            onApprove: flows.approve,
          ),
        ],
      ],
    );
  }
}

class _LockBand extends StatelessWidget {
  const _LockBand({required this.titles});

  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    return NzCard.filled(
      size: NzSize.sm,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NzLockBadge(label: l.uiTasksLockBadge),
          const Gap(NizamioSpacing.space2),
          Expanded(
            child: Text(
              '${l.uiTasksLockTitle}: ${titles.map((s) => '“$s”').join(', ')} '
              '${l.uiTasksLockTail}',
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
