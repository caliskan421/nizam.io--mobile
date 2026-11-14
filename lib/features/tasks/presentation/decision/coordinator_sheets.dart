import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/nz_action_rows.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/coordinator_board_provider.dart';
import '../../application/task_catalog_controller.dart';
import '../../domain/coordinator_board.dart';
import '../../domain/task_catalog.dart';
import '../task_texts.dart';
import 'coordinator_texts.dart';
import 'task_decision_flows.dart';

/// Onay kuyruğu satırı (ana sayfa, görev listesi bandı, kuyruk kaplaması aynı bileşen):
/// [NzQueueRow] + karar akışları.
class TaskQueueRow extends ConsumerWidget {
  const TaskQueueRow({super.key, required this.task, required this.today});

  final TaskItem task;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final flows = TaskDecisionFlows(context, ref, task.code);
    final subs = task.subtaskTotal;
    return NzQueueRow(
      title: task.title,
      meta: subs == 0 ? null : l.subtaskLine(task.subtaskDoneTotal, subs),
      dueText: l.dueLine(task, today),
      dueDanger: isTaskLate(task),
      returnLabel: l.uiTasksReturn,
      approveLabel: l.uiTasksApprove,
      onTap: () => context.appNav.openTask(task.code),
      onReturn: flows.returnTask,
      onApprove: flows.approve,
    );
  }
}

/// Atanmamış görev satırı: [NzUnassignedRow] + üstlen/ata akışları.
class TaskUnassignedRow extends ConsumerWidget {
  const TaskUnassignedRow({super.key, required this.task, required this.today});

  final TaskItem task;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final flows = TaskDecisionFlows(context, ref, task.code);
    return NzUnassignedRow(
      title: task.title,
      meta: '${l.priorityLabel(task.priority)} · ${l.dueLine(task, today)}',
      waitingLabel: l.uiTasksUnassignedWaiting,
      claimLabel: l.uiTasksClaim,
      assignLabel: l.uiTasksAssign,
      onTap: () => context.appNav.openTask(task.code),
      onClaim: flows.claim,
      onAssign: flows.assign,
    );
  }
}

/// Onay kuyruğu kaplaması (prototip `revq`): etkin koordinatörlüğün onay bekleyenleri;
/// karar verilen satır listeden düşer.
Future<void> showReviewQueueSheet(BuildContext context) {
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: l.uiTasksQueueTitle,
    builder: (sheet) => Consumer(
      builder: (context, ref, _) {
        final board = ref.watch(coordinatorBoardProvider);
        final today = ref.watch(
          taskCatalogControllerProvider.select((s) => s.value?.today),
        );
        final queue = board?.queue ?? const <TaskItem>[];
        if (queue.isEmpty || today == null) {
          return NzEmptyState(title: l.uiTasksQueueEmpty);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: NizamioSpacing.space2,
          children: [
            for (final t in queue) TaskQueueRow(task: t, today: today),
          ],
        );
      },
    ),
  );
}

/// Tarih talepleri kaplaması (prototip `dreqs`): Aktif / Kabul edildi / Reddedildi, salt
/// okunur. Karar şirket yöneticisinindir; satır görevi açar.
Future<void> showDateRequestsSheet(BuildContext context) {
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: l.uiTasksRequestsTitle,
    builder: (sheet) => const _DateRequestsBody(),
  );
}

class _DateRequestsBody extends ConsumerStatefulWidget {
  const _DateRequestsBody();

  @override
  ConsumerState<_DateRequestsBody> createState() => _DateRequestsBodyState();
}

class _DateRequestsBodyState extends ConsumerState<_DateRequestsBody> {
  static const _tabs = [
    DateRequestState.pending,
    DateRequestState.approved,
    DateRequestState.rejected,
  ];
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    return NzAsyncView<List<DateChangeRequest>>(
      value: ref.watch(myDateRequestsProvider),
      onRetry: () => ref.invalidate(myDateRequestsProvider),
      data: (all) {
        final state = _tabs[_tab];
        final rows = [
          for (final r in all)
            if (r.state == state) r,
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NzPillTabs(
              semanticLabel: l.uiTasksRequestsTitle,
              selected: _tab,
              onSelected: (i) => setState(() => _tab = i),
              tabs: [
                for (final s in _tabs)
                  NzPillTab(
                    label: switch (s) {
                      DateRequestState.approved => l.uiTasksRequestsTabApproved,
                      DateRequestState.rejected => l.uiTasksRequestsTabRejected,
                      _ => l.uiTasksRequestsTabActive,
                    },
                    count: all.where((r) => r.state == s).length,
                  ),
              ],
            ),
            const Gap(NizamioSpacing.space3),
            if (rows.isEmpty)
              NzEmptyState(
                title: switch (state) {
                  DateRequestState.approved => l.uiTasksRequestsEmptyApproved,
                  DateRequestState.rejected => l.uiTasksRequestsEmptyRejected,
                  _ => l.uiTasksRequestsEmptyActive,
                },
              )
            else
              for (final r in rows) ...[
                DateRequestRow(
                  request: r,
                  title: catalog?.task(r.workItemId ?? '')?.title,
                ),
                const Gap(NizamioSpacing.space2),
              ],
          ],
        );
      },
    );
  }
}

/// Tarih talebi satırı (ana sayfa "Tarih taleplerim" ve talepler kaplaması): görev, eski →
/// yeni bitiş, durum rozeti; bekleyen talepte "Yöneticide bekliyor" (salt okunur).
class DateRequestRow extends StatelessWidget {
  const DateRequestRow({super.key, required this.request, this.title});

  final DateChangeRequest request;

  /// Görev başlığı (katalogda görünüyorsa).
  final String? title;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final r = request;
    final id = r.workItemId;
    final label = l.requestStateLabel(r.state);
    final badge = switch (r.state) {
      DateRequestState.approved => NzBadge.success(label: label),
      DateRequestState.rejected => NzBadge.danger(label: label),
      _ => NzBadge.warning(label: label),
    };
    final note = switch (r.state) {
      DateRequestState.pending => l.uiTasksRequestWaitingAdmin,
      DateRequestState.rejected when r.reviewReason.isNotEmpty =>
        r.reviewReason,
      _ => null,
    };
    return NzCard.outlined(
      size: NzSize.sm,
      onTap: id == null ? null : () => context.appNav.openTask(id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title ?? l.uiTasksDetailTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.list.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Gap(NizamioSpacing.space2),
              badge,
            ],
          ),
          const Gap(NizamioSpacing.space1),
          Text(
            '${TaskDates.full(r.oldDue)} → ${TaskDates.full(r.due)} · '
            '${l.plusDays(r.due.difference(r.oldDue).inDays)}',
            style: t.mono.copyWith(color: c.textMuted),
          ),
          if (r.reason.isNotEmpty) ...[
            const Gap(NizamioSpacing.space1),
            Text(
              '“${r.reason}”',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ],
          if (note != null) ...[
            const Gap(NizamioSpacing.space1),
            Text(
              note,
              style: t.caption.copyWith(
                color: r.state == DateRequestState.rejected
                    ? c.danger
                    : c.warning,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
