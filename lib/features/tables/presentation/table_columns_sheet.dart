import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/table_detail_controller.dart';
import '../application/table_view_controller.dart';
import '../domain/table_document.dart';
import '../domain/table_edit.dart';
import '../domain/table_workspace.dart';
import 'table_choice_row.dart';
import 'table_design.dart';
import 'table_grid_value.dart';
import 'table_sheet_host.dart';
import 'table_texts.dart';
import 'table_workspace_forms.dart';

Future<void> workspaceColumns(
  BuildContext context,
  WidgetRef ref,
  String id,
) => showTableSheet(
  ref,
  context,
  tableId: id,
  title: 'Sütunlar',
  showHeader: false,
  builder: (sheet) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sütunlar', style: context.text.titleSm),
                Text(
                  '${ref.read(tableDetailProvider(id)).data?.columns.length ?? 0} sütun',
                  style: context.text.caption.copyWith(
                    color: context.colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          TableDesignButton(
            label: 'Bitti',
            kind: TableButtonKind.plain,
            onPressed: () => Navigator.of(sheet).pop(),
          ),
        ],
      ),
      const Gap(16),
      Divider(height: 1, color: context.colors.border),
      const Gap(12),
      _ColumnsPanel(id: id),
    ],
  ),
);

class _ColumnsPanel extends ConsumerWidget {
  const _ColumnsPanel({required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(tableDetailProvider(id));
    final data = detail.data;
    if (data == null) return const SizedBox.shrink();
    final hidden = ref.watch(tableHiddenColumnsProvider(id));
    final locked = detail.busy || detail.pending;
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableDesignCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  itemCount: data.columns.length,
                  onReorderItem: (oldIndex, newIndex) {
                    if (locked) return;
                    final order = List<TableColumnState>.of(data.columns);
                    final moved = order.removeAt(oldIndex);
                    order.insert(newIndex, moved);
                    tableUiAction(
                      context,
                      () => ref
                          .read(tableDetailProvider(id).notifier)
                          .send(
                            EditTableColumn(
                              TableColumnAction.move,
                              moved.field,
                              data.schema,
                              after: newIndex == 0
                                  ? null
                                  : order[newIndex - 1].field.id,
                            ),
                          ),
                    );
                  },
                  // Drag proxies live in the overlay, outside the sheet's Material.
                  // Keep the ink host without adding a themed surface or elevation.
                  proxyDecorator: (child, index, animation) => Material(
                    type: MaterialType.transparency,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.surfaceRaised,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: child,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final column = data.columns[index];
                    return Container(
                      key: ValueKey(column.field.id),
                      margin: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: context.colors.border),
                        ),
                      ),
                      child: Row(
                        children: [
                          ReorderableDragStartListener(
                            index: index,
                            enabled: !locked,
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: TableDragHandle(),
                            ),
                          ),
                          Expanded(
                            child: NzTap(
                              onTap: () => workspaceColumnDetail(
                                context,
                                ref,
                                id,
                                column.field.id,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      column.field.name,
                                      style: context.text.labelLg,
                                    ),
                                    const Gap(2),
                                    Text(
                                      context.l10n.tableType(column.field.type),
                                      style: context.text.caption.copyWith(
                                        color: context.colors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          NzIconButton(
                            icon: hidden.contains(TableFieldId(column.field.id))
                                ? NzIcons.hidden
                                : NzIcons.visible,
                            semanticLabel:
                                '${column.field.name} ${hidden.contains(TableFieldId(column.field.id)) ? 'göster' : 'gizle'}',
                            onPressed: () => ref
                                .read(tableHiddenColumnsProvider(id).notifier)
                                .toggle(column.field.id),
                          ),
                          NzIconButton(
                            icon: NzIcons.chevronRight,
                            semanticLabel:
                                '${column.field.name} sütununu düzenle',
                            onPressed: () => workspaceColumnDetail(
                              context,
                              ref,
                              id,
                              column.field.id,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TableDesignButton(
                      label: 'Sütun ekle',
                      icon: NzIcons.add,
                      kind: TableButtonKind.plain,
                      onPressed: locked
                          ? null
                          : () => workspaceColumn(context, ref, id),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> workspaceColumnDetail(
  BuildContext context,
  WidgetRef ref,
  String id,
  String columnId,
) async {
  final controller = ref.read(tableDetailProvider(id).notifier);
  final initial = ref.read(tableDetailProvider(id)).data!;
  final column = initial.columns
      .where((c) => c.field.id == columnId)
      .firstOrNull;
  if (column == null) return;
  var name = column.field.name;
  var schema = initial.schema;
  var acknowledged = true;
  await workspaceForm(
    context,
    ref,
    id,
    title: column.field.name,
    description:
        '${initial.columns.indexOf(column) + 1}. sütun · ${context.l10n.tableType(column.field.type)}',
    save: 'Bitti',
    panelHeader: true,
    showCancel: false,
    saveInHeader: true,
    valid: () => name.trim().isNotEmpty && acknowledged,
    fields: (sheet, update) {
      final state = ref.read(tableDetailProvider(id));
      final data = state.data ?? initial;
      final index = data.columns.indexWhere((c) => c.field.id == columnId);
      final current = data.columns
          .where((c) => c.field.id == columnId)
          .firstOrNull;
      if (current == null) return const Text('Bu sütun artık yok.');
      final sort = state.query.sorts
          .where((s) => s.column == columnId)
          .firstOrNull;
      final locked = state.busy || state.pending;
      Future<void> move(bool right) async {
        final after = right
            ? data.columns[index + 1].field.id
            : index > 1
            ? data.columns[index - 2].field.id
            : null;
        await controller.send(
          EditTableColumn(
            TableColumnAction.move,
            current.field,
            data.schema,
            after: after,
          ),
        );
        if (context.mounted) {
          schema = ref.read(tableDetailProvider(id)).data?.schema ?? schema;
          update();
        }
      }

      return SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TableTitleInput(
              value: name,
              hint: 'Sütun adı',
              label: 'Sütun adı',
              onChanged: (v) {
                name = v;
                update();
              },
            ),
            const Gap(24),
            NzFormRows(
              radius: NizamioRadius.pill,
              rows: [
                NzFormRow(
                  label: 'Tip',
                  leading: tableFieldGlyph(context, current.field.type),
                  value: context.l10n.tableType(current.field.type),
                  valueSet: true,
                  onTap: locked
                      ? null
                      : () => workspaceColumn(
                          context,
                          ref,
                          id,
                          column: current,
                          action: TableColumnAction.convert,
                        ),
                ),
              ],
            ),
            const Gap(24),
            Text(
              'Sırala',
              style: context.text.monoSm.copyWith(
                color: context.colors.textMuted,
              ),
            ),
            const Gap(8),
            NzPillTabs(
              tabs: const [
                NzPillTab(label: 'Yok'),
                NzPillTab(label: 'Artan'),
                NzPillTab(label: 'Azalan'),
              ],
              selected: sort == null
                  ? 0
                  : sort.descending
                  ? 2
                  : 1,
              onSelected: (i) async {
                if (locked) return;
                await controller.query(
                  TableReadQuery(
                    filters: state.query.filters,
                    sorts: i == 0
                        ? []
                        : [(column: columnId, descending: i == 2)],
                    limit: state.query.limit,
                  ),
                );
                update();
              },
            ),
            const Gap(24),
            Text(
              'Konum · ${index + 1} / ${data.columns.length}',
              style: context.text.monoSm.copyWith(
                color: context.colors.textMuted,
              ),
            ),
            const Gap(8),
            TableDesignCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TableDesignButton(
                    label: 'Sola taşı',
                    alignStart: true,
                    icon: NzIcons.chevronLeft,
                    kind: TableButtonKind.row,
                    onPressed: locked || index == 0 ? null : () => move(false),
                  ),
                  Divider(height: 1, color: context.colors.border),
                  TableDesignButton(
                    label: 'Sağa taşı',
                    alignStart: true,
                    icon: NzIcons.chevronRight,
                    kind: TableButtonKind.row,
                    onPressed: locked || index == data.columns.length - 1
                        ? null
                        : () => move(true),
                  ),
                ],
              ),
            ),
            const Gap(24),
            TableDesignButton(
              label: 'Sütunu sil',
              kind: TableButtonKind.danger,
              onPressed: locked
                  ? null
                  : () async {
                      await workspaceConfirm(
                        context,
                        ref,
                        id,
                        title: 'Sütunu sil',
                        message: 'Bu sütundaki hücreler ve hücre yorumları silinecek.',
                        edit: EditTableColumn(
                          TableColumnAction.delete,
                          current.field,
                          data.schema,
                        ),
                      );
                      if (sheet.mounted &&
                          ref
                                  .read(tableDetailProvider(id))
                                  .data
                                  ?.columns
                                  .any((c) => c.field.id == columnId) ==
                              false) {
                        Navigator.of(sheet).pop();
                      }
                    },
            ),
            if (state.error?.code == 'tables.schema_conflict') ...[
              TableDesignButton(
                label: 'Güncel sütun düzenini al',
                kind: TableButtonKind.plain,
                onPressed: () async {
                  await controller.refresh();
                  if (sheet.mounted) {
                    schema =
                        ref.read(tableDetailProvider(id)).data?.schema ??
                        schema;
                    acknowledged = false;
                    update();
                  }
                },
              ),
              TableChoiceRow(
                label: 'Değişikliğimi güncel sütun düzenine uygula',
                value: acknowledged,
                onChanged: (v) {
                  acknowledged = v;
                  update();
                },
              ),
            ],
          ],
        ),
      );
    },
    submit: () async =>
        name.trim() == column.field.name ||
        await controller.send(
              EditTableColumn(
                TableColumnAction.rename,
                column.field.copyWith(name: name.trim()),
                schema,
              ),
            ) !=
            null,
  );
}
