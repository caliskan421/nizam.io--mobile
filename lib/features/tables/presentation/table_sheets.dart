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
import 'table_cell_editor.dart';
import 'table_share_candidates.dart';
import 'table_sheet_host.dart';
import 'table_texts.dart';

String tableCellText(
  BuildContext context,
  TableField f,
  Object? value, [
  List<TableDocument> documents = const [],
]) {
  final l = context.l10n;
  if (value == null || value == '') return '—';
  if (f.type == TableFieldType.person) {
    return '${l.uiTablesDemoPerson} ${value.toString().split('-').last}';
  }
  if (f.type == TableFieldType.unit) return l.tableUnit('$value');
  if (f.type == TableFieldType.task) {
    return '${l.uiTablesTaskSample} ${value.toString().split("-").last}';
  }
  if (f.type == TableFieldType.todo) return value == true ? '✓' : '—';
  if (f.type == TableFieldType.link && value is List) {
    final target = documents.where((d) => d.id == f.target).firstOrNull;
    if (target != null) {
      return value
          .map((id) {
            final row = target.rows.where((r) => r.id == id).firstOrNull;
            return row == null
                ? '—'
                : tableCellText(
                    context,
                    target.fields.first,
                    row.cells[TableFieldId(target.fields.first.id)],
                  );
          })
          .join(' · ');
    }
  }
  if (value is List) return value.join(' · ');
  return '$value';
}

Future<void> tableRename(BuildContext context, WidgetRef ref, String id) async {
  final d = ref.read(tablesControllerProvider).document(id);
  if (d == null) return;
  final l = context.l10n;
  var name = d.title;
  await showTableSheet(
    ref,
    context,
    title: l.uiTablesRename,
    builder: (sheet) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NzTextField(
          label: l.uiTablesName,
          initialValue: d.title,
          onChanged: (v) => name = v,
        ),
        const Gap(NizamioSpacing.space4),
        NzButton.primary(
          label: l.uiTablesSave,
          onPressed: () {
            ref.read(tablesControllerProvider.notifier).rename(id, name);
            Navigator.of(sheet).pop();
          },
        ),
      ],
    ),
  );
}

Future<void> tableFields(
  BuildContext context,
  WidgetRef ref,
  String id, {
  required void Function(String?, bool) onSort,
}) async {
  final l = context.l10n;
  await showTableSheet(
    ref,
    context,
    title: l.uiTablesFields,
    builder: (sheet) => Consumer(
      builder: (context, ref, _) {
        final d = ref.watch(tablesControllerProvider).document(id);
        if (d == null) return const SizedBox.shrink();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: d.editable,
              onReorderItem: (from, to) => ref
                  .read(tablesControllerProvider.notifier)
                  .reorderFields(id, from, to),
              children: [
                for (final f in d.fields)
                  ListTile(
                    key: ValueKey(f.id),
                    leading: const Icon(Icons.drag_indicator),
                    title: Text(f.name),
                    subtitle: Text(l.tableType(f.type)),
                    onTap: () {
                      Navigator.of(sheet).pop();
                      tableColumn(
                        context,
                        ref,
                        id,
                        f.id,
                        onSort: (v) => onSort(f.id, v),
                      );
                    },
                  ),
              ],
            ),
            if (d.editable)
              NzButton.primary(
                label: l.uiTablesNewColumn,
                onPressed: () {
                  Navigator.of(sheet).pop();
                  tableColumn(context, ref, id, null, onSort: (_) {});
                },
              ),
            NzButton.ghost(
              label: l.uiTablesSortNone,
              onPressed: () {
                onSort(null, false);
                Navigator.of(sheet).pop();
              },
            ),
          ],
        );
      },
    ),
  );
}

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
          Wrap(
            spacing: NizamioSpacing.space2,
            children: [
              for (final t in TableFieldType.values)
                ChoiceChip(
                  label: Text(l.tableType(t)),
                  selected: type == t,
                  onSelected: d.editable
                      ? (_) => setState(() => type = t)
                      : null,
                ),
            ],
          ),
          if (type == TableFieldType.link) ...[
            const Gap(NizamioSpacing.space3),
            Text(l.uiTablesLinkedTable, style: context.text.kicker),
            for (final t in targets)
              ChoiceChip(
                label: Text(t.title),
                selected: target == t.id,
                onSelected: d.editable
                    ? (_) => setState(() => target = t.id)
                    : null,
              ),
          ],
          if (existing != null) ...[
            const Gap(NizamioSpacing.space3),
            Wrap(
              spacing: NizamioSpacing.space2,
              children: [
                NzButton.ghost(
                  label: l.uiTablesSortAsc,
                  onPressed: () {
                    onSort(false);
                    Navigator.of(sheet).pop();
                  },
                ),
                NzButton.ghost(
                  label: l.uiTablesSortDesc,
                  onPressed: () {
                    onSort(true);
                    Navigator.of(sheet).pop();
                  },
                ),
              ],
            ),
            if (d.editable)
              Wrap(
                spacing: NizamioSpacing.space2,
                children: [
                  NzButton.ghost(
                    label: l.uiTablesMoveLeft,
                    onPressed: d.fields.first.id == existing.id
                        ? null
                        : () {
                            ref
                                .read(tablesControllerProvider.notifier)
                                .moveField(id, existing.id, -1);
                            Navigator.of(sheet).pop();
                          },
                  ),
                  NzButton.ghost(
                    label: l.uiTablesMoveRight,
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

Future<void> tableRow(
  BuildContext context,
  WidgetRef ref,
  String id,
  String rowId, {
  String? focusField,
  ValueChanged<String>? onOpenTable,
  bool newRow = false,
}) async {
  final l = context.l10n;
  final before = ref.read(tablesControllerProvider).document(id);
  if (before == null) return;
  await showTableSheet(
    ref,
    context,
    title: newRow ? l.uiTablesNewRecord : l.uiTablesEditRow,
    expandable: true,
    builder: (sheet) => Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(tablesControllerProvider);
        final d = state.document(id);
        final row = d?.rows.where((r) => r.id == rowId).firstOrNull;
        if (d == null || row == null) return const SizedBox.shrink();
        final fields = [...d.fields];
        if (focusField != null) {
          fields.sort(
            (a, b) => a.id == focusField
                ? -1
                : b.id == focusField
                ? 1
                : 0,
          );
        }
        void set(TableField f, Object v) => ref
            .read(tablesControllerProvider.notifier)
            .cell(id, rowId, f.id, v);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final f in fields)
              Padding(
                padding: const EdgeInsets.only(bottom: NizamioSpacing.space4),
                child: TableCellEditor(
                  key: ValueKey('${d.id}:$rowId:${f.id}:${f.type}'),
                  field: f,
                  value: row.cells[TableFieldId(f.id)],
                  editable: d.editable,
                  onChanged: (v) => set(f, v),
                  documents: state.documents,
                  onOpenTable: onOpenTable == null
                      ? null
                      : (target) {
                          ref
                              .read(tablesControllerProvider.notifier)
                              .markOpened(target);
                          onOpenTable(target);
                        },
                  onOpenRow: (target, row) => tableRow(
                    context,
                    ref,
                    target,
                    row,
                    onOpenTable: onOpenTable,
                  ),
                ),
              ),
            if (d.editable)
              NzButton.danger(
                label: l.uiTablesDelete,
                onPressed: () async {
                  final yes = await NzDialog.confirm(
                    context,
                    title: l.uiTablesDeleteRow,
                    message: l.uiTablesDeleteMessage,
                    confirmLabel: l.uiTablesDelete,
                    cancelLabel: l.uiTablesCancel,
                    tone: NzDialogTone.destructive,
                  );
                  if (yes && sheet.mounted) {
                    ref
                        .read(tablesControllerProvider.notifier)
                        .removeRow(id, rowId);
                    Navigator.of(sheet).pop();
                  }
                },
              ),
            NzButton.primary(
              label: l.uiTablesSave,
              onPressed: () => Navigator.of(sheet).pop(),
            ),
          ],
        );
      },
    ),
  );
  if (newRow) {
    final d = ref.read(tablesControllerProvider).document(id);
    final row = d?.rows.where((r) => r.id == rowId).firstOrNull;
    if (row != null &&
        row.cells.values.every(
          (v) => v == '' || v == false || (v is List && v.isEmpty),
        )) {
      ref.read(tablesControllerProvider.notifier).removeRow(id, rowId);
    }
  }
}

