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
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/navigation/nz_top_bar.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/tables_controller.dart';
import '../domain/table_document.dart';
import 'table_cell_value.dart';
import 'table_navigation_sheets.dart';
import 'table_sheet_host.dart';
import 'table_sheets.dart';
import 'table_texts.dart';

part 'table_page_actions.dart';

class TablePage extends ConsumerStatefulWidget {
  const TablePage({super.key, required this.id, this.onOpenTable});
  final String id;
  final ValueChanged<String>? onOpenTable;
  @override
  ConsumerState<TablePage> createState() => _TablePageState();
}

class _TablePageState extends ConsumerState<TablePage> {
  final _horizontal = ScrollController();
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  String _query = '';
  bool _showSearch = false;

  @override
  void dispose() {
    _horizontal.dispose();
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _dismissSearch() {
    if (!_showSearch) return;
    setState(() {
      _showSearch = false;
      _query = '';
    });
    _search.clear();
    _searchFocus.unfocus();
  }

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
        actions: [
          InkWell(
            onTap: () => tableSharing(context, ref, d.id),
            child: NzAvatarStack(
              colored: true,
              names: [
                if (d.id.startsWith('demo-plan-'))
                  l.tableDemoPerson('demo-1')
                else
                  l.uiTablesOwner,
                ...d.people.keys
                    .where(
                      (p) =>
                          !d.id.startsWith('demo-plan-') || p.value != 'demo-1',
                    )
                    .map((p) => l.tableDemoPerson(p.value)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: l.uiTablesOptions,
                icon: const Icon(Icons.more_horiz),
                onPressed: () => _options(d),
              ),
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
                    d.area == TableArea.coord
                        ? l.tableUnit(d.unit)
                        : l.tableArea(d.area),
                    style: context.text.monoSm,
                  ),
                  const Gap(6),
                  InkWell(
                    onTap: d.editable
                        ? () => tableRename(context, ref, d.id)
                        : null,
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
                          : d.rows
                                .where(
                                  (r) => r.cells[TableFieldId(todo.id)] == true,
                                )
                                .length;
                      final filters = todo == null
                          ? null
                          : NzPillTabs(
                              compact: true,
                              selected: _filter,
                              onSelected: (i) => setState(() => _filter = i),
                              tabs: [
                                NzPillTab(
                                  label: l.uiTablesAll,
                                  count: d.rows.length,
                                ),
                                NzPillTab(
                                  label: l.uiTablesOpen,
                                  count: d.rows.length - completed,
                                ),
                                NzPillTab(
                                  label: l.uiTablesDone,
                                  count: completed,
                                ),
                              ],
                            );
                      final actions = Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${rows.length} ${l.uiTablesRow}',
                              style: context.text.monoSm,
                            ),
                          ),
                          Semantics(
                            selected: _showSearch,
                            child: NzIconButton.circle(
                              icon: NzIcons.search,
                              semanticLabel: l.uiTablesSearch,
                              onPressed: () {
                                if (_showSearch) {
                                  _dismissSearch();
                                } else {
                                  setState(() => _showSearch = true);
                                }
                              },
                            ),
                          ),
                          const Gap(NizamioSpacing.space2),
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
                            const Gap(NizamioSpacing.space2),
                            NzButton.primary(
                              label: l.uiTablesNewRow,
                              icon: Icons.add,
                              radius: 999,
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
                        ],
                      );
                      if (constraints.maxWidth >= 700) {
                        return Row(
                          children: [
                            if (filters != null) ...[
                              SizedBox(width: 360, child: filters),
                              const Gap(12),
                            ],
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
                  NzReveal(
                    open: _showSearch,
                    onOpened: _searchFocus.requestFocus,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: NizamioSpacing.space4,
                      ),
                      child: Focus(
                        onKeyEvent: (node, event) {
                          if (event is KeyDownEvent &&
                              event.logicalKey == LogicalKeyboardKey.escape) {
                            _dismissSearch();
                            return KeyEventResult.handled;
                          }
                          return KeyEventResult.ignored;
                        },
                        child: NzSearchField(
                          controller: _search,
                          focusNode: _searchFocus,
                          onDismiss: _dismissSearch,
                          label: l.uiTablesSearch,
                          onChanged: (q) => setState(() => _query = q),
                        ),
                      ),
                    ),
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
                  final width =
                      (d.fields.length * cellWidth + 48 + (d.editable ? 48 : 0))
                          .clamp(constraints.maxWidth, double.infinity);
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          local.isCompact ? 0 : 20,
                        ),
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
                                      child: Center(
                                        child: Text(
                                          '#',
                                          style: context.text.monoSm,
                                        ),
                                      ),
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
                                            onSort: (descending) =>
                                                setState(() {
                                                  _sort = f.id;
                                                  _descending = descending;
                                                }),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                              NizamioSpacing.space3,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  _fieldIcon(f.type),
                                                  size: 14,
                                                ),
                                                const Gap(7),
                                                Expanded(
                                                  child: Text(
                                                    '${f.name}${_sort == f.id ? (_descending ? ' ↓' : ' ↑') : ''}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                          onPressed: () => tableColumn(
                                            context,
                                            ref,
                                            d.id,
                                            null,
                                            onSort: (_) {},
                                          ),
                                        ),
                                      ),
                                  ],
                                  header: true,
                                ),
                                Flexible(
                                  child: rows.isEmpty
                                      ? Center(
                                          heightFactor: 1,
                                          child: Text(l.uiTablesNoResults),
                                        )
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            context.text.monoSm,
                                                      ),
                                                    ),
                                                  ),
                                                  for (final f in d.fields)
                                                    SizedBox(
                                                      width: cellWidth,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              NizamioSpacing
                                                                  .space3,
                                                            ),
                                                        child: Text(
                                                          _summary(d, f),
                                                          style: context
                                                              .text
                                                              .monoSm,
                                                        ),
                                                      ),
                                                    ),
                                                  if (d.editable)
                                                    const SizedBox(width: 48),
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
                                                      onOpenTable:
                                                          widget.onOpenTable,
                                                    ),
                                                    icon: Text(
                                                      '${d.rows.indexOf(row) + 1}',
                                                      style:
                                                          context.text.monoSm,
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
                                                        padding:
                                                            const EdgeInsets.all(
                                                              NizamioSpacing
                                                                  .space3,
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
                                                                        field
                                                                            .id,
                                                                      )] !=
                                                                      true,
                                                                )
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (d.editable)
                                                  const SizedBox(width: 48),
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
}
