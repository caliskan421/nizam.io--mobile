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
  final _horizontal = ScrollController();
  String _query = '';
  bool _showSearch = false;

  @override
  void dispose() {
    _horizontal.dispose();
    super.dispose();
  }

  String? _sort;
  bool _descending = false;
  int _filter = 0;
  TablesController get _controller => ref.read(tablesControllerProvider.notifier);
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
    final todo = d.fields.where((f) => f.type == TableFieldType.todo).firstOrNull;
    final rows = d.rows
        .where(
          (r) =>
              (_filter == 0 || todo == null || (r.cells[TableFieldId(todo.id)] == true) == (_filter == 2)) &&
              d.fields.any(
                (f) =>
                    tableCellText(context, f, r.cells[TableFieldId(f.id)]).toLowerCase().contains(_query.toLowerCase()),
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
            : tableCellText(context, sortField, av).compareTo(tableCellText(context, sortField, bv));
        return _descending ? -n : n;
      });
    }
    return NzPage.fill(
      topBar: NzTopBar.detail(
        actions: [
          InkWell(
            onTap: () => tableSharing(context, ref, d.id),
            child: NzAvatarStack(
              colored: true,
              names: [
                if (d.id.startsWith('demo-plan-')) l.tableDemoPerson('demo-1') else l.uiTablesOwner,
                ...d.people.keys
                    .where((p) => !d.id.startsWith('demo-plan-') || p.value != 'demo-1')
                    .map((p) => l.tableDemoPerson(p.value)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(tooltip: l.uiTablesOptions, icon: const Icon(Icons.more_horiz), onPressed: () => _options(d)),
              FilledButton.icon(
                onPressed: () => tableSharing(context, ref, d.id),
                icon: const Icon(Icons.ios_share, size: 16),
                label: Text(l.uiTablesShare),
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.text,
                  foregroundColor: context.colors.surface,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ],
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
                  Text(
                    d.area == TableArea.coord ? l.tableUnit(d.unit) : l.tableArea(d.area),
                    style: context.text.monoSm,
                  ),
                  const Gap(6),
                  InkWell(
                    onTap: d.editable ? () => tableRename(context, ref, d.id) : null,
                    child: Text(d.title, style: context.text.titleLg),
                  ),
                  const Gap(6),
                  Text(
                    d.id.startsWith('demo-plan-')
                        ? 'Kadir Özbek oluşturdu · son düzenleme bugün 09:20, Ali Avcı'
                        : '${d.rows.length} ${l.uiTablesRow} · ${d.fields.length} ${l.uiTablesColumn}',
                    style: context.text.caption,
                  ),
                  const Gap(16),
                  TableRelations(id: d.id, onOpen: widget.onOpenTable),
                  const Gap(10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final completed = todo == null
                          ? 0
                          : d.rows.where((r) => r.cells[TableFieldId(todo.id)] == true).length;
                      final filters = todo == null
                          ? null
                          : NzPillTabs(
                              compact: true,
                              selected: _filter,
                              onSelected: (i) => setState(() => _filter = i),
                              tabs: [
                                NzPillTab(label: l.uiTablesAll, count: d.rows.length),
                                NzPillTab(label: l.uiTablesOpen, count: d.rows.length - completed),
                                NzPillTab(label: l.uiTablesDone, count: completed),
                              ],
                            );
                      final actions = Row(
                        children: [
                          Expanded(child: Text('${rows.length} ${l.uiTablesRow}', style: context.text.monoSm)),
                          IconButton(
                            tooltip: l.uiTablesSearch,
                            onPressed: () => setState(() {
                              _showSearch = !_showSearch;
                              if (!_showSearch) _query = '';
                            }),
                            icon: const Icon(Icons.search, size: 20),
                          ),
                          NzButton.secondary(
                            label: l.uiTablesFields,
                            icon: Icons.view_column_outlined,
                            radius: 999,
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
                          if (d.editable) ...[
                            const Gap(6),
                            NzButton.primary(
                              label: l.uiTablesNewRow,
                              icon: Icons.add,
                              radius: 999,
                              onPressed: () {
                                final id = _controller.addRow(d.id);
                                if (id != null) {
                                  tableRow(context, ref, d.id, id, onOpenTable: widget.onOpenTable, newRow: true);
                                }
                              },
                            ),
                          ],
                        ],
                      );
                      if (constraints.maxWidth >= 700) {
                        return Row(
                          children: [
                            if (filters != null) ...[SizedBox(width: 360, child: filters), const Gap(12)],
                            Expanded(child: actions),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          if (filters != null) ...[filters, const Gap(10)],
                          actions,
                        ],
                      );
                    },
                  ),
                  if (_showSearch) ...[
                    const Gap(10),
                    NzTextField(label: l.uiTablesSearch, onChanged: (q) => setState(() => _query = q)),
                  ],
                  if (!d.editable)
                    Padding(
                      padding: const EdgeInsets.only(top: NizamioSpacing.space2),
                      child: Text(
                        l.uiTablesReadonly,
                        style: context.text.caption.copyWith(color: context.colors.warning),
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
                  final width = (d.fields.length * cellWidth + 48 + (d.editable ? 48 : 0)).clamp(
                    constraints.maxWidth,
                    double.infinity,
                  );
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(local.isCompact ? 0 : 20),
                        child: SingleChildScrollView(
                          controller: _horizontal,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _gridLine(
                                  context,
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      child: Center(child: Text('#', style: context.text.monoSm)),
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
                                            padding: const EdgeInsets.all(NizamioSpacing.space3),
                                            child: Row(
                                              children: [
                                                Icon(_fieldIcon(f.type), size: 14),
                                                const Gap(7),
                                                Expanded(
                                                  child: Text(
                                                    '${f.name}${_sort == f.id ? (_descending ? ' ↓' : ' ↑') : ''}',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: context.text.labelMd,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (d.editable)
                                      SizedBox(
                                        width: 48,
                                        child: IconButton(
                                          tooltip: l.uiTablesNewColumn,
                                          icon: const Icon(Icons.add, size: 20),
                                          onPressed: () => tableColumn(context, ref, d.id, null, onSort: (_) {}),
                                        ),
                                      ),
                                  ],
                                  header: true,
                                ),
                                Flexible(
                                  child: rows.isEmpty
                                      ? Center(heightFactor: 1, child: Text(l.uiTablesNoResults))
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: rows.length + 1,
                                          itemBuilder: (context, index) {
                                            if (index == rows.length) {
                                              return _gridLine(
                                                context,
                                                header: true,
                                                children: [
                                                  SizedBox(
                                                    width: 48,
                                                    child: Center(
                                                      child: Text(
                                                        l.uiTablesSummary,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: context.text.monoSm,
                                                      ),
                                                    ),
                                                  ),
                                                  for (final f in d.fields)
                                                    SizedBox(
                                                      width: cellWidth,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(NizamioSpacing.space3),
                                                        child: Text(_summary(d, f), style: context.text.monoSm),
                                                      ),
                                                    ),
                                                  if (d.editable) const SizedBox(width: 48),
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
                                                        onOpenTable: widget.onOpenTable,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(NizamioSpacing.space3),
                                                        child: TableCellValue(
                                                          field: field,
                                                          value: row.cells[TableFieldId(field.id)],
                                                          documents: ref.read(tablesControllerProvider).documents,
                                                          onToggle: d.editable
                                                              ? () => _controller.cell(
                                                                  d.id,
                                                                  row.id,
                                                                  field.id,
                                                                  row.cells[TableFieldId(field.id)] != true,
                                                                )
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (d.editable) const SizedBox(width: 48),
                                              ],
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

  Widget _gridLine(BuildContext context, {required List<Widget> children, bool header = false}) {
    final color = header ? context.colors.surfaceRaised : context.colors.surface;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: header ? 44 : 52),
        child: AnimatedBuilder(
          animation: _horizontal,
          builder: (context, _) => Stack(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Opacity(opacity: 0, child: children.first),
                    for (final cell in children.skip(1))
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: context.colors.border)),
                        ),
                        child: cell,
                      ),
                  ],
                ),
              ),
              Positioned(
                left: _horizontal.hasClients ? _horizontal.positions.last.pixels : 0,
                top: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    border: Border(right: BorderSide(color: context.colors.border)),
                  ),
                  child: children.first,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _fieldIcon(TableFieldType type) => switch (type) {
    TableFieldType.text => Icons.short_text,
    TableFieldType.number => Icons.tag,
    TableFieldType.date => Icons.calendar_today_outlined,
    TableFieldType.phone => Icons.phone_outlined,
    TableFieldType.email => Icons.mail_outline,
    TableFieldType.person => Icons.person_outline,
    TableFieldType.unit => Icons.account_tree_outlined,
    TableFieldType.task => Icons.checklist,
    TableFieldType.link => Icons.link,
    TableFieldType.file => Icons.attach_file,
    TableFieldType.todo => Icons.check_box_outlined,
  };

  String _summary(TableDocument d, TableField f) {
    final values = d.rows.map((r) => r.cells[TableFieldId(f.id)]).where((v) => v != null && v != '' && (v is! List || v.isNotEmpty)).toList();
    if (f.type == TableFieldType.number) {
      return '${values.fold<num>(0, (sum, v) => sum + (num.tryParse('$v') ?? 0))}';
    }
    if (f.type == TableFieldType.todo) {
      return '${values.where((v) => v == true).length} / ${d.rows.length}';
    }
    if (f.type == TableFieldType.person) return '${values.toSet().length} kişi';
    if (f.type == TableFieldType.file) {
      return '${values.fold<int>(0, (sum, value) => sum + (value is List ? value.length : 1))} dosya';
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
              title: Text(empty ? l.uiTablesDuplicateEmpty : l.uiTablesDuplicate),
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
              title: Text(l.uiTablesDelete, style: context.text.bodyMd.copyWith(color: context.colors.danger)),
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
