import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../application/table_detail_controller.dart';
import '../domain/table_document.dart';
import '../domain/table_edit.dart';
import '../domain/table_value_validation.dart';
import '../domain/table_workspace.dart';
import 'table_choice_row.dart';
import 'table_draft_fields.dart';
import 'table_linked_targets.dart';
import 'table_workspace_attachments.dart';
import 'table_workspace_comments.dart';
import 'table_workspace_forms.dart';
import 'table_workspace_input.dart';

/// Yalnız dokunulan hücreleri tek atomik batch ile yazar; hiç açılmamış
/// referansları ya da başka kullanıcının hücrelerini geri yazmaz.
Future<void> workspaceRowForm(
  BuildContext context,
  WidgetRef ref,
  String id,
  String row, {
  String? column,
}) async {
  final controller = ref.read(tableDetailProvider(id).notifier);
  final initial = ref.read(tableDetailProvider(id)).data!;
  final columns = column == null
      ? initial.columns
      : initial.columns.where((c) => c.field.id == column).toList();
  if (columns.isEmpty) return;
  await controller.select(row, columns.first.field.id);
  if (!context.mounted) return;
  final changes = <TableFieldId, Object?>{};
  final versions = <TableFieldId, int>{
    for (final c in initial.columns)
      TableFieldId(c.field.id): initial.cell(row, c.field.id).version,
  };
  TableWorkspace? latest;
  var conflictAck = false;
  var redactedAck = false;
  bool lostColumn = false;
  String? openTable;
  bool hidden() => changes.keys.any((c) => initial.cell(row, c.value).redacted);
  await workspaceForm(
    context,
    ref,
    id,
    title: column == null ? 'Satırı düzenle' : columns.first.field.name,
    description: column == null ? initial.document.title : null,
    valid: () =>
        changes.isNotEmpty &&
        tableDraftValid(columns, changes) &&
        !lostColumn &&
        (!hidden() || redactedAck) &&
        (latest == null || conflictAck),
    fields: (context, update) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (column != null && columns.first.field.type == TableFieldType.link)
          TableLinkedTargets(
            id: id,
            row: row,
            column: column,
            onOpen: (target) {
              openTable = target;
              Navigator.of(context).pop();
            },
          ),
        if (column != null)
          TableWorkspaceInput(
            column: columns.first,
            department: initial.document.unit,
            value: changes.containsKey(TableFieldId(column))
                ? changes[TableFieldId(column)]
                : initial.cell(row, column).value,
            onChanged: (v) {
              changes[TableFieldId(column)] = v;
              update();
            },
          ),
        if (column == null)
          TableDraftFields(
            id: id,
            data: initial,
            values: {
              for (final c in initial.columns)
                TableFieldId(c.field.id): initial.cell(row, c.field.id).value,
              ...changes,
            },
            onChanged: (key, value) {
              changes[key] = value;
              update();
            },
            onAttachment: (c) =>
                workspaceAttachment(context, ref, id, row, c.field.id),
          ),
        if (column != null) ...[
          const Gap(NizamioSpacing.space3),
          NzButton.ghost(
            label: 'Hücre yorumları',
            onPressed: () =>
                workspaceComments(context, ref, id, row: row, column: column),
          ),
        ],
        if (hidden()) ...[
          const Gap(NizamioSpacing.space3),
          TableChoiceRow(
            label: 'Gizli seçim içeren değiştirdiğim hücrelerin tamamını yeni seçimlerimle değiştir',
            value: redactedAck,
            onChanged: (v) {
              redactedAck = v;
              update();
            },
          ),
        ],
        if (ref.read(tableDetailProvider(id)).error?.code ==
            'tables.cell_conflict')
          NzButton.ghost(
            onPressed: () async {
              await controller.refresh();
              if (!context.mounted) return;
              latest = ref.read(tableDetailProvider(id)).data;
              if (latest == null) return;
              for (final c in changes.keys) {
                final before = initial.columns
                    .where((f) => f.field.id == c.value)
                    .firstOrNull;
                final after = latest!.columns
                    .where((f) => f.field.id == c.value)
                    .firstOrNull;
                if (before == null ||
                    after == null ||
                    before.wireType != after.wireType ||
                    before.multiple != after.multiple) {
                  lostColumn = true;
                  continue;
                }
                versions[c] = latest!.cell(row, c.value).version;
              }
              conflictAck = false;
              update();
            },
            label: 'Güncel hücreleri karşılaştır',
          ),
        if (latest != null) ...[
          const Gap(NizamioSpacing.space3),
          Text('Sunucudaki güncel değerler', style: context.text.labelMd),
          for (final c in initial.columns.where(
            (c) => changes.containsKey(TableFieldId(c.field.id)),
          ))
            Text(
              '${c.field.name}: ${latest!.cell(row, c.field.id).display}',
              style: context.text.caption,
            ),
          if (lostColumn)
            const Text(
              'Bir sütun silinmiş veya türü değişmiş. Bu taslak uygulanamaz; satırı yeniden aç.',
            ),
          if (!lostColumn)
            TableChoiceRow(
              label:
                  'Güncel değerlerin yerine taslağımdaki değişiklikleri kaydet',
              value: conflictAck,
              onChanged: (v) {
                conflictAck = v;
                update();
              },
            ),
        ],
      ],
    ),
    submit: () async =>
        await controller.send(
          WriteTableCells([
            for (final c in changes.entries)
              TableCellWrite(row, c.key.value, c.value, versions[c.key]!),
          ]),
        ) !=
        null,
  );
  if (context.mounted) await controller.select(null, null);
  if (context.mounted && openTable != null) {
    context.appNav.openLinkedTable(openTable!);
  }
}
