import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../application/table_detail_controller.dart';
import '../domain/table_workspace.dart';
import 'table_sheet_host.dart';

Future<void> workspaceUndoSkipped(
  BuildContext context,
  WidgetRef ref,
  String id,
  TableOperationReceipt receipt,
) => showTableSheet(
  ref,
  context,
  tableId: id,
  title: 'Korunan hücreler',
  description: 'Geri alma bu hücreleri değiştirmedi.',
  builder: (context) {
    final data = ref.read(tableDetailProvider(id)).data;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final cell in receipt.skippedCells) ...[
          const Gap(NizamioSpacing.space3),
          Text(
            data?.columns
                    .where((c) => c.field.id == cell.column)
                    .firstOrNull
                    ?.field
                    .name ??
                'Sütun',
            style: context.text.labelMd,
          ),
          Text(switch (cell.reason) {
            'gone' => 'Satır veya sütun kaldırılmış.',
            'changed' => 'Hücre daha sonra değiştirilmiş.',
            _ => 'Önceki değer artık kullanılamıyor.',
          }, style: context.text.caption),
        ],
      ],
    );
  },
);
