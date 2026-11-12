import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../tasks/tasks.dart';
import '../application/admin_transfer_controller.dart';

class AdminTransferPanel extends ConsumerStatefulWidget {
  const AdminTransferPanel({super.key});
  @override
  ConsumerState<AdminTransferPanel> createState() => _AdminTransferPanelState();
}

class _AdminTransferPanelState extends ConsumerState<AdminTransferPanel> {
  String? _target;
  String? _department;
  final _tasks = <String>{};
  bool _addAccess = false;
  void _clear() {
    setState(() {
      _target = null;
      _department = null;
      _tasks.clear();
      _addAccess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionGenerationProvider, (_, _) => _clear());
    ref.listen(scopeStateProvider, (_, _) => _clear());
    final source = ref.watch(scopeStateProvider).programId;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final transfer = ref.watch(adminTransferProvider);
    final controller = ref.read(adminTransferProvider.notifier);
    final locked = transfer.busy || transfer.preview != null;
    Future<void> run(Future<void> Function() call) async {
      try {
        await call();
      } on Object catch (e, st) {
        // Rapor, bağlam korumasından ÖNCE.
        final api = toReportedApiError(
          e,
          st,
          source: ReportSource.administration,
        );
        if (context.mounted) NzToast.error(context, api);
      }
    }

    return ExpansionTile(
      title: const Text('Programlar arası görev aktarımı'),
      children: [
        if (transfer.outcome case final outcome?)
          Text(
            '${outcome.movedWorkItemIds.length} görev ve ${outcome.movedFileCount} dosya aktarıldı.',
          ),
        if (transfer.preview case final preview?) ...[
          Text(
            'Hedef: ${ref.watch(transferProgramsProvider).value?.items.where((p) => p.id == transfer.selection?.target).firstOrNull?.name ?? ''}',
          ),
          for (final id in transfer.selection?.tasks ?? const <String>[])
            Text(catalog?.task(id)?.title ?? 'Görev'),
          TextButton(
            onPressed: transfer.busy ? null : controller.clearPreview,
            child: const Text('Seçimi değiştir'),
          ),
          Text(
            '${preview.resolvedWorkItemIds.length} görev · ${preview.fileCount} dosya · ${preview.fileTotalBytes} bayt',
          ),
          if (preview.blockers.isNotEmpty)
            const Text(
              'Sunucu aktarımı engelleyen kayıtlar buldu. Seçimi değiştirip yeniden önizleyin.',
            ),
          if (preview.warnings.isNotEmpty)
            const Text(
              'Aktarımda bağlantılar değişebilir. Sunucu uyarısı var.',
            ),
          if (preview.missingAccess)
            CheckboxListTile(
              value: _addAccess,
              onChanged: transfer.busy
                  ? null
                  : (v) => setState(() => _addAccess = v!),
              title: const Text('Eksik program bağlarını ekle'),
            ),
          TextButton(
            onPressed: !preview.canExecute || transfer.busy
                ? null
                : () => run(() async {
                    await controller.execute(addMissingAccess: _addAccess);
                    if (mounted) {
                      await ref
                          .read(taskCatalogControllerProvider.notifier)
                          .reload();
                    }
                  }),
            child: const Text('Önizlenen aktarımı uygula'),
          ),
        ],
        NzAsyncView(
          value: ref.watch(transferProgramsProvider),
          skeletonOnReload: true,
          onRetry: () => ref.invalidate(transferProgramsProvider),
          data: (programs) => Column(
            children: [
              if (programs.truncated)
                const Text(
                  'Program listesi kesildi. Bazı hedefler görünmeyebilir.',
                ),
              DropdownButton<String>(
                value: _target,
                hint: const Text('Hedef program'),
                isExpanded: true,
                items: [
                  for (final p in programs.items)
                    if (p.id != source)
                      DropdownMenuItem(value: p.id, child: Text(p.name)),
                ],
                onChanged: locked
                    ? null
                    : (value) => setState(() => _target = value),
              ),
            ],
          ),
        ),
        DropdownButton<String>(
          value: _department,
          hint: const Text('Koordinatörlük'),
          isExpanded: true,
          items: [
            for (final d
                in catalog?.coordinatorships ?? const <CoordinatorshipRef>[])
              DropdownMenuItem(value: d.code, child: Text(d.name)),
          ],
          onChanged: locked
              ? null
              : (value) => setState(() {
                  _department = value;
                  _tasks.clear();
                }),
        ),
        for (final task in catalog?.tasks ?? const <TaskItem>[])
          if (task.departmentId == _department)
            CheckboxListTile(
              value: _tasks.contains(task.id),
              title: Text(task.title),
              onChanged: locked
                  ? null
                  : (v) => setState(() {
                      if (v!) {
                        _tasks.add(task.id);
                      } else {
                        _tasks.remove(task.id);
                      }
                    }),
            ),
        TextButton(
          onPressed:
              transfer.busy ||
                  source == null ||
                  _target == null ||
                  _department == null ||
                  _tasks.isEmpty
              ? null
              : () => run(
                  () => controller.preview((
                    source: source,
                    target: _target!,
                    department: _department!,
                    tasks: _tasks.toList()..sort(),
                  )),
                ),
          child: const Text('Önizle'),
        ),
        if (transfer.busy) const LinearProgressIndicator(),
      ],
    );
  }
}
