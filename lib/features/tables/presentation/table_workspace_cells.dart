import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/table_detail_controller.dart';
import '../domain/table_edit.dart';
import 'table_sheet_host.dart';
import 'table_workspace_attachments.dart';
import 'table_workspace_comments.dart';
import 'table_workspace_forms.dart';
import 'table_workspace_row_form.dart';

Future<void> workspaceCell(
  BuildContext context,
  WidgetRef ref,
  String id,
  String row,
  String column,
) async {
  final data = ref.read(tableDetailProvider(id)).data;
  if (data == null) return;
  final field = data.columns.where((c) => c.field.id == column).firstOrNull;
  if (field == null) return;
  if (field.wireType == 'attachment') {
    return workspaceAttachment(context, ref, id, row, column);
  }
  await workspaceRowForm(context, ref, id, row, column: column);
}

Future<void> workspaceRow(
  BuildContext context,
  WidgetRef ref,
  String id,
  String row,
) async {
  final data = ref.read(tableDetailProvider(id)).data;
  if (data == null) return;
  if (!data.document.rows.any((r) => r.id == row)) return;
  final index = data.document.rows.indexWhere((r) => r.id == row);
  await showTableSheet(
    ref,
    context,
    tableId: id,
    title: 'Satır ${index + 1}',
    builder: (sheet) => NzMenuGroup(
      rows: [
        NzMenuRow(
          icon: NzIcons.edit,
          label: 'Satırı düzenle',
          onTap: () {
            Navigator.of(sheet).pop();
            workspaceRowForm(context, ref, id, row);
          },
        ),
        for (final column in data.columns)
          NzMenuRow(
            icon: NzIcons.edit,
            label: column.field.name,
            trailing: Flexible(
              child: Text(
                data.cell(row, column.field.id).display,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.caption,
              ),
            ),
            onTap: () {
              Navigator.of(sheet).pop();
              workspaceCell(context, ref, id, row, column.field.id);
            },
          ),
        NzMenuRow(
          icon: NzIcons.messages,
          label: 'Satır yorumları',
          onTap: () {
            Navigator.of(sheet).pop();
            workspaceComments(context, ref, id, row: row);
          },
        ),
        if (index > 0)
          NzMenuRow(
            icon: NzIcons.arrowUp,
            label: 'Bir satır yukarı taşı',
            onTap: () {
              Navigator.of(sheet).pop();
              ref
                  .read(tableDetailProvider(id).notifier)
                  .send(
                    MoveTableRow(
                      row,
                      index > 1 ? data.document.rows[index - 2].id : null,
                    ),
                  );
            },
          ),
        if (index < data.document.rows.length - 1)
          NzMenuRow(
            icon: NzIcons.arrowDown,
            label: 'Bir satır aşağı taşı',
            onTap: () {
              Navigator.of(sheet).pop();
              ref
                  .read(tableDetailProvider(id).notifier)
                  .send(MoveTableRow(row, data.document.rows[index + 1].id));
            },
          ),
        NzMenuRow(
          icon: NzIcons.delete,
          label: 'Satırı sil',
          danger: true,
          onTap: () {
            Navigator.of(sheet).pop();
            workspaceConfirm(
              context,
              ref,
              id,
              title: 'Satırı sil',
              message: 'Bu satır, hücreleri ve yorumları silinecek.',
              edit: DeleteTableRow(row),
            );
          },
        ),
      ],
    ),
  );
}
