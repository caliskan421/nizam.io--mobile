import 'table_document.dart';
import 'tables_repository.dart';

sealed class TableEdit {
  const TableEdit();
}

class RenameTable extends TableEdit {
  const RenameTable(this.name);
  final String name;
}

class DeleteTable extends TableEdit {
  const DeleteTable();
}

class AddTableRow extends TableEdit {
  const AddTableRow();
}

class DeleteTableRow extends TableEdit {
  const DeleteTableRow(this.id);
  final String id;
}

class MoveTableRow extends TableEdit {
  const MoveTableRow(this.id, this.after);
  final String id;
  final String? after;
}

enum TableColumnAction { add, rename, resize, delete, move, convert }

class EditTableColumn extends TableEdit {
  const EditTableColumn(
    this.action,
    this.field,
    this.schema, {
    this.width = 180,
    this.multiple = false,
    this.fileReference = false,
    this.after,
  });
  final TableColumnAction action;
  final TableField field;
  final int schema;
  final int width;
  final bool multiple;
  final bool fileReference;
  final String? after;
}

class WriteTableCells extends TableEdit {
  const WriteTableCells(this.cells);
  final List<TableCellWrite> cells;
}

class TableCellWrite {
  const TableCellWrite(this.row, this.column, this.value, this.version);
  final String row;
  final String column;
  final Object? value;
  final int version;
}

class UndoTableCells extends TableEdit {
  const UndoTableCells(this.sequence);
  final int sequence;
}

class GrantTableAccess extends TableEdit {
  const GrantTableAccess(this.account, this.access);
  final String account;
  final TableAccess access;
}

class SetTableTeam extends TableEdit {
  const SetTableTeam(this.access);
  final TableAccess access;
}

class SetTableProject extends TableEdit {
  const SetTableProject(this.id);
  final String? id;
}

class SetTableTemplate extends TableEdit {
  const SetTableTemplate(this.enabled);
  final bool enabled;
}

enum TableTransferAction { move, proposeMove, proposeCopy, withdraw }

class TransferTable extends TableEdit {
  const TransferTable(
    this.action,
    this.target, {
    this.project,
    this.access = TableAccess.view,
  });
  final TableTransferAction action;
  final TableLocation target;
  final String? project;
  final TableAccess access;
}

enum TableCommentAction { add, edit, delete }

class EditTableComment extends TableEdit {
  const EditTableComment(
    this.action, {
    this.id,
    this.row,
    this.column,
    this.body = '',
  });
  final TableCommentAction action;
  final String? id;
  final String? row;
  final String? column;
  final String body;
}
