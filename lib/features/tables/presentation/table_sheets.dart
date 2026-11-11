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
import 'table_cell_editor.dart';
import 'table_column_sheet.dart';
import 'table_share_candidates.dart';
import 'table_sheet_host.dart';
import 'table_texts.dart';

export 'table_column_sheet.dart' show tableColumn;

String tableCellText(
  BuildContext context,
  TableField f,
  Object? value, [
  List<TableDocument> documents = const [],
]) {
  final l = context.l10n;
  if (value == null || value == '') return '—';
  if (f.type == TableFieldType.person) {
    return l.tableDemoPerson('$value');
  }
  if (f.type == TableFieldType.unit) return l.tableUnit('$value');
  if (f.type == TableFieldType.task) {
    return switch ('$value') {
      'demo-task-1' => 'ALT-7 · Havalimanı yerleşkesi',
      'demo-task-2' => 'ALT-10 · Montaj ve test',
      'demo-task-3' => 'ALT-15 · Söküm ve altyapı',
      _ => '${l.uiTablesTaskSample} ${value.toString().split("-").last}',
    };
  }
  if (f.type == TableFieldType.date) {
    final date = DateTime.tryParse('$value');
    if (date != null) {
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
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
    actions: (sheet) => [
      NzButton.primary(
        label: l.uiTablesSave,
        onPressed: () {
          ref.read(tablesControllerProvider.notifier).rename(id, name);
          Navigator.of(sheet).pop();
        },
      ),
    ],
    builder: (sheet) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NzTextField(
          label: l.uiTablesName,
          initialValue: d.title,
          onChanged: (v) => name = v,
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
    actions: (sheet) => [
      Consumer(
        builder: (context, ref, _) {
          final d = ref.watch(tablesControllerProvider).document(id);
          return NzButton.secondary(
            label: l.uiTablesSortNone,
            onPressed: d == null
                ? null
                : () {
                    onSort(null, false);
                    Navigator.of(sheet).pop();
                  },
          );
        },
      ),
      Consumer(
        builder: (context, ref, _) {
          final d = ref.watch(tablesControllerProvider).document(id);
          return NzButton.primary(
            label: l.uiTablesNewColumn,
            onPressed: d?.editable != true
                ? null
                : () {
                    Navigator.of(sheet).pop();
                    tableColumn(context, ref, id, null, onSort: (_) {});
                  },
          );
        },
      ),
    ],
    builder: (sheet) => Consumer(
      builder: (context, ref, _) {
        final d = ref.watch(tablesControllerProvider).document(id);
        if (d == null) return const SizedBox.shrink();
        return NzMenuGroup(
          rows: [
            for (final f in d.fields)
              Material(
                color: Colors.transparent,
                child: InkWell(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NizamioSpacing.space3,
                      vertical: NizamioSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(f.name, style: context.text.list),
                              Text(
                                l.tableType(f.type),
                                style: context.text.caption.copyWith(
                                  color: context.colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (d.editable) ...[
                          NzIconButton(
                            icon: NzIcons.arrowUp,
                            semanticLabel: '${f.name}: ${l.uiTablesMoveLeft}',
                            onPressed: d.fields.first.id == f.id
                                ? null
                                : () => ref
                                      .read(tablesControllerProvider.notifier)
                                      .moveField(id, f.id, -1),
                          ),
                          NzIconButton(
                            icon: NzIcons.arrowDown,
                            semanticLabel: '${f.name}: ${l.uiTablesMoveRight}',
                            onPressed: d.fields.last.id == f.id
                                ? null
                                : () => ref
                                      .read(tablesControllerProvider.notifier)
                                      .moveField(id, f.id, 1),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
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
  final controller = ref.read(tablesControllerProvider.notifier);
  final lease = controller.lease;
  int? expanded;
  await showTableSheet(
    ref,
    context,
    title: focusField == null
        ? (newRow ? l.uiTablesNewRecord : l.uiTablesEditRow)
        : (before.fields.where((f) => f.id == focusField).firstOrNull?.name ??
              l.uiTablesEditRow),
    expandable: true,
    actions: (sheet) => [
      NzButton.primary(
        label: l.uiTablesSave,
        onPressed: () => Navigator.of(sheet).pop(),
      ),
    ],
    builder: (sheet) => StatefulBuilder(
      builder: (context, setSheetState) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(tablesControllerProvider);
          final d = state.document(id);
          final row = d?.rows.where((r) => r.id == rowId).firstOrNull;
          if (d == null || row == null) return const SizedBox.shrink();
          final fields = focusField == null
              ? d.fields
              : d.fields.where((f) => f.id == focusField).toList();
          void set(TableField f, Object v) => ref
              .read(tablesControllerProvider.notifier)
              .cell(id, rowId, f.id, v);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (focusField == null)
                Padding(
                  padding: const EdgeInsets.only(bottom: NizamioSpacing.space3),
                  child: Text(
                    newRow ? d.title : 'Değişiklikler anında kaydedilir',
                    style: context.text.caption,
                  ),
                ),
              if (fields.isNotEmpty) ...[
                TableCellEditor(
                  key: ValueKey(
                    '${d.id}:$rowId:${fields.first.id}:${fields.first.type}',
                  ),
                  field: fields.first,
                  value: row.cells[TableFieldId(fields.first.id)],
                  editable: d.editable,
                  onChanged: (v) => set(fields.first, v),
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
                if (fields.length > 1) ...[
                  const Gap(NizamioSpacing.space3),
                  NzFormRows(
                    expandedIndex: expanded,
                    onToggle: (i) => setSheetState(
                      () => expanded = expanded == i ? null : i,
                    ),
                    rows: [
                      for (final f in fields.skip(1))
                        NzFormRow(
                          label: f.name,
                          value: tableCellText(
                            context,
                            f,
                            row.cells[TableFieldId(f.id)],
                            state.documents,
                          ),
                          valueSet: true,
                          content: Padding(
                            padding: const EdgeInsets.all(
                              NizamioSpacing.space3,
                            ),
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
                                          .read(
                                            tablesControllerProvider.notifier,
                                          )
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
                        ),
                    ],
                  ),
                ],
              ],
              const Gap(NizamioSpacing.space4),
              if (focusField != null && fields.isNotEmpty) ...[
                if (d.editable)
                  NzButton.secondary(
                    label: l.uiTablesClear,
                    onPressed: () {
                      final field = fields.first;
                      set(field, switch (field.type) {
                        TableFieldType.todo => false,
                        TableFieldType.link ||
                        TableFieldType.file => <Object>[],
                        _ => '',
                      });
                      Navigator.of(sheet).pop();
                    },
                  ),
                const Gap(NizamioSpacing.space2),
                NzButton.ghost(
                  label: 'Satırın tüm alanları',
                  onPressed: () {
                    Navigator.of(sheet).pop();
                    tableRow(context, ref, id, rowId, onOpenTable: onOpenTable);
                  },
                ),
              ] else ...[
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
                      if (yes &&
                          sheet.mounted &&
                          identical(lease, controller.lease)) {
                        ref
                            .read(tablesControllerProvider.notifier)
                            .removeRow(id, rowId);
                        Navigator.of(sheet).pop();
                      }
                    },
                  ),
              ],
            ],
          );
        },
      ),
    ),
  );
  if (newRow && identical(lease, controller.lease)) {
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
            NzSelect<TableAccess>(
              label: l.uiTablesProgramAccess,
              value: d.programAccess,
              items: [
                for (final access in [
                  TableAccess.off,
                  TableAccess.view,
                  TableAccess.edit,
                ])
                  NzSelectItem(value: access, label: l.tableAccess(access)),
              ],
              onChanged: !d.canShare
                  ? null
                  : (access) {
                      if (access != null) c.share(id, programAccess: access);
                    },
            ),
            const Gap(NizamioSpacing.space4),
            NzFormRows(
              rows: [
                for (final unit in tableDemoUnits)
                  NzFormRow.toggle(
                    label: l.tableUnit(unit),
                    value: d.sharedUnits.contains(unit),
                    onChanged: !d.canShare
                        ? null
                        : (v) => c.share(
                            id,
                            sharedUnits: v
                                ? [...d.sharedUnits, unit]
                                : d.sharedUnits
                                      .where((u) => u != unit)
                                      .toList(),
                          ),
                  ),
              ],
            ),
            const Gap(NizamioSpacing.space4),
            NzFormRows(
              rows: [
                NzFormRow(
                  label: l.uiTablesOwner,
                  value: l.tableAccess(d.access),
                  valueSet: true,
                ),
              ],
            ),
            for (final entry in d.people.entries) ...[
              const Gap(NizamioSpacing.space3),
              Row(
                children: [
                  Expanded(
                    child: NzSelect<TableAccess>(
                      label:
                          '${l.uiTablesDemoPerson} ${entry.key.value.split('-').last}',
                      value: entry.value,
                      items: [
                        for (final access in [
                          TableAccess.view,
                          TableAccess.edit,
                        ])
                          NzSelectItem(
                            value: access,
                            label: l.tableAccess(access),
                          ),
                      ],
                      onChanged: !d.canShare
                          ? null
                          : (access) {
                              if (access != null) {
                                c.share(
                                  id,
                                  people: {...d.people, entry.key: access},
                                );
                              }
                            },
                    ),
                  ),
                  if (d.canShare)
                    NzIconButton(
                      semanticLabel:
                          '${l.uiTablesRemovePerson}: ${l.uiTablesDemoPerson} ${entry.key.value.split('-').last}',
                      icon: NzIcons.close,
                      onPressed: () =>
                          c.share(id, people: {...d.people}..remove(entry.key)),
                    ),
                ],
              ),
            ],
            const Gap(NizamioSpacing.space3),
            if (d.canShare) TableShareCandidates(document: d),
            if (!d.canShare)
              Text(l.uiTablesReadonly, style: context.text.caption),
          ],
        );
      },
    ),
  );
}
