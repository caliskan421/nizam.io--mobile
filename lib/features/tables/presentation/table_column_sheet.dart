import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
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
  final state = ref.read(tablesControllerProvider);
  final d = state.document(id);
  if (d == null) return;
  final l = context.l10n;
  final existing = d.fields.where((f) => f.id == fieldId).firstOrNull;
  var name = existing?.name ?? '';
  var type = existing?.type ?? TableFieldType.text;
  var target = existing?.target;
  final targets = state.documents.where((t) => t.id != id).toList();
  await showTableSheet(
    ref,
    context,
    title: existing == null ? l.uiTablesNewColumn : l.uiTablesEditColumn,
    builder: (sheet) => StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NzTextField(
            label: l.uiTablesFieldName,
            initialValue: name,
            enabled: d.editable,
            onChanged: (v) => setState(() => name = v),
          ),
          const Gap(NizamioSpacing.space3),
          Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceRaised,
              border: Border.all(color: context.colors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ExpansionTile(
                  leading: const Icon(Icons.category_outlined),
                  title: const Text('Tip'),
                  subtitle: Text(l.tableType(type)),
                  children: [
                    for (final t in TableFieldType.values)
                      ListTile(
                        dense: true,
                        title: Text(l.tableType(t)),
                        trailing: type == t ? const Icon(Icons.check) : null,
                        onTap: d.editable
                            ? () => setState(() => type = t)
                            : null,
                      ),
                  ],
                ),
                if (type == TableFieldType.link)
                  ExpansionTile(
                    leading: const Icon(Icons.link),
                    title: Text(l.uiTablesLinkedTable),
                    subtitle: Text(
                      targets.where((t) => t.id == target).firstOrNull?.title ??
                          '—',
                    ),
                    children: [
                      for (final t in targets)
                        ListTile(
                          dense: true,
                          title: Text(t.title),
                          trailing: target == t.id
                              ? const Icon(Icons.check)
                              : null,
                          onTap: d.editable
                              ? () => setState(() => target = t.id)
                              : null,
                        ),
                    ],
                  ),
                if (existing != null) ...[
                  ExpansionTile(
                    leading: const Icon(Icons.sort),
                    title: const Text('Sırala'),
                    children: [
                      ListTile(
                        title: Text(l.uiTablesSortAsc),
                        onTap: () {
                          onSort(false);
                          Navigator.of(sheet).pop();
                        },
                      ),
                      ListTile(
                        title: Text(l.uiTablesSortDesc),
                        onTap: () {
                          onSort(true);
                          Navigator.of(sheet).pop();
                        },
                      ),
                    ],
                  ),
                  if (d.editable)
                    ListTile(
                      leading: const Icon(Icons.swap_horiz),
                      title: const Text('Konum'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: l.uiTablesMoveLeft,
                            icon: const Icon(Icons.chevron_left),
                            onPressed: d.fields.first.id == existing.id
                                ? null
                                : () {
                                    ref
                                        .read(tablesControllerProvider.notifier)
                                        .moveField(id, existing.id, -1);
                                    Navigator.of(sheet).pop();
                                  },
                          ),
                          Text(
                            '${d.fields.indexOf(existing) + 1} / ${d.fields.length}',
                          ),
                          IconButton(
                            tooltip: l.uiTablesMoveRight,
                            icon: const Icon(Icons.chevron_right),
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
              ],
            ),
          ),
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
                  if (yes && sheet.mounted) {
                    ref
                        .read(tablesControllerProvider.notifier)
                        .removeField(id, existing.id);
                    Navigator.of(sheet).pop();
                  }
                },
              ),
          ],
          if (d.editable)
            NzButton.primary(
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
        ],
      ),
    ),
  );
}
