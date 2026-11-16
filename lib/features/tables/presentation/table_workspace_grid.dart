import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../domain/table_workspace.dart';
import 'table_grid_value.dart';

class TableWorkspaceGrid extends StatefulWidget {
  const TableWorkspaceGrid({
    super.key,
    required this.data,
    required this.onCell,
    required this.onRow,
    required this.onColumn,
    this.offset = 0,
    this.enabled = true,
    this.participants = const [],
    this.onAddRow,
    this.onAddColumn,
    this.columns,
  });
  final TableWorkspace data;
  final List<TableColumnState>? columns;
  final int offset;
  final bool enabled;
  final VoidCallback? onAddRow;
  final VoidCallback? onAddColumn;
  final List<TableParticipant> participants;
  final void Function(String, String) onCell;
  final ValueChanged<String> onRow;
  final ValueChanged<TableColumnState> onColumn;
  @override
  State<TableWorkspaceGrid> createState() => _TableWorkspaceGridState();
}

class _TableWorkspaceGridState extends State<TableWorkspaceGrid> {
  final _horizontal = ScrollController();
  TableWorkspace get data => widget.data;
  List<TableColumnState> get columns => widget.columns ?? data.columns;
  @override
  void dispose() {
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cells = <(String, String), TableCellState>{
          for (final c in data.cells) (c.row, c.column): c,
        };
        // Column widths stay consistent across phone and tablet. The index column
        // shares this horizontal viewport with every data column.
        double width(TableColumnState c) => c.width.clamp(48, 1200).toDouble();
        final total = 96 + columns.fold<double>(0, (sum, c) => sum + width(c));
        final extra = columns.isNotEmpty && total < constraints.maxWidth
            ? (constraints.maxWidth - total) / columns.length
            : 0.0;
        Widget value(TableColumnState c, int i) {
          final rowId = data.document.rows[i].id;
          final selected = widget.participants
              .where((p) => p.row == rowId && p.column == c.field.id)
              .toList();
          final cell =
              cells[(rowId, c.field.id)] ?? data.cell(rowId, c.field.id);
          final child = NzTap(
            onTap: widget.enabled
                ? () => widget.onCell(rowId, c.field.id)
                : null,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: NizamioSpacing.space3,
                vertical: c.field.type.name == 'todo'
                    ? 0
                    : NizamioSpacing.space2,
              ),
              child: Align(
                alignment: c.field.type.name == 'todo'
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: TableGridValue(column: c, cell: cell),
              ),
            ),
          );
          return SizedBox(
            width: width(c) + extra,
            child: selected.isEmpty
                ? child
                : Tooltip(
                    message: selected.map((p) => p.name).join(', '),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.accentText.withValues(alpha: .1),
                        border: Border.all(color: context.colors.accentText),
                      ),
                      child: child,
                    ),
                  ),
          );
        }

        Widget row(List<Widget> children, {bool header = false}) =>
            DecoratedBox(
              decoration: BoxDecoration(
                color: header
                    ? context.colors.surfaceRaised
                    : context.colors.surface,
                border: Border(
                  bottom: BorderSide(color: context.colors.border),
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
            );
        return ClipRRect(
          borderRadius: BorderRadius.circular(NizamioRadius.group),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surface,
              border: Border.all(color: context.colors.border),
              borderRadius: BorderRadius.circular(NizamioRadius.group),
            ),
            child: RawScrollbar(
              padding: EdgeInsets.zero,
              thumbColor: context.colors.textMuted.withValues(alpha: .4),
              thickness: 4,
              radius: const Radius.circular(2),
              controller: _horizontal,
              thumbVisibility: true,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context)
                    .copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  controller: _horizontal,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: columns.isEmpty && total < constraints.maxWidth
                        ? constraints.maxWidth
                        : total + extra * columns.length,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        row([
                          const SizedBox(
                            width: 48,
                            child: Center(
                              child: Text(
                                '#',
                                key: ValueKey('table-row-number-header'),
                              ),
                            ),
                          ),
                          if (columns.isEmpty)
                            Expanded(
                              child: Text(
                                data.columns.isEmpty
                                    ? 'Sütun ekleyerek başla'
                                    : 'Sütunlar gizli',
                                style: context.text.caption,
                              ),
                            ),
                          for (final c in columns)
                            DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: context.colors.border,
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: width(c) + extra,
                                child: NzTap(
                                  onTap: widget.enabled
                                      ? () => widget.onColumn(c)
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      NizamioSpacing.space3,
                                    ),
                                    child: Row(
                                      children: [
                                        if (width(c) >= 64) ...[
                                          tableFieldGlyph(
                                            context,
                                            c.field.type,
                                          ),
                                          const Gap(NizamioSpacing.space2),
                                        ],
                                        Expanded(
                                          child: Text(
                                            c.field.name,
                                            style: context.text.labelMd
                                                .copyWith(
                                                  color:
                                                      context.colors.textMuted,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            width: 48,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: context.colors.border),
                              ),
                            ),
                            child: NzIconButton(
                              icon: NzIcons.add,
                              semanticLabel: 'Sütun ekle',
                              onPressed: widget.enabled
                                  ? widget.onAddColumn
                                  : null,
                            ),
                          ),
                        ], header: true),
                        for (var i = 0; i < data.document.rows.length; i++)
                          row([
                            SizedBox(
                              width: 48,
                              child: NzTap(
                                onTap: widget.enabled
                                    ? () =>
                                          widget.onRow(data.document.rows[i].id)
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: NizamioSpacing.space3,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${widget.offset + i + 1}',
                                      key: ValueKey((
                                        'table-row-number',
                                        data.document.rows[i].id,
                                      )),
                                      style: context.text.monoSm,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            for (final c in columns)
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: context.colors.border,
                                    ),
                                  ),
                                ),
                                child: value(c, i),
                              ),
                            Container(
                              width: 48,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: context.colors.border,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        if (widget.onAddRow != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: NizamioSpacing.space3,
                              ),
                              child: NzButton.ghost(
                                label: 'Yeni satır',
                                icon: NzIcons.add,
                                size: NzSize.sm,
                                onPressed: widget.enabled
                                    ? widget.onAddRow
                                    : null,
                              ),
                            ),
                          ),
                        if (data.document.rows.isNotEmpty)
                          row([
                            const Gap(48),
                            for (final c in columns)
                              SizedBox(
                                width: width(c) + extra,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    NizamioSpacing.space3,
                                  ),
                                  child: Text(
                                    tableColumnSummary(data, c),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.text.caption.copyWith(
                                      color: context.colors.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                          ], header: true),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
