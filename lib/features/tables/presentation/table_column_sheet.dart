import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../application/tables_controller.dart';
import '../domain/table_document.dart';
import 'table_sheet_host.dart';
import 'table_texts.dart';

Future<void> tableColumn(
  BuildContext context,
  WidgetRef ref,
  String id,
  String? fieldId, {
  required ValueChanged<bool> onSort,
}) async {
  final controller = ref.read(tablesControllerProvider.notifier);
  final lease = controller.lease;
  final state = ref.read(tablesControllerProvider);
  final d = state.document(id);
  if (d == null) return;
  final l = context.l10n;
  final existing = d.fields.where((f) => f.id == fieldId).firstOrNull;
  var name = existing?.name ?? '';
  var type = existing?.type ?? TableFieldType.text;
  var target = existing?.target;
  final targets = state.documents.where((t) => t.id != id).toList();
  final changes = ValueNotifier(0);
  await showTableSheet(
    ref,
    context,
    title: existing == null ? l.uiTablesNewColumn : l.uiTablesEditColumn,
    actions: (sheet) => [
      if (d.editable)
        ValueListenableBuilder<int>(
          valueListenable: changes,
          builder: (context, _, _) => NzButton.primary(
            label: l.uiTablesSave,
            onPressed:
                name.trim().isEmpty ||
                    (type == TableFieldType.link && target == null)
                ? null
                : () {
                    final c = ref.read(tablesControllerProvider.notifier);
                    if (existing == null) {
                      c.addField(id, name, type, target: target);
                    } else {
                      c.updateField(
                        id,
                        existing.copyWith(
                          name: name,
                          type: type,
                          target: target,
                        ),
                      );
                    }
                    Navigator.of(sheet).pop();
                  },
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
            enabled: d.editable,
            onChanged: (v) => setState(() {
              name = v;
              changes.value++;
            }),
          ),
          const Gap(NizamioSpacing.space3),
          NzSelect<TableFieldType>(
            label: 'Tip',
            value: type,
            items: [
              for (final t in TableFieldType.values)
                NzSelectItem(value: t, label: l.tableType(t)),
            ],
            onChanged: !d.editable
                ? null
                : (v) {
                    if (v != null) {
                      setState(() {
                        type = v;
                        changes.value++;
                      });
                    }
                  },
          ),
          if (type == TableFieldType.link) ...[
            const Gap(NizamioSpacing.space3),
            NzSelect<String>(
              label: l.uiTablesLinkedTable,
              value: targets.any((t) => t.id == target) ? target : null,
              items: [
                for (final t in targets)
                  NzSelectItem(value: t.id, label: t.title),
              ],
              onChanged: !d.editable
                  ? null
                  : (v) => setState(() {
                      target = v;
                      changes.value++;
                    }),
            ),
          ],
          if (existing != null) ...[
            const Gap(NizamioSpacing.space3),
            NzMenuGroup(
              rows: [
                NzMenuRow(
                  icon: NzIcons.arrowUp,
                  label: l.uiTablesSortAsc,
                  onTap: () {
                    onSort(false);
                    Navigator.of(sheet).pop();
                  },
                ),
                NzMenuRow(
                  icon: NzIcons.arrowDown,
                  label: l.uiTablesSortDesc,
                  onTap: () {
                    onSort(true);
                    Navigator.of(sheet).pop();
                  },
                ),
                if (d.editable)
                  NzMenuRow(
                    icon: NzIcons.chevronRight,
                    label:
                        'Konum ${d.fields.indexOf(existing) + 1} / ${d.fields.length}',
                    onTap: () {},
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NzIconButton(
                          icon: NzIcons.chevronLeft,
                          semanticLabel: l.uiTablesMoveLeft,
                          onPressed: d.fields.first.id == existing.id
                              ? null
                              : () {
                                  ref
                                      .read(tablesControllerProvider.notifier)
                                      .moveField(id, existing.id, -1);
                                  Navigator.of(sheet).pop();
                                },
                        ),
                        NzIconButton(
                          icon: NzIcons.chevronRight,
                          semanticLabel: l.uiTablesMoveRight,
                          onPressed: d.fields.last.id == existing.id
                              ? null
                              : () {
                                  ref
                                      .read(tablesControllerProvider.notifier)
                                      .moveField(id, existing.id, 1);
                                  Navigator.of(sheet).pop();
                                },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
          if (existing != null) ...[
            const Gap(NizamioSpacing.space3),
            if (d.editable && d.fields.length > 1)
              NzButton.danger(
                label: l.uiTablesDelete,
                onPressed: () async {
                  final yes = await NzDialog.confirm(
                    context,
                    title: l.uiTablesDeleteColumn,
                    message: l.uiTablesDeleteMessage,
                    confirmLabel: l.uiTablesDelete,
                    cancelLabel: l.uiTablesCancel,
                    tone: NzDialogTone.destructive,
                  );
                  if (yes &&
                      sheet.mounted &&
                      identical(lease, controller.lease)) {
                    ref
                        .read(tablesControllerProvider.notifier)
                        .removeField(id, existing.id);
                    Navigator.of(sheet).pop();
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
