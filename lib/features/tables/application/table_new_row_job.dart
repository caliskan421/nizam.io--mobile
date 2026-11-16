import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../tasks/tasks.dart';
import '../domain/table_document.dart';
import '../domain/table_edit.dart';
import '../domain/table_workspace.dart';
import '../domain/tables_repository.dart';
import 'table_attachment_flow.dart';

/// Created only when Add is pressed. Each confirmed step advances once; uncertain
/// steps keep their own key even after the sheet closes and retry moves to the page.
class TableNewRowJob {
  TableNewRowJob(
    this.repository,
    this.location,
    this.table,
    Map<TableFieldId, Object?> values,
    Map<TableFieldId, UploadSource> files, {
    this.isCurrent,
  }) : values = Map.unmodifiable(values),
       files = Map.unmodifiable(files);
  final bool Function()? isCurrent;
  bool get started => _created != null;
  void _guard() {
    if (isCurrent?.call() == false) throw ApiError('client.scope_changed');
  }

  final TablesRepository repository;
  final TableLocation location;
  final String table;
  final Map<TableFieldId, Object?> values;
  final Map<TableFieldId, UploadSource> files;
  final _addKey = newRequestKey();
  final _cellsKey = newRequestKey();
  final _uploadKeys = <TableFieldId, String>{};
  TableOperationReceipt? _created;
  bool _cellsSaved = false;
  int _uploaded = 0;
  Future<TableOperationReceipt> run(String _) async {
    _guard();
    _created ??= await repository.execute(
      location,
      table,
      const AddTableRow(),
      _addKey,
    );
    final row = _created!.id;
    if (row == null || row.isEmpty) throw invalidResponseError();
    var result = _created!;
    if (!_cellsSaved && values.isNotEmpty) {
      _guard();
      result = await repository.execute(
        location,
        table,
        WriteTableCells([
          for (final v in values.entries)
            TableCellWrite(row, v.key.value, v.value, 0),
        ]),
        _cellsKey,
      );
      _cellsSaved = true;
    }
    final entries = files.entries.toList();
    while (_uploaded < entries.length) {
      _guard();
      final file = entries[_uploaded];
      result = await uploadTableSource(
        repository,
        location,
        table,
        row,
        file.key.value,
        0,
        file.value,
        _uploadKeys.putIfAbsent(file.key, newRequestKey),
      );
      _uploaded++;
    }
    return TableOperationReceipt(
      table: table,
      sequence: result.sequence,
      schema: result.schema,
      id: row,
      rowSequence: _created!.sequence,
    );
  }
}
