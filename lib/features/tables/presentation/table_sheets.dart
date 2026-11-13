import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../application/table_controller.dart';
import '../application/table_sync_controller.dart';
import 'table_cell_editor.dart';
import 'table_comments.dart';
import 'table_sheet_host.dart';

/// Sunucu komutunu çalıştırır; hata toast olarak gösterilir (oturum bitti sınıfı hariç).
/// Başarıda true.
Future<bool> tableRun(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
    return true;
  } on ApiError catch (e, st) {
    reportUnexpected(e, st, source: ReportSource.tables);
    if (context.mounted && !sessionEndedErrorCodes.contains(e.code)) {
      NzToast.error(context, e);
    }
    return false;
  }
}

Future<void> tableRename(BuildContext context, WidgetRef ref, String id) async {
  final view = ref.read(tableControllerProvider(id)).value;
  if (view == null) return;
  final l = context.l10n;
  var name = view.meta.name;
  // Uçuş kilidi: istek sürerken kaydet kapalıdır (asıl koruma denetleyicide: alan başına
  // makbuz sırası).
  final busy = ValueNotifier(false);
  await showTableSheet(
    ref,
    context,
    title: l.uiTablesRename,
    actions: (sheet) => [
      ValueListenableBuilder<bool>(
        valueListenable: busy,
        builder: (context, saving, _) => NzButton.primary(
          label: l.uiTablesSave,
          loading: saving,
          onPressed: saving
              ? null
              : () async {
                  if (name.trim().isEmpty || name.trim() == view.meta.name) {
                    Navigator.of(sheet).pop();
                    return;
                  }
                  busy.value = true;
                  final ok = await tableRun(
                    context,
                    () => ref
                        .read(tableControllerProvider(id).notifier)
                        .rename(name),
                  );
                  if (!sheet.mounted) return;
                  busy.value = false;
                  if (ok) Navigator.of(sheet).pop();
                },
        ),
      ),
    ],
    builder: (sheet) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NzTextField(
          label: l.uiTablesName,
          initialValue: view.meta.name,
          onChanged: (v) => name = v,
        ),
      ],
    ),
  );
  busy.dispose();
}

/// Satır düzenleme: her sütun için düzenleyici; değişiklik yerelde hemen görünür ve
/// birleştirilerek gönderilir. Sayfa kapanınca bekleyen hücreler gönderilir.
Future<void> tableRow(
  BuildContext context,
  WidgetRef ref,
  String id,
  String rowId, {
  String? focusColumn,
}) async {
  final l = context.l10n;
  final provider = tableControllerProvider(id);
  final sync = ref.read(tableSyncControllerProvider(id).notifier);
  final first = ref.read(provider).value?.columns.firstOrNull?.id;
  // Presence: başkaları bu satırı (odaklanılan hücreyi) düzenlediğimizi görür.
  sync.select(rowId, focusColumn ?? first);
  await showTableSheet(
    ref,
    context,
    title: l.uiTablesEditRow,
    expandable: true,
    actions: (sheet) => [
      NzButton.primary(
        label: l.uiTablesSave,
        onPressed: () => Navigator.of(sheet).pop(),
      ),
    ],
    builder: (sheet) => Consumer(
      builder: (context, ref, _) {
        final view = ref.watch(provider).value;
        if (view == null || !view.rows.any((r) => r.id == rowId)) {
          return const SizedBox.shrink();
        }
        final columns = focusColumn == null
            ? view.columns
            : view.columns.where((c) => c.id == focusColumn).toList();
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final c in columns) ...[
              TableCellEditor(
                key: ValueKey('$id:$rowId:${c.id}'),
                view: view,
                column: c,
                data: view.cell(rowId, c.id),
                onChanged: (v) =>
                    ref.read(provider.notifier).editCell(rowId, c.id, v),
              ),
              const Gap(NizamioSpacing.space3),
            ],
            if (focusColumn == null) ...[
              TableRowComments(
                tableId: id,
                rowId: rowId,
                canWrite: view.editable,
              ),
              const Gap(NizamioSpacing.space3),
            ],
            if (view.editable && focusColumn == null)
              NzButton.danger(
                label: l.uiTablesDelete,
                onPressed: () async {
                  final yes = await NzDialog.confirm(
                    context,
                    title: l.uiTablesDeleteRow,
                    message: l.uiTablesDeleteRowMessage,
                    confirmLabel: l.uiTablesDelete,
                    cancelLabel: l.uiTablesCancel,
                    tone: NzDialogTone.destructive,
                  );
                  if (!yes || !context.mounted) return;
                  final ok = await tableRun(
                    context,
                    () => ref.read(provider.notifier).deleteRow(rowId),
                  );
                  if (ok && sheet.mounted) Navigator.of(sheet).pop();
                },
              ),
          ],
        );
      },
    ),
  );
  sync.select(null, null);
  if (context.mounted) await ref.read(provider.notifier).flush();
}
