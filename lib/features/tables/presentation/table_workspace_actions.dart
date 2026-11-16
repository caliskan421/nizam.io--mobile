import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/table_detail_controller.dart';
import '../domain/table_edit.dart';
import '../domain/table_workspace.dart';
import 'table_columns_sheet.dart';
import 'table_query_value.dart';
import 'table_sheet_host.dart';
import 'table_workspace_comments.dart';
import 'table_workspace_forms.dart';
import 'table_workspace_organize.dart';
import 'table_workspace_sharing.dart';

Future<void> workspaceOptions(
  BuildContext context,
  WidgetRef ref,
  String id, {
  ValueChanged<String>? onOpenTable,
}) async {
  final state = ref.read(tableDetailProvider(id));
  final data = state.data!;
  final owner = data.document.access.name == 'owner';
  await showTableSheet(
    ref,
    context,
    tableId: id,
    title: 'Tablo seçenekleri',
    builder: (sheet) {
      void open(FutureOr<void> Function() action) {
        Navigator.of(sheet).pop();
        tableUiAction(context, action);
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NzMenuGroup(
            rows: [
              if (owner)
                NzMenuRow(
                  icon: NzIcons.edit,
                  label: 'Adını değiştir',
                  onTap: () => open(() => workspaceName(context, ref, id)),
                ),
              if (owner)
                NzMenuRow(
                  icon: NzIcons.group,
                  label: 'Paylaşım ve yetkiler',
                  onTap: () => open(() => workspaceSharing(context, ref, id)),
                ),
              NzMenuRow(
                icon: NzIcons.messages,
                label: 'Yorumlar',
                onTap: () => open(() => workspaceComments(context, ref, id)),
              ),
              NzMenuRow(
                icon: NzIcons.filter,
                label: 'Filtre ve sıralama',
                onTap: () => open(() => workspaceQuery(context, ref, id)),
              ),
            ],
          ),
          const Gap(NizamioSpacing.space4),
          NzMenuGroup(
            rows: [
              NzMenuRow(
                icon: NzIcons.copy,
                label: 'Kopyala',
                onTap: () => open(
                  () =>
                      workspaceCopy(context, ref, id, onOpenTable: onOpenTable),
                ),
              ),
              if (owner)
                NzMenuRow(
                  icon: NzIcons.folderMove,
                  label: 'Taşı veya onaya gönder',
                  onTap: () => open(
                    () => workspaceTransfer(
                      context,
                      ref,
                      id,
                      onOpenTable: onOpenTable,
                    ),
                  ),
                ),
              if (owner)
                NzMenuRow(
                  icon: NzIcons.folder,
                  label: 'Klasör',
                  onTap: () => open(() => workspaceProject(context, ref, id)),
                ),
              if (owner)
                NzMenuRow(
                  icon: NzIcons.document,
                  label: data.template
                      ? 'Şablon işaretini kaldır'
                      : 'Şablon olarak işaretle',
                  onTap: () => open(
                    () => ref
                        .read(tableDetailProvider(id).notifier)
                        .send(SetTableTemplate(!data.template)),
                  ),
                ),
            ],
          ),
          const Gap(NizamioSpacing.space4),
          NzMenuGroup(
            rows: [
              NzMenuRow(
                icon: NzIcons.history,
                label: 'Bu oturumdaki değişiklikler',
                onTap: () => open(() => workspaceChanges(context, ref, id)),
              ),
              if (owner)
                NzMenuRow(
                  icon: NzIcons.delete,
                  label: 'Tabloyu sil',
                  danger: true,
                  onTap: () => open(() async {
                    final done = await workspaceConfirm(
                      context,
                      ref,
                      id,
                      title: 'Tabloyu sil',
                      message: 'Bu tabloya erişim kapanacak. Tabloyu silmek istediğine emin misin?',
                      edit: const DeleteTable(),
                    );
                    if (done && context.mounted) {
                      Navigator.of(context).maybePop();
                    }
                  }),
                ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> workspaceColumnOptions(
  BuildContext context,
  WidgetRef ref,
  String id,
  TableColumnState column,
) => workspaceColumnDetail(context, ref, id, column.field.id);

Future<void> workspaceQuery(
  BuildContext context,
  WidgetRef ref,
  String id,
) async {
  final state = ref.read(tableDetailProvider(id));
  final columns = state.data!.columns;
  if (columns.isEmpty) return;
  final filters = List<TableQueryFilter>.of(state.query.filters);
  final sorts = List<({String column, bool descending})>.of(state.query.sorts);
  await workspaceForm(
    context,
    ref,
    id,
    title: 'Filtre ve sıralama',
    save: 'Uygula',
    valid: () => filters.every(
      (f) =>
          f.operator == TableQueryOperator.empty ||
          (f.value != null && f.value.toString().isNotEmpty),
    ),
    fields: (context, update) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Filtreler', style: context.text.labelLg),
        for (var i = 0; i < filters.length; i++) ...[
          const Gap(NizamioSpacing.space3),
          NzSelect<String>(
            label: 'Sütun ${i + 1}',
            value: filters[i].column,
            items: [
              for (final c in columns)
                NzSelectItem(value: c.field.id, label: c.field.name),
            ],
            onChanged: (v) {
              if (v != null) {
                filters[i] = TableQueryFilter(
                  v,
                  tableQueryOperators(
                    columns.firstWhere((c) => c.field.id == v),
                  ).first,
                  null,
                );
                update();
              }
            },
          ),
          const Gap(NizamioSpacing.space2),
          NzSelect<TableQueryOperator>(
            label: 'Koşul',
            value: filters[i].operator,
            items: [
              for (final o in tableQueryOperators(
                columns.firstWhere((c) => c.field.id == filters[i].column),
              ))
                NzSelectItem(
                  value: o,
                  label: switch (o) {
                    TableQueryOperator.eq => 'Eşittir',
                    TableQueryOperator.ne => 'Eşit değildir',
                    TableQueryOperator.contains => 'İçerir',
                    TableQueryOperator.lt => 'Küçüktür',
                    TableQueryOperator.gt => 'Büyüktür',
                    TableQueryOperator.empty => 'Boş',
                  },
                ),
            ],
            onChanged: (v) {
              if (v != null) {
                filters[i] = TableQueryFilter(
                  filters[i].column,
                  v,
                  filters[i].value,
                );
                update();
              }
            },
          ),
          if (filters[i].operator != TableQueryOperator.empty) ...[
            const Gap(NizamioSpacing.space2),
            TableQueryValue(
              key: ValueKey(
                'filter-$i-${filters[i].column}-${filters[i].operator}',
              ),
              column: columns.firstWhere(
                (c) => c.field.id == filters[i].column,
              ),
              operator: filters[i].operator,
              value: filters[i].value,
              attachments: state.data!.attachments,
              department: state.data!.document.unit,
              onChanged: (v) {
                filters[i] = TableQueryFilter(
                  filters[i].column,
                  filters[i].operator,
                  v,
                );
                update();
              },
            ),
          ],
          NzButton.ghost(
            onPressed: () {
              filters.removeAt(i);
              update();
            },
            label: 'Filtreyi kaldır',
          ),
        ],
        if (filters.length < 3)
          NzButton.ghost(
            onPressed: () {
              filters.add(
                TableQueryFilter(
                  columns.first.field.id,
                  tableQueryOperators(columns.first).first,
                  null,
                ),
              );
              update();
            },
            label: 'Filtre ekle',
          ),
        const Gap(NizamioSpacing.space4),
        Text('Sıralama', style: context.text.labelLg),
        for (var i = 0; i < sorts.length; i++) ...[
          const Gap(NizamioSpacing.space3),
          NzSelect<String>(
            label: 'Sıralama ${i + 1}',
            value: sorts[i].column,
            items: [
              for (final c in columns)
                NzSelectItem(value: c.field.id, label: c.field.name),
            ],
            onChanged: (v) {
              if (v != null) {
                sorts[i] = (column: v, descending: sorts[i].descending);
                update();
              }
            },
          ),
          NzFormRows(
            rows: [
              NzFormRow.toggle(
                label: 'Azalan',
                value: sorts[i].descending,
                onChanged: (v) {
                  sorts[i] = (column: sorts[i].column, descending: v);
                  update();
                },
              ),
            ],
          ),
          NzButton.ghost(
            onPressed: () {
              sorts.removeAt(i);
              update();
            },
            label: 'Sıralamayı kaldır',
          ),
        ],
        if (sorts.length < 2 && sorts.length < columns.length)
          NzButton.ghost(
            onPressed: () {
              sorts.add((
                column: columns
                    .firstWhere(
                      (c) => !sorts.any((s) => s.column == c.field.id),
                    )
                    .field
                    .id,
                descending: false,
              ));
              update();
            },
            label: 'Sıralama ekle',
          ),
      ],
    ),
    submit: () async {
      await ref
          .read(tableDetailProvider(id).notifier)
          .query(
            TableReadQuery(
              filters: filters,
              sorts: sorts,
              limit: state.query.limit,
            ),
          );
      return ref.read(tableDetailProvider(id)).error == null;
    },
  );
}

Future<void> workspaceChanges(BuildContext context, WidgetRef ref, String id) =>
    showTableSheet(
      ref,
      context,
      tableId: id,
      title: 'Bu oturumdaki değişiklikler',
      description: 'Sunucu yalnız işlem türü ve sırasını paylaşır. Yazar ve eski hücre içeriği bu listede bulunmaz.',
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final changes = ref.watch(tableDetailProvider(id)).changes;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (changes.isEmpty) const Text('Henüz yeni değişiklik yok.'),
              for (final c in changes.reversed)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: NizamioSpacing.space2,
                  ),
                  child: Text(
                    '${c.sequence} · ${c.kind.replaceAll('_', ' ')}',
                    style: context.text.caption,
                  ),
                ),
            ],
          );
        },
      ),
    );
