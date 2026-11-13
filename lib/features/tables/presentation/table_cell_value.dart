import 'package:flutter/material.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/inputs/nz_check_circle.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/table_view.dart';
import '../domain/table_models.dart';
import 'table_texts.dart';

/// Izgarada hücre gösterimi. Onay kutusu doğrudan değiştirilebilir ([onToggle]).
class TableCellValue extends StatelessWidget {
  const TableCellValue({
    super.key,
    required this.view,
    required this.column,
    required this.data,
    this.onToggle,
  });
  final TableView view;
  final TableColumnSpec column;
  final TableCellData data;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (column.kind == TableColumnKind.checkbox) {
      return Align(
        alignment: Alignment.centerLeft,
        child: NzCheckCircle(
          value: data.value == true,
          label: column.name,
          onChanged: onToggle,
        ),
      );
    }
    final text = l.tableCellText(view, column, data);
    if (data.isEmpty && !data.redacted) {
      return Text(
        text,
        style: context.text.bodySm.copyWith(color: context.colors.textMuted),
      );
    }
    final icon = switch (column.kind) {
      TableColumnKind.personReference => Icons.person_outline,
      TableColumnKind.departmentReference => Icons.account_tree_outlined,
      TableColumnKind.taskReference => Icons.task_alt,
      TableColumnKind.fileReference => Icons.description_outlined,
      TableColumnKind.tableReference => Icons.link,
      TableColumnKind.attachment => Icons.attach_file,
      _ => null,
    };
    if (icon != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: NzBadge.neutral(label: text, leading: icon),
      );
    }
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.text.bodySm,
    );
  }
}
