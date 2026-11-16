import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../tasks/tasks.dart';
import '../application/table_attachment_flow.dart';
import '../application/table_detail_controller.dart';
import '../domain/table_edit.dart';
import 'table_sheet_host.dart';
import 'table_workspace_forms.dart';

Future<void> workspaceAttachment(
  BuildContext context,
  WidgetRef ref,
  String id,
  String row,
  String column,
) => showTableSheet(
  ref,
  context,
  tableId: id,
  title: 'Dosya eki',
  builder: (sheet) => Consumer(
    builder: (context, ref, _) {
      final state = ref.watch(tableDetailProvider(id));
      final data = state.data;
      if (data == null) return const SizedBox.shrink();
      final cell = data.cell(row, column);
      final attachment = data.attachments
          .where((a) => a.id == cell.value)
          .firstOrNull;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(attachment?.name ?? 'Bu hücrede dosya yok.'),
          if (attachment != null) ...[
            const Gap(NizamioSpacing.space2),
            Text('${(attachment.bytes / 1024).ceil()} KB'),
            NzButton.ghost(
              label: 'İndir',
              onPressed: () async {
                final session = ref.read(sessionGenerationProvider);
                final scope = ref.read(scopeStateProvider);
                final controller = ref.read(tableDetailProvider(id).notifier);
                final sink = ref.read(downloadSinkProvider);
                try {
                  final bytes = await controller.repository.download(
                    controller.location,
                    id,
                    attachment.id,
                  );
                  if (!context.mounted ||
                      ref.read(sessionGenerationProvider) != session ||
                      ref.read(scopeStateProvider) != scope) {
                    return;
                  }
                  await sink.save(attachment.name, bytes);
                  if (context.mounted) {
                    NzToast.show(context, 'Dosya kaydedildi.');
                  }
                } on Object catch (e, st) {
                  reportUnexpected(e, st, source: ReportSource.ui);
                  if (context.mounted) NzToast.error(context, toApiError(e));
                }
              },
            ),
            NzButton.ghost(
              label: 'Eki kaldır',
              onPressed: state.busy || state.pending
                  ? null
                  : () => workspaceConfirm(
                      context,
                      ref,
                      id,
                      title: 'Eki kaldır',
                      message: 'Dosyanın bu hücredeki bağlantısı kaldırılacak.',
                      edit: WriteTableCells([
                        TableCellWrite(row, column, null, cell.version),
                      ]),
                    ),
            ),
          ],
          const Gap(NizamioSpacing.space3),
          NzButton.primary(
            label: attachment == null ? 'Dosya seç' : 'Dosyayı değiştir',
            onPressed: state.busy || state.pending
                ? null
                : () async {
                    try {
                      await uploadWorkspaceAttachment(ref, id, row, column);
                    } on Object catch (e, st) {
                      reportUnexpected(e, st, source: ReportSource.ui);
                      if (context.mounted) {
                        NzToast.error(context, toApiError(e));
                      }
                    }
                  },
          ),
        ],
      );
    },
  ),
);