Future<void> tableSharing(
  BuildContext context,
  WidgetRef ref,
  String id,
) async {
  final l = context.l10n;
  await showTableSheet(
    ref,
    context,
    title: l.uiTablesShare,
    builder: (sheet) => Consumer(
      builder: (context, ref, _) {
        final d = ref.watch(tablesControllerProvider).document(id);
        if (d == null) return const SizedBox.shrink();
        final c = ref.read(tablesControllerProvider.notifier);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(d.title, style: context.text.titleSm),
            const Gap(NizamioSpacing.space4),
            Text(l.uiTablesProgramAccess, style: context.text.kicker),
            Wrap(
              spacing: NizamioSpacing.space2,
              children: [
                for (final access in [
                  TableAccess.off,
                  TableAccess.view,
                  TableAccess.edit,
                ])
                  ChoiceChip(
                    label: Text(l.tableAccess(access)),
                    selected: d.programAccess == access,
                    onSelected: d.canShare
                        ? (_) => c.share(id, programAccess: access)
                        : null,
                  ),
              ],
            ),
            const Gap(NizamioSpacing.space4),
            Text(l.uiTablesCoord, style: context.text.kicker),
            Wrap(
              spacing: NizamioSpacing.space2,
              children: [
                for (final unit in ['DEMO-A', 'DEMO-B'])
                  FilterChip(
                    label: Text(l.tableUnit(unit)),
                    selected: d.sharedUnits.contains(unit),
                    onSelected: d.canShare
                        ? (v) => c.share(
                            id,
                            sharedUnits: v
                                ? [...d.sharedUnits, unit]
                                : d.sharedUnits
                                      .where((u) => u != unit)
                                      .toList(),
                          )
                        : null,
                  ),
              ],
            ),
            const Gap(NizamioSpacing.space4),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(l.uiTablesOwner),
              subtitle: Text(l.tableAccess(d.access)),
            ),
            for (final entry in d.people.entries)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l.uiTablesDemoPerson} ${entry.key.value.split('-').last}',
                    style: context.text.labelMd,
                  ),
                  Wrap(
                    spacing: NizamioSpacing.space2,
                    children: [
                      for (final access in [TableAccess.view, TableAccess.edit])
                        ChoiceChip(
                          label: Text(l.tableAccess(access)),
                          selected: entry.value == access,
                          onSelected: d.canShare
                              ? (_) => c.share(
                                  id,
                                  people: {...d.people, entry.key: access},
                                )
                              : null,
                        ),
                      if (d.canShare)
                        IconButton(
                          tooltip: l.uiTablesRemovePerson,
                          icon: const Icon(Icons.close),
                          onPressed: () => c.share(
                            id,
                            people: {...d.people}..remove(entry.key),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            if (d.canShare) TableShareCandidates(document: d),
            if (!d.canShare)
              Text(l.uiTablesReadonly, style: context.text.caption),
          ],
        );
      },
    ),
  );
}
