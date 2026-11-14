import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/coordinator_board_provider.dart';
import '../../application/task_catalog_controller.dart';
import '../../domain/task_catalog.dart';
import '../decision/coordinator_sheets.dart';
import '../decision/coordinator_texts.dart';

/// Görev listesinin koordinatör başlığı (prototip `tasks`, koordinatör dalı): kapsam satırı
/// ("Altyapı ve tesisat · 17 görev · 8 açık · yalnız ALT görevlerini görüyorsun"), onay kuyruğu
/// bandı (+ İncele → kuyruk kaplaması) ve tarih talepleri satırı (→ talepler kaplaması).
/// Koordinatör görünümü dışında boş. Gönderim anı sunucu listesinde yok: bant yalnız sayıyı
/// söyler.
class TasksCoordinatorHeader extends ConsumerWidget {
  const TasksCoordinatorHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(coordinatorBoardProvider);
    if (board == null) return const SizedBox.shrink();
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final requests =
        ref.watch(myDateRequestsProvider).value ?? const <DateChangeRequest>[];
    final active = requests.where((r) => r.isPending).length;
    final s = board.summary;
    // Kısa etiket: departman kodu, yoksa ad ([TaskDepartment.label]).
    final label = ref
        .watch(taskCatalogControllerProvider)
        .value
        ?.departments
        .where((d) => d.id == board.departmentId)
        .firstOrNull
        ?.label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.scopeLine(
            department: board.departmentName,
            label: label ?? board.departmentName,
            total: s.total,
            open: s.total - s.done,
          ),
          style: t.caption.copyWith(color: c.textMuted),
        ),
        if (board.queue.isNotEmpty) ...[
          const Gap(NizamioSpacing.space3),
          NzBanner.warning(
            message: '${board.queue.length} ${l.uiTasksQueueBandTail}',
            actionLabel: l.uiTasksQueueReview,
            onAction: () => showReviewQueueSheet(context),
          ),
        ],
        if (requests.isNotEmpty) ...[
          const Gap(NizamioSpacing.space2),
          NzListTile.navigation(
            title: l.uiTasksRequestsTitle,
            subtitle: l.requestsLine(active, requests.length),
            trailing: active == 0 ? null : NzCountPill.warning(active),
            onTap: () => showDateRequestsSheet(context),
          ),
        ],
        const Gap(NizamioSpacing.space4),
      ],
    );
  }
}
