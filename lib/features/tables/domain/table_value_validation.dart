import 'table_document.dart';
import 'table_workspace.dart';

enum TableValueIssue { email, phone, number, date }

/// Empty cells remain optional; formatting characters in phone numbers are retained.
TableValueIssue? tableValueIssue(TableFieldType type, Object? value) {
  if (value == null || value is String && value.trim().isEmpty) return null;
  final text = '$value'.trim();
  switch (type) {
    case TableFieldType.email:
      return RegExp(
                r'''^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,63}$''',
              ).hasMatch(text) &&
              !text.split('@').first.startsWith('.') &&
              !text.split('@').first.endsWith('.') &&
              !text.split('@').first.contains('..')
          ? null
          : TableValueIssue.email;
    case TableFieldType.phone:
      final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
      var depth = 0;
      var balanced = true;
      for (final rune in text.runes) {
        if (rune == 40) depth++;
        if (rune == 41) depth--;
        if (depth < 0 || depth > 1) balanced = false;
      }
      return RegExp(r'^\+?[0-9 ()-]+$').hasMatch(text) &&
              text.length <= 40 &&
              digits.length >= 7 &&
              digits.length <= 15 &&
              balanced &&
              depth == 0
          ? null
          : TableValueIssue.phone;
    case TableFieldType.number:
      return value is TableDecimal && value.valid
          ? null
          : TableValueIssue.number;
    case TableFieldType.date:
      final date = DateTime.tryParse(text);
      final normalized = date == null
          ? ''
          : '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return text == normalized ? null : TableValueIssue.date;
    default:
      return null;
  }
}

bool tableDraftValid(
  List<TableColumnState> columns,
  Map<TableFieldId, Object?> values,
) => values.entries.every((entry) {
  final column = columns
      .where((c) => c.field.id == entry.key.value)
      .firstOrNull;
  return column != null &&
      tableValueIssue(column.field.type, entry.value) == null;
});
