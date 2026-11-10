import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/inputs/nz_check_circle.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../domain/table_document.dart';
import 'table_sheets.dart' show tableCellText;

/// Alanın türü yalnız başlıkta değil satır değerinde de görünür.
class TableCellValue extends StatelessWidget {
  const TableCellValue({
    super.key,
    required this.field,
    required this.value,
    required this.documents,
    this.onToggle,
  });
  final TableField field;
  final Object? value;
  final List<TableDocument> documents;
  final VoidCallback? onToggle;
  @override
  Widget build(BuildContext context) {
    final text = tableCellText(context, field, value, documents);
    if (field.type == TableFieldType.todo) {
      return Align(
        alignment: Alignment.centerLeft,
        child: NzCheckCircle(
          value: value == true,
          label: field.name,
          onChanged: onToggle,
        ),
      );
    }
    if (value == null || value == '') {
      return Text(
        '—',
        style: context.text.bodySm.copyWith(color: context.colors.textMuted),
      );
    }
    if (field.type == TableFieldType.person) {
      return Row(
        children: [
          NzAvatar.initials(
            name: text,
            extent: NzAvatarSize.sm,
            tone: NzAvatar.toneOf(text),
          ),
          const Gap(NizamioSpacing.space2),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodySm,
            ),
          ),
        ],
      );
    }
    if (field.type == TableFieldType.unit) {
      return Align(
        alignment: Alignment.centerLeft,
        child: NzBadge.neutral(
          label: text,
          leading: Icons.account_tree_outlined,
        ),
      );
    }
    if (field.type == TableFieldType.link) {
      return Align(
        alignment: Alignment.centerLeft,
        child: NzBadge.info(label: text, leading: Icons.link),
      );
    }
    if (field.type == TableFieldType.task) {
      return Align(
        alignment: Alignment.centerLeft,
        child: NzBadge.neutral(label: text, leading: Icons.task_alt),
      );
    }
    if (field.type == TableFieldType.file) {
      return Align(
        alignment: Alignment.centerLeft,
        child: NzBadge.neutral(label: text, leading: Icons.attach_file),
      );
    }
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: context.text.bodySm,
    );
  }
}
