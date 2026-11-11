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
import 'table_column_sheet.dart';
export 'table_column_sheet.dart' show tableColumn;
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
    if (date != null)
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
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
            Text(
              'Sırayı oklarla değiştir, ayarlar için sütuna dokun.',
              style: context.text.caption,
            ),
            const Gap(NizamioSpacing.space3),
            for (final f in d.fields)
              ListTile(
                leading: const Icon(Icons.view_column_outlined),
                title: Text(f.name),
                subtitle: Text(l.tableType(f.type)),
                trailing: d.editable
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: l.uiTablesMoveLeft,
                            icon: const Icon(Icons.keyboard_arrow_up),
                            onPressed: d.fields.first.id == f.id
                                ? null
                                : () => ref
                                      .read(tablesControllerProvider.notifier)
                                      .moveField(id, f.id, -1),
                          ),
                          IconButton(
                            tooltip: l.uiTablesMoveRight,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onPressed: d.fields.last.id == f.id
                                ? null
                                : () => ref
                                      .read(tablesControllerProvider.notifier)
                                      .moveField(id, f.id, 1),
                          ),
                        ],
                      )
                    : null,
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
    title: focusField == null
        ? (newRow ? l.uiTablesNewRecord : l.uiTablesEditRow)
        : (before.fields.where((f) => f.id == focusField).firstOrNull?.name ??
              l.uiTablesEditRow),
    expandable: true,
    builder: (sheet) => Consumer(
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
            Container(
              decoration: focusField == null
                  ? BoxDecoration(
                      color: context.colors.surfaceRaised,
                      border: Border.all(color: context.colors.border),
                      borderRadius: BorderRadius.circular(16),
                    )
                  : null,
              child: Column(
                children: [
                  for (final f in fields)
                    if (focusField != null || f == fields.first)
                      Padding(
                        padding: const EdgeInsets.all(NizamioSpacing.space3),
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
                      )
                    else
                      ExpansionTile(
                        leading: const Icon(Icons.tune),
                        title: Text(f.name),
                        subtitle: Text(
                          tableCellText(
                            context,
                            f,
                            row.cells[TableFieldId(f.id)],
                            state.documents,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        children: [
                          Padding(
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
                        ],
                      ),
                ],
              ),
            ),
            const Gap(NizamioSpacing.space4),
            if (focusField != null && fields.isNotEmpty) ...[
              if (d.editable)
                NzButton.secondary(
                  label: l.uiTablesClear,
                  onPressed: () {
                    final field = fields.first;
                    set(field, switch (field.type) {
                      TableFieldType.todo => false,
                      TableFieldType.link || TableFieldType.file => <Object>[],
                      _ => '',
                    });
                    Navigator.of(sheet).pop();
                  },
                ),
              const Gap(NizamioSpacing.space2),
              NzButton.primary(
                label: l.uiTablesSave,
                onPressed: () => Navigator.of(sheet).pop(),
              ),
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
                for (final unit in tableDemoUnits)
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
