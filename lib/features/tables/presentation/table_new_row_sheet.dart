import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../tasks/tasks.dart';
import '../application/table_detail_controller.dart';
import '../application/table_new_row_job.dart';
import '../domain/table_document.dart';
import '../domain/table_value_validation.dart';
import 'table_draft_fields.dart';
import 'table_workspace_forms.dart';

Future<void> workspaceNewRow(
  BuildContext context,
  WidgetRef ref,
  String id,
) async {
  final controller = ref.read(tableDetailProvider(id).notifier);
  final data = ref.read(tableDetailProvider(id)).data!;
  final values = <TableFieldId, Object?>{};
  final files = <TableFieldId, UploadSource>{};
  await workspaceForm(
    context,
    ref,
    id,
    title: 'Yeni satır',
    description:
        '${data.document.title} · satır ${data.document.rows.length + 1}',
    save: 'Ekle',
    valid: () => tableDraftValid(data.columns, values),
    fields: (sheet, update) => TableDraftFields(
      id: id,
      data: data,
      values: values,
      attachments: {for (final e in files.entries) e.key: e.value.name},
      onChanged: (key, value) {
        values[key] = value;
        update();
      },
      onAttachment: (column) async {
        final picker = ref.read(uploadPickerProvider);
        if (!picker.available) throw ApiError('client.file_unreadable');
        final file = await picker.pick(UploadOrigin.files);
        if (file == null || !sheet.mounted) return;
        if (file.contentType == null) {
          throw ApiError('tables.attachment_rejected');
        }
        if (file.sizeBytes > 90 * 1024 * 1024) {
          throw ApiError('tables.attachment_too_large');
        }
        files[TableFieldId(column.field.id)] = file;
        update();
      },
    ),
    submit: () async {
      final job = TableNewRowJob(
        controller.repository,
        controller.location,
        id,
        values,
        files,
        isCurrent: controller.captureGuard(),
      );
      return await controller.perform(
            job.run,
            focusRow: true,
            retainOnError: () => job.started,
          ) !=
          null;
    },
  );
}
