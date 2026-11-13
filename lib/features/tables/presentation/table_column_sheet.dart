import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../application/table_controller.dart';
import '../application/table_view.dart';
import '../domain/table_models.dart';
import 'table_sheet_host.dart';
import 'table_sheets.dart';
import 'table_texts.dart';

/// Sütun ekleme ([columnId] null) ya da düzenleme: ad, konum, silme. Tip yalnız eklerken
/// seçilir (değiştirme `convert_column` henüz ekranda yok); mobil yalnız düzenleyebildiği
/// tipleri ekler.
Future<void> tableColumn(
  BuildContext context,
  WidgetRef ref,
  String id,
  String? columnId,
) async {
  final provider = tableControllerProvider(id);
  final view = ref.read(provider).value;
  if (view == null) return;
  final l = context.l10n;
  final existing = columnId == null ? null : view.column(columnId);
  if (columnId != null && existing == null) return;
  var name = existing?.name ?? '';
  var kind = existing?.kind ?? TableColumnKind.text;
  final changes = ValueNotifier(0);
  final index = existing == null ? -1 : view.columns.indexOf(existing);
  Future<void> run(BuildContext sheet, Future<void> Function() action) async {
    final ok = await tableRun(context, action);
    if (ok && sheet.mounted) Navigator.of(sheet).pop();
  }

  await showTableSheet(
    ref,
    context,
    title: existing == null ? l.uiTablesNewColumn : l.uiTablesEditColumn,
    actions: (sheet) => [
      if (view.editable)
        ValueListenableBuilder<int>(
          valueListenable: changes,
          builder: (context, _, _) => NzButton.primary(
            label: l.uiTablesSave,
            onPressed: name.trim().isEmpty
                ? null
                : () => run(sheet, () async {
                    final c = ref.read(provider.notifier);
                    if (existing == null) {
                      await c.addColumn(name, kind);
                    } else if (name.trim() != existing.name) {
                      await c.renameColumn(existing.id, name);
                    }
                  }),
          ),
        ),
    ],
    builder: (sheet) => StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NzTextField(
            label: l.uiTablesFieldName,
            initialValue: name,
            enabled: view.editable,
            onChanged: (v) => setState(() {
              name = v;
              changes.value++;
            }),
          ),
          const Gap(NizamioSpacing.space3),
          if (existing == null)
            NzSelect<TableColumnKind>(
              label: l.uiTablesColumnType,
              value: kind,
              items: [
                for (final k in editableColumnKinds)
                  NzSelectItem(value: k, label: l.tableKind(k)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => kind = v);
              },
            )
          else ...[
            Text(
              '${l.uiTablesColumnType}: ${l.tableKind(existing.kind)}',
              style: context.text.bodySm,
            ),
            Text(
              l.uiTablesTypeFixed,
              style: context.text.caption.copyWith(
                color: context.colors.textMuted,
              ),
            ),
          ],
          if (existing != null && view.editable) ...[
            const Gap(NizamioSpacing.space3),
            Row(
              children: [
                Expanded(
                  child: NzButton.secondary(
                    label: l.uiTablesMoveLeft,
                    onPressed: index <= 0
                        ? null
                        : () => run(
                            sheet,
                            () => ref
                                .read(provider.notifier)
                                .moveColumn(
                                  existing.id,
                                  afterId: index >= 2
                                      ? view.columns[index - 2].id
                                      : null,
                                ),
                          ),
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                Expanded(
                  child: NzButton.secondary(
                    label: l.uiTablesMoveRight,
                    onPressed: index >= view.columns.length - 1
                        ? null
                        : () => run(
                            sheet,
                            () => ref
                                .read(provider.notifier)
                                .moveColumn(
                                  existing.id,
                                  afterId: view.columns[index + 1].id,
                                ),
                          ),
                  ),
                ),
              ],
            ),
            const Gap(NizamioSpacing.space3),
            NzButton.danger(
              label: l.uiTablesDelete,
              onPressed: () async {
                final yes = await NzDialog.confirm(
                  context,
                  title: l.uiTablesDeleteColumn,
                  message: l.uiTablesDeleteColumnMessage,
                  confirmLabel: l.uiTablesDelete,
                  cancelLabel: l.uiTablesCancel,
                  tone: NzDialogTone.destructive,
                );
                if (yes && sheet.mounted) {
                  await run(
                    sheet,
                    () => ref.read(provider.notifier).deleteColumn(existing.id),
                  );
                }
              },
            ),
          ],
        ],
      ),
    ),
  );
  changes.dispose();
}
