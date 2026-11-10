import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/nz_top_bar.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/tables_controller.dart';
import '../domain/table_document.dart';
import 'table_cell_value.dart';
import 'table_navigation_sheets.dart';
import 'table_sheet_host.dart';
import 'table_sheets.dart';
import 'table_texts.dart';

class TablePage extends ConsumerStatefulWidget {
  const TablePage({super.key, required this.id, this.onOpenTable});
  final String id;
  final ValueChanged<String>? onOpenTable;
  @override
  ConsumerState<TablePage> createState() => _TablePageState();
}

class _TablePageState extends ConsumerState<TablePage> {
  String _query = '';
  String? _sort;
  bool _descending = false;
  int _filter = 0;
  TablesController get _controller =>
      ref.read(tablesControllerProvider.notifier);
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = ref.watch(tablesControllerProvider).document(widget.id);
    if (d == null) {
      return NzPage(
        title: l.uiTablesTitle,
        body: Center(child: Text(l.uiTablesTableMissing)),
      );
    }
    final todo = d.fields
        .where((f) => f.type == TableFieldType.todo)
        .firstOrNull;
    final rows = d.rows
        .where(
          (r) =>
              (_filter == 0 ||
                  todo == null ||
                  (r.cells[TableFieldId(todo.id)] == true) == (_filter == 2)) &&
              d.fields.any(
                (f) => tableCellText(
                  context,
                  f,
                  r.cells[TableFieldId(f.id)],
                ).toLowerCase().contains(_query.toLowerCase()),
              ),
        )
        .toList();
    final sortField = d.fields.where((f) => f.id == _sort).firstOrNull;
    if (sortField != null) {
      rows.sort((a, b) {
        final av = a.cells[TableFieldId(sortField.id)];
        final bv = b.cells[TableFieldId(sortField.id)];
        final n = sortField.type == TableFieldType.number
            ? (num.tryParse('$av') ?? 0).compareTo(num.tryParse('$bv') ?? 0)
            : tableCellText(
                context,
                sortField,
                av,
              ).compareTo(tableCellText(context, sortField, bv));
        return _descending ? -n : n;
      });
    }
    return NzPage.fill(
      topBar: NzTopBar.detail(
        title: l.uiTablesTitle,
        actions: [
          IconButton(
            tooltip: l.uiTablesShare,
            icon: const Icon(Icons.people_outline),
            onPressed: () => tableSharing(context, ref, d.id),
          ),
          IconButton(
            tooltip: l.uiTablesOptions,
            icon: const Icon(Icons.more_horiz),
            onPressed: () => _options(d),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(NizamioSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(d.title, style: context.text.titleLg),
                      ),
                      const Gap(NizamioSpacing.space2),
                      InkWell(
                        onTap: () => tableSharing(context, ref, d.id),
                        child: NzAvatarStack(
                          colored: true,
                          names: [
                            l.uiTablesOwner,
                            ...d.people.keys.map(
                              (p) =>
                                  '${l.uiTablesDemoPerson} ${p.value.split('-').last}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRelations(id: d.id, onOpen: widget.onOpenTable),
                  const Gap(NizamioSpacing.space2),
                  Text(
                    '${l.tableArea(d.area)} · ${d.rows.length} ${l.uiTablesRow} · ${d.fields.length} ${l.uiTablesColumn}',
                    style: context.text.caption,
                  ),
                  const Gap(NizamioSpacing.space3),
                  Wrap(
                    spacing: NizamioSpacing.space2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final i in [0, 1, 2])
                        ChoiceChip(
                          label: Text(
                            [l.uiTablesAll, l.uiTablesOpen, l.uiTablesDone][i],
                          ),
                          selected: _filter == i,
                          onSelected: (_) => setState(() => _filter = i),
                        ),
                      NzButton.ghost(
                        label: l.uiTablesFields,
                        onPressed: () => tableFields(
                          context,
                          ref,
                          d.id,
                          onSort: (id, descending) => setState(() {
                            _sort = id;
                            _descending = descending;
                          }),
                        ),
                      ),
                      if (d.editable)
                        NzButton.primary(
                          label: l.uiTablesNewRow,
                          onPressed: () {
                            final id = _controller.addRow(d.id);
                            if (id != null) {
                              tableRow(
                                context,
                                ref,
                                d.id,
                                id,
                                onOpenTable: widget.onOpenTable,
                                newRow: true,
                              );
                            }
                          },
                        ),
                    ],
                  ),
                  const Gap(NizamioSpacing.space3),
                  NzTextField(
                    label: l.uiTablesSearch,
                    onChanged: (q) => setState(() => _query = q),
                  ),
                  if (!d.editable)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: NizamioSpacing.space2,
                      ),
                      child: Text(
                        l.uiTablesReadonly,
                        style: context.text.caption.copyWith(
                          color: context.colors.warning,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final local = NzLayout.fromConstraints(constraints);
                  final cellWidth = local.isCompact ? 168.0 : 190.0;
                  final width = (d.fields.length * cellWidth + 48).clamp(
                    constraints.maxWidth,
                    double.infinity,
                  );
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: width,
                      child: Column(
                        children: [
                          _gridLine(
                            context,
                            children: [
                              SizedBox(
                                width: 48,
                                child: Text('#', style: context.text.monoSm),
                              ),
                              for (final f in d.fields)
                                SizedBox(
                                  width: cellWidth,
                                  child: InkWell(
                                    onTap: () => tableColumn(
                                      context,
                                      ref,
                                      d.id,
                                      f.id,
                                      onSort: (descending) => setState(() {
                                        _sort = f.id;
                                        _descending = descending;
                                      }),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                        NizamioSpacing.space3,
                                      ),
                                      child: Text(
                                        '${l.tableType(f.type)} · ${f.name}${_sort == f.id ? (_descending ? ' ↓' : ' ↑') : ''}',
                                        maxLines: 2,
                                        style: context.text.labelMd,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                            header: true,
                          ),
                          Expanded(
                            child: rows.isEmpty
                                ? Center(child: Text(l.uiTablesNoResults))
                                : ListView.builder(
                                    itemCount: rows.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == rows.length) {
                                        return _gridLine(
                                          context,
                                          header: true,
                                          children: [
                                            SizedBox(
                                              width: 48,
                                              child: Text(
                                                l.uiTablesSummary,
                                                style: context.text.monoSm,
                                              ),
                                            ),
                                            for (final f in d.fields)
                                              SizedBox(
                                                width: cellWidth,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    NizamioSpacing.space3,
                                                  ),
                                                  child: Text(
                                                    _summary(d, f),
                                                    style: context.text.monoSm,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      }
                                      final row = rows[index];
                                      return _gridLine(
                                        context,
                                        children: [
                                          SizedBox(
                                            width: 48,
                                            child: IconButton(
                                              tooltip: l.uiTablesEditRow,
                                              onPressed: () => tableRow(
                                                context,
                                                ref,
                                                d.id,
                                                row.id,
                                                onOpenTable: widget.onOpenTable,
                                              ),
                                              icon: Text(
                                                '${d.rows.indexOf(row) + 1}',
                                                style: context.text.monoSm,
                                              ),
                                            ),
                                          ),
                                          for (final field in d.fields)
                                            SizedBox(
                                              width: cellWidth,
                                              child: InkWell(
                                                onTap: () => tableRow(
                                                  context,
                                                  ref,
                                                  d.id,
                                                  row.id,
                                                  focusField: field.id,
                                                  onOpenTable:
                                                      widget.onOpenTable,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    NizamioSpacing.space3,
                                                  ),
                                                  child: TableCellValue(
                                                    field: field,
                                                    value:
                                                        row.cells[TableFieldId(
                                                          field.id,
                                                        )],
                                                    documents: ref
                                                        .read(
                                                          tablesControllerProvider,
                                                        )
                                                        .documents,
                                                    onToggle: d.editable
                                                        ? () => _controller.cell(
                                                            d.id,
                                                            row.id,
                                                            field.id,
                                                            row.cells[TableFieldId(
                                                                  field.id,
                                                                )] !=
                                                                true,
                                                          )
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridLine(
    BuildContext context, {
    required List<Widget> children,
    bool header = false,
  }) => DecoratedBox(
    decoration: BoxDecoration(
      color: header ? context.colors.surfaceRaised : context.colors.surface,
      border: Border(bottom: BorderSide(color: context.colors.border)),
    ),
    child: Row(children: children),
  );
  String _summary(TableDocument d, TableField f) {
    final values = d.rows
        .map((r) => r.cells[TableFieldId(f.id)])
        .where((v) => v != null && v != '')
        .toList();
    if (f.type == TableFieldType.number) {
      return '${values.fold<num>(0, (sum, v) => sum + (num.tryParse('$v') ?? 0))}';
    }
    if (f.type == TableFieldType.todo) {
      return '${values.where((v) => v == true).length} / ${d.rows.length}';
    }
    return '${values.length}';
  }

  Future<void> _options(TableDocument d) async {
    final l = context.l10n;
    await showTableSheet(
      ref,
      context,
      title: l.uiTablesOptions,
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(l.uiTablesCopyLink),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: '/tables/${d.id}'));
              if (sheet.mounted) Navigator.of(sheet).pop();
              if (mounted) NzToast.show(context, l.uiTablesLinkCopied);
            },
          ),

          if (d.editable)
            ListTile(
              title: Text(l.uiTablesRename),
              onTap: () {
                Navigator.of(sheet).pop();
                tableRename(context, ref, d.id);
              },
            ),
          ListTile(
            title: Text(l.uiTablesCopyTo),
            onTap: () {
              Navigator.of(sheet).pop();
              showCopyTable(context, ref, d.id, widget.onOpenTable);
            },
          ),
          for (final empty in [false, true])
            ListTile(
              title: Text(
                empty ? l.uiTablesDuplicateEmpty : l.uiTablesDuplicate,
              ),
              onTap: () {
                final id = _controller.duplicate(
                  d.id,
                  empty: empty,
                  suffix: empty ? l.uiTablesEmptySuffix : l.uiTablesCopySuffix,
                );
                Navigator.of(sheet).pop();
                if (id != null) widget.onOpenTable?.call(id);
              },
            ),
          if (d.canShare)
            ListTile(
              title: Text(
                l.uiTablesDelete,
                style: context.text.bodyMd.copyWith(
                  color: context.colors.danger,
                ),
              ),
              onTap: () async {
                Navigator.of(sheet).pop();
                final yes = await NzDialog.confirm(
                  context,
                  title: l.uiTablesDeleteTable,
                  message: l.uiTablesDeleteMessage,
                  confirmLabel: l.uiTablesDelete,
                  cancelLabel: l.uiTablesCancel,
                  tone: NzDialogTone.destructive,
                );
                if (yes && mounted) _controller.delete(d.id);
              },
            ),
        ],
      ),
    );
  }
}
