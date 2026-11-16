import 'table_document.dart';

/// Ondalık değer metni; hücre sayıları double'a çevrilmez.
class TableDecimal {
  const TableDecimal(this.value);
  final String value;
  bool get valid {
    if (value.length > 1000 ||
        !RegExp(r'^-?(?:0|[1-9][0-9]*)(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?$')
            .hasMatch(value)) {
      return false;
    }
    final exponent = value.toLowerCase().split('e');
    return exponent.length == 1 ||
        ((int.tryParse(exponent.last)?.abs() ?? 1001) <= 1000);
  }

  @override
  String toString() => value;
}

class TableCellState {
  const TableCellState({
    required this.row,
    required this.column,
    required this.value,
    required this.display,
    required this.version,
    this.redacted = false,
  });
  final String row;
  final String column;
  final Object? value;
  final String display;
  final int version;
  final bool redacted;
}

class TableColumnState {
  const TableColumnState(this.field, this.width, this.multiple, this.wireType);
  final TableField field;
  final int width;
  final bool multiple;
  final String wireType;
}

class TableWorkspace {
  const TableWorkspace({
    required this.document,
    required this.schema,
    required this.sequence,
    required this.columns,
    required this.cells,
    this.cursor,
    this.project,
    this.template = false,
    this.attachments = const [],
    this.linkedTables = const {},
  });
  final TableDocument document;
  final int schema;
  final int sequence;
  final List<TableColumnState> columns;
  final List<TableCellState> cells;
  final String? cursor;
  final String? project;
  final bool template;
  final List<TableAttachment> attachments;

  /// Names resolved by the backend for visible table references in this snapshot.
  final Map<TableDocumentId, String> linkedTables;
  TableCellState cell(String row, String column) =>
      cells.where((c) => c.row == row && c.column == column).firstOrNull ??
      TableCellState(
        row: row,
        column: column,
        value: null,
        display: '—',
        version: 0,
      );
}

class TableAttachment {
  const TableAttachment(this.id, this.name, this.mediaType, this.bytes);
  final String id;
  final String name;
  final String mediaType;
  final int bytes;
}

class TableCommentEntry {
  const TableCommentEntry({
    required this.id,
    required this.row,
    required this.column,
    required this.author,
    required this.mine,
    required this.body,
    required this.created,
    required this.edited,
  });
  final String id;
  final String row;
  final String? column;
  final String? author;
  final bool mine;
  final String body;
  final DateTime created;
  final DateTime? edited;
}

class TablePageSlice<T> {
  const TablePageSlice(this.items, this.cursor);
  final List<T> items;
  final String? cursor;
}

class TableProjectEntry {
  const TableProjectEntry(this.id, this.name);
  final String id;
  final String name;
}

class TableProposalEntry {
  const TableProposalEntry({
    required this.id,
    required this.title,
    required this.kind,
    required this.status,
    required this.rows,
    required this.columns,
    required this.proposer,
    required this.created,
  });
  final String id;
  final String title;
  final String kind;
  final String status;
  final int rows;
  final List<String> columns;
  final String proposer;
  final DateTime created;
}

class TableOperationReceipt {
  const TableOperationReceipt({
    required this.table,
    required this.sequence,
    required this.schema,
    this.id,
    this.skipped = 0,
    this.rowSequence,
    this.skippedCells = const [],
  });
  final String table;
  final int sequence;
  final int schema;
  final String? id;
  final int skipped;
  final int? rowSequence;
  final List<TableSkippedCellInfo> skippedCells;
}

class TableSkippedCellInfo {
  const TableSkippedCellInfo(this.row, this.column, this.reason);
  final String row;
  final String column;
  final String reason;
}

class TableChangeEntry {
  const TableChangeEntry(this.sequence, this.kind);
  final int sequence;
  final String kind;
}

class TableChangePage {
  const TableChangePage(this.items, this.cursor, this.sequence, this.more);
  final List<TableChangeEntry> items;
  final int cursor;
  final int sequence;
  final bool more;
}

class TableParticipant {
  const TableParticipant(
    this.key,
    this.account,
    this.name,
    this.row,
    this.column,
  );
  final String key;
  final String account;
  final String name;
  final String? row;
  final String? column;
}

class TableLiveEvent {
  const TableLiveEvent(this.sequence, [this.participants]);
  final int? sequence;
  final List<TableParticipant>? participants;
}

enum TableQueryOperator { eq, ne, contains, lt, gt, empty }

class TableQueryFilter {
  const TableQueryFilter(this.column, this.operator, [this.value]);
  final String column;
  final TableQueryOperator operator;
  final Object? value;
}

class TableReadQuery {
  const TableReadQuery({
    this.filters = const [],
    this.sorts = const [],
    this.cursor,
    this.limit = 100,
  });
  final List<TableQueryFilter> filters;
  final List<({String column, bool descending})> sorts;
  final String? cursor;
  final int limit;
}
