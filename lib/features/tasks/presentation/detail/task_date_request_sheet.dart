import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../application/task_catalog_controller.dart';
import '../../application/task_detail_controller.dart';
import 'detail_actions.dart';
import 'task_date_request_card.dart';

/// Çizelge dahil tüm girişlerde ayrıntının aynı süre seçimi ve talep formu.
void showTaskExtendSheet(BuildContext context, WidgetRef ref, String code) =>
    TaskDetailActions(context, ref, code).openExtend();

Future<void> showTaskDateRequestSheet(BuildContext context, String code) =>
    NzBottomSheet.show<void>(
      context,
      title: context.l10n.uiTasksRequestTitle,
      builder: (_) => _RequestBody(code: code),
    );

class _RequestBody extends ConsumerWidget {
  const _RequestBody({required this.code});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Yazma boyunca ayrıntı denetleyicisi canlıdır; aynı meşguliyet ve yetki kapısı.
    final state = ref.watch(taskDetailControllerProvider(code));
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final request = catalog?.task(code)?.dateRequest;
    if (request == null) return const SizedBox.shrink();
    final actions = TaskDetailActions(context, ref, code);
    Future<void> decide(Future<void> Function() action) async {
      await action();
      if (!context.mounted) return;
      final current = ref.read(taskCatalogControllerProvider).value?.task(code);
      if (current != null && !current.hasPendingRequest) {
        Navigator.of(context).pop();
      }
    }

    final canReview = actions.canReviewDate && request.isPending;
    return TaskDateRequestCard(
      request: request,
      by: request.by == null
          ? ''
          : catalog?.nameOf(request.by!) ?? context.l10n.uiTasksUnknownPerson,
      waiting: !actions.canReviewDate && request.isPending,
      onApprove: canReview && !state.busy
          ? () => decide(actions.approveRequest)
          : null,
      onReject: canReview && !state.busy
          ? () => decide(actions.rejectRequest)
          : null,
    );
  }
}
