import 'package:flutter/material.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../domain/table_document.dart';
import 'table_sheets.dart' show tableCellText;

class TableCellEditor extends StatelessWidget {
  const TableCellEditor({
    super.key,
    required this.field,
    required this.value,
    required this.editable,
    required this.onChanged,
    required this.documents,
    this.onOpenTable,
    this.onOpenRow,
  });
  final TableField field;
  final Object? value;
  final bool editable;
  final ValueChanged<Object> onChanged;
  final List<TableDocument> documents;
  final ValueChanged<String>? onOpenTable;
  final void Function(String, String)? onOpenRow;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = field;
    if (f.type == TableFieldType.todo) {
      return SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(f.name),
        value: value == true,
        onChanged: editable ? onChanged : null,
      );
    }
    if (f.type == TableFieldType.person ||
        f.type == TableFieldType.unit ||
        f.type == TableFieldType.task) {
      final pool = switch (f.type) {
        TableFieldType.person => ['demo-1', 'demo-2', 'demo-3', 'demo-4'],
        TableFieldType.unit => tableDemoUnits,
        _ => ['demo-task-1', 'demo-task-2', 'demo-task-3'],
      };
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(f.name, style: context.text.labelMd),
          Wrap(
            spacing: NizamioSpacing.space2,
            children: [
              for (final v in pool)
                ChoiceChip(
                  label: Text(tableCellText(context, f, v)),
                  selected: value == v,
                  onSelected: editable
                      ? (_) => onChanged(value == v ? '' : v)
                      : null,
                ),
            ],
          ),
        ],
      );
    }
    if (f.type == TableFieldType.link) {
      final target = documents.where((d) => d.id == f.target).firstOrNull;
      final selected = value is List<Object>
          ? value as List<Object>
          : const <Object>[];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(f.name, style: context.text.labelMd),
          if (target != null) ...[
            TextButton(
              onPressed: onOpenTable == null
                  ? null
                  : () => onOpenTable!(target.id),
              child: Text(target.title),
            ),
            for (final row in target.rows)
              CheckboxListTile(
                secondary: IconButton(
                  tooltip: l.uiTablesEditRow,
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () => onOpenRow?.call(target.id, row.id),
                ),
                contentPadding: EdgeInsets.zero,
                title: Text(
                  target.fields.isEmpty
                      ? row.id
                      : tableCellText(
                          context,
                          target.fields.first,
                          row.cells[TableFieldId(target.fields.first.id)],
                        ),
                ),
                value: selected.contains(row.id),
                onChanged: editable
                    ? (v) => onChanged(
                        v == true
                            ? [...selected, row.id]
                            : selected.where((id) => id != row.id).toList(),
                      )
                    : null,
              ),
          ] else
            Text(l.uiTablesTableMissing),
        ],
      );
    }
    if (f.type == TableFieldType.file) {
      final files = value is List<Object>
          ? value as List<Object>
          : const <Object>[];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(f.name, style: context.text.labelMd),
          for (final file in files)
            ListTile(
              title: Text('$file'),
              trailing: editable
                  ? IconButton(
                      tooltip: l.uiTablesDelete,
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          onChanged(files.where((f) => f != file).toList()),
                    )
                  : null,
            ),
          if (editable)
            NzButton.secondary(
              label: l.uiTablesAttachment,
              onPressed: () =>
                  onChanged([...files, 'demo-${files.length + 1}.txt']),
            ),
        ],
      );
    }
    if (f.type == TableFieldType.date) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(f.name, style: context.text.labelMd),
          NzButton.secondary(
            label: value == null || value == '' ? l.uiTablesDate : '$value',
            onPressed: editable
                ? () async {
                    final initial =
                        DateTime.tryParse('$value') ?? DateTime(2026, 11, 9);
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      onChanged(picked.toIso8601String().substring(0, 10));
                    }
                  }
                : null,
          ),
          if (editable)
            NzButton.ghost(
              label: l.uiTablesClear,
              onPressed: () => onChanged(''),
            ),
        ],
      );
    }
    if (f.type == TableFieldType.number) {
      return NzTextField.number(
        label: f.name,
        initialValue: value == null ? '' : '$value',
        enabled: editable,
        onChanged: (v) => onChanged(num.tryParse(v) ?? ''),
      );
    }
    if (f.type == TableFieldType.email) {
      return NzTextField.email(
        label: f.name,
        initialValue: value == null ? '' : '$value',
        enabled: editable,
        onChanged: onChanged,
      );
    }
    return NzTextField(
      label: f.name,
      initialValue: value == null ? '' : '$value',
      enabled: editable,
      onChanged: onChanged,
    );
  }
}
