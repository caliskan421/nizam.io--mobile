import 'package:flutter/material.dart';

import '../../../core/ui/widgets/inputs/inputs.dart';
import '../domain/table_document.dart';
import '../domain/table_workspace.dart';
import 'table_workspace_input.dart';

List<TableQueryOperator> tableQueryOperators(TableColumnState c) {
  if (c.field.type == TableFieldType.todo) {
    return const [TableQueryOperator.eq, TableQueryOperator.empty];
  }
  if (c.wireType.endsWith('_reference') || c.wireType == 'attachment') {
    return const [
      TableQueryOperator.eq,
      TableQueryOperator.contains,
      TableQueryOperator.empty,
    ];
  }
  return [
    TableQueryOperator.eq,
    TableQueryOperator.ne,
    TableQueryOperator.lt,
    TableQueryOperator.gt,
    if (c.field.type != TableFieldType.number) TableQueryOperator.contains,
    TableQueryOperator.empty,
  ];
}

class TableQueryValue extends StatelessWidget {
  const TableQueryValue({
    super.key,
    required this.column,
    required this.operator,
    required this.value,
    required this.onChanged,
    required this.attachments,
    required this.department,
  });
  final TableColumnState column;
  final TableQueryOperator operator;
  final Object? value;
  final ValueChanged<Object?> onChanged;
  final List<TableAttachment> attachments;
  final String department;
  @override
  Widget build(BuildContext context) {
    if (operator == TableQueryOperator.contains) {
      return NzTextField(
        pill: true,
        labelAbove: false,
        label: 'İçerdiği metin',
        initialValue: value?.toString() ?? '',
        onChanged: onChanged,
      );
    }
    if (column.wireType == 'attachment') {
      return NzSelect<String>(
        label: 'Dosya',
        value: value is String ? value! as String : null,
        items: [
          for (final a in attachments) NzSelectItem(value: a.id, label: a.name),
        ],
        onChanged: onChanged,
      );
    }
    return TableWorkspaceInput(
      column: TableColumnState(
        column.field,
        column.width,
        false,
        column.wireType,
      ),
      department: department,
      value: value,
      onChanged: onChanged,
    );
  }
}
