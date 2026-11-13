import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/navigation/nz_top_bar.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../application/table_controller.dart';
import '../application/table_view.dart';
import '../domain/table_models.dart';
import 'table_cell_value.dart';
import 'table_column_sheet.dart';
import 'table_live.dart';
import 'table_sheet_host.dart';
import 'table_sheets.dart';
import 'table_texts.dart';

part 'table_page_actions.dart';

/// Tablo ayrıntısı: sunucu snapshot'ı (satır sayfaları), hücre düzenleme, satır/sütun
/// komutları. Canlı güncelleme (başkalarının değişikliği) sonraki turda; şimdilik
/// aşağı çekerek yenileme ve yazım sonrası yeniden okuma vardır.
class TablePage extends ConsumerStatefulWidget {
  const TablePage({super.key, required this.id, this.onOpenTable});
  final String id;
  final ValueChanged<String>? onOpenTable;
  @override
  ConsumerState<TablePage> createState() => _TablePageState();
}

class _TablePageState extends ConsumerState<TablePage> {
  final _horizontal = ScrollController();

  TableControllerProvider get _provider => tableControllerProvider(widget.id);
  TableController get _controller => ref.read(_provider.notifier);

  @override
  void dispose() {
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    ref.listenErrors(_provider, context);
    final async = ref.watch(_provider);
    final view = async.value;
    return NzPage.fill(
      topBar: NzTopBar.detail(
        actions: [
          if (view != null)
            IconButton(
              tooltip: l.uiTablesOptions,
              icon: const Icon(Icons.more_horiz),
              onPressed: () => _options(view),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: TableLiveScope(
          id: widget.id,
          child: NzAsyncView<TableView>(
            value: async,
            onRetry: () => ref.invalidate(_provider),
            data: (v) => _body(context, v),
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, TableView d) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(NizamioSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(l.tableSpace(d.meta.space), style: context.text.monoSm),
                  const Gap(NizamioSpacing.space3),
                  Expanded(
                    child: TableLiveBar(id: widget.id, view: d),
                  ),
                ],
              ),
              const Gap(6),
              InkWell(
                onTap: d.editable
                    ? () => tableRename(context, ref, widget.id)
                    : null,
                child: Text(d.meta.name, style: context.text.titleLg),
              ),
              const Gap(6),
              Text(
                '${d.rows.length}${d.hasMore ? '+' : ''} ${l.uiTablesRow} · '
                '${d.columns.length} ${l.uiTablesColumn}',
                style: context.text.caption,
              ),
              const Gap(NizamioSpacing.space3),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      d.pendingWrites > 0 ? l.uiTablesSaving : '',
                      style: context.text.monoSm,
                    ),
                  ),
                  if (d.editable)
                    NzButton.primary(
                      label: l.uiTablesNewRow,
                      icon: Icons.add,
                      radius: 999,
                      onPressed: () => _addRow(d),
                    ),
                ],
              ),
              if (d.writeError != null) ...[
                const Gap(NizamioSpacing.space2),
                NzBanner.danger(
                  message: l.uiTablesSaveFailed,
                  actionLabel: l.uiTablesRetry,
                  onAction: _controller.retryWrites,
                ),
              ],
              if (d.conflicts.isNotEmpty) ...[
                const Gap(NizamioSpacing.space2),
                NzBanner.warning(
                  message: l.uiTablesConflict,
                  actionLabel: l.uiTablesDismiss,
                  onAction: _controller.dismissConflicts,
                ),
              ],
              if (d.accessLost) ...[
                const Gap(NizamioSpacing.space2),
                NzBanner.danger(message: l.uiTablesAccessLost),
              ],
              if (!d.editable && !d.accessLost)
                Padding(
                  padding: const EdgeInsets.only(top: NizamioSpacing.space2),
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
        Expanded(child: _grid(context, d)),
      ],
    );
  }

  Future<void> _addRow(TableView d) async {
    String? rowId;
    final ok = await tableRun(context, () async {
      rowId = await _controller.addRow();
    });
    if (ok && rowId != null && mounted) {
      await tableRow(context, ref, widget.id, rowId!);
    }
  }

  Widget _grid(BuildContext context, TableView d) {
    final l = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final local = NzLayout.fromConstraints(constraints);
        double widthOf(TableColumnSpec c) =>
            c.width.toDouble().clamp(120, local.isCompact ? 240 : 320);
        final width =
            (d.columns.fold<double>(0, (s, c) => s + widthOf(c)) +
                    48 +
                    (d.editable ? 48 : 0))
                .clamp(constraints.maxWidth, double.infinity);
        final rows = d.rows;
        return ClipRRect(
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
                    header: true,
                    children: [
                      SizedBox(
                        width: 48,
                        child: Center(
                          child: Text('#', style: context.text.monoSm),
                        ),
                      ),
                      for (final c in d.columns)
                        SizedBox(
                          width: widthOf(c),
                          child: InkWell(
                            onTap: () =>
                                tableColumn(context, ref, widget.id, c.id),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                NizamioSpacing.space3,
                              ),
                              child: Row(
                                children: [
                                  Icon(_kindIcon(c.kind), size: 14),
                                  const Gap(7),
                                  Expanded(
                                    child: Text(
                                      c.name,
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
                            onPressed: () =>
                                tableColumn(context, ref, widget.id, null),
                          ),
                        ),
                    ],
                  ),
                  Flexible(
                    child: rows.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(
                              NizamioSpacing.space6,
                            ),
                            child: Text(l.uiTablesEmptyTable),
                          )
                        : RefreshIndicator(
                            onRefresh: () =>
                                tableRun(context, _controller.refresh),
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: rows.length + (d.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == rows.length) {
                                  return Padding(
                                    padding: const EdgeInsets.all(
                                      NizamioSpacing.space3,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: NzButton.secondary(
                                        label: l.uiTablesLoadMoreRows,
                                        onPressed: d.loadingMore
                                            ? null
                                            : () => tableRun(
                                                context,
                                                _controller.loadMore,
                                              ),
                                      ),
                                    ),
                                  );
                                }
                                return _row(context, d, index, widthOf);
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _row(
    BuildContext context,
    TableView d,
    int index,
    double Function(TableColumnSpec) widthOf,
  ) {
    final l = context.l10n;
    final row = d.rows[index];
    return _gridLine(
      context,
      children: [
        SizedBox(
          width: 48,
          child: IconButton(
            tooltip: l.uiTablesEditRow,
            onPressed: () => tableRow(context, ref, widget.id, row.id),
            icon: Text('${index + 1}', style: context.text.monoSm),
          ),
        ),
        for (final c in d.columns)
          SizedBox(
            width: widthOf(c),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: d.conflicts.contains(TableCellKey(row.id, c.id))
                    ? context.colors.warning.withValues(alpha: .12)
                    : null,
              ),
              child: InkWell(
                onTap: () => tableRow(
                  context,
                  ref,
                  widget.id,
                  row.id,
                  focusColumn: c.id,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(NizamioSpacing.space3),
                  child: TableCellValue(
                    view: d,
                    column: c,
                    data: d.cell(row.id, c.id),
                    onToggle: d.editable && !d.cell(row.id, c.id).redacted
                        ? () => _controller.editCell(
                            row.id,
                            c.id,
                            d.cell(row.id, c.id).value != true,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        if (d.editable) const SizedBox(width: 48, child: SizedBox.shrink()),
      ],
    );
  }
}
