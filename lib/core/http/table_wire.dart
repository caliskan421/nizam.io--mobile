import 'package:dio/dio.dart';

import '../api/generated/models/table.dart' as api;
import '../api/generated/models/table_column.dart';
import '../api/generated/models/table_result.dart';
import '../errors/api_error.dart';

/// Üretilmiş istemci metaverisi; istek gövdesi değildir.
typedef TableApiExtras = Map<String, dynamic>;

class TablePreviewCell {
  const TablePreviewCell(this.rowId, this.columnId, this.value);
  final String rowId;
  final String columnId;
  final Object? value;
}

/// TableCellValue'nin scalar JSON desteği gelene kadar dar okuma uyarlaması.
/// Kullanıcıya yalnız yan haritadaki görünür referans adları verilir.
class TablePreviewColumn {
  const TablePreviewColumn(this.id, this.name, this.type);
  final String id;
  final String name;
  final String? type;
}

class TableWirePreview {
  TableWirePreview(Map<String, dynamic> data) {
    final table = api.Table.fromJson(
      Map<String, Object?>.from(data['table'] as Map),
    );
    id = table.id;
    ownerId = table.ownerId;
    name = table.name;
    programId = table.programId;
    departmentId = table.departmentId;
    space = table.space.json;
    teamRole = table.teamRole?.json;
    columns = [
      for (final c in (data['columns'] as List).cast<Map<String, dynamic>>())
        if (TableColumn.fromJson(c) case final column)
          TablePreviewColumn(column.id, column.name, column.type.json),
    ];
    rowIds = [
      for (final r in (data['rows'] as List).cast<Map<String, dynamic>>())
        r['id'] as String,
    ];
    hasMore = (data['next_cursor'] as String?)?.isNotEmpty ?? false;
    final references = data['references'] as Map<String, dynamic>? ?? {};
    for (final c in (data['cells'] as List).cast<Map<String, dynamic>>()) {
      final column = columns.where((f) => f.id == c['column_id']).firstOrNull;
      final type = column?.type;
      if (type == null) continue;
      final group = switch (type) {
        'person_reference' => 'people',
        'department_reference' => 'departments',
        'task_reference' => 'tasks',
        'file_reference' => 'files',
        'table_reference' => 'tables',
        _ => '',
      };
      final labels = references[group] as Map<String, dynamic>?;
      Object? display(Object? value) => value == null
          ? null
          : group.isNotEmpty
          ? (labels?[value] as String?) ?? '—'
          : type == 'attachment'
          ? 'Dosya'
          : value;
      final value = c['value'];
      if (value != null &&
          value is! String &&
          value is! num &&
          value is! bool &&
          value is! List) {
        throw invalidResponseError();
      }
      if (value is List &&
          (group.isEmpty || value.any((v) => v != null && v is! String))) {
        throw invalidResponseError();
      }
      final displayed = value is List
          ? value.map((v) => display(v) ?? '—').join(' · ')
          : display(value);
      cells.add(
        TablePreviewCell(
          c['row_id'] as String,
          c['column_id'] as String,
          displayed,
        ),
      );
    }
  }
  late final String id;
  late final String ownerId;
  late final String name;
  late final String programId;
  late final String departmentId;
  late final String? space;
  late final String? teamRole;
  late final List<TablePreviewColumn> columns;
  late final List<String> rowIds;
  late final bool hasMore;
  final cells = <TablePreviewCell>[];
}

Future<TableWirePreview> getTableWirePreview(
  Dio dio, {
  required String id,
  required bool personal,
  required TableApiExtras extras,
}) => apiCall(() async {
  final response = await dio.get<Map<String, dynamic>>(
    personal
        ? '/v1/personal/tables/${Uri.encodeComponent(id)}'
        : '/v1/tables/${Uri.encodeComponent(id)}',
    queryParameters: {'limit': 200},
    options: Options(extra: extras),
  );
  return TableWirePreview(response.data!);
});

class TableWireReceipt {
  const TableWireReceipt(this.tableId, this.schemaVersion);
  final String tableId;
  final int schemaVersion;
}

class TableWireCommand {
  TableWireCommand.fromGeneratedJson(Map<String, dynamic> body)
    : _body = Map<String, dynamic>.of(body)
        ..removeWhere((key, value) => value == null);
  final Map<String, dynamic> _body;
}

/// TableCommand union'ın isteğe bağlı alanlarını null yerine atlar. API bu
/// alanların verilmemesini ister; değer ve zorunlu alanlar DTO'dan aynen kalır.
Future<TableWireReceipt> postTableWireCommand(
  Dio dio, {
  required String id,
  required bool personal,
  required String key,
  required TableWireCommand command,
  required TableApiExtras extras,
}) => apiCall(() async {
  final response = await dio.post<Map<String, dynamic>>(
    personal
        ? '/v1/personal/tables/${Uri.encodeComponent(id)}/operations'
        : '/v1/tables/${Uri.encodeComponent(id)}/operations',
    data: command._body,
    options: Options(headers: {'Idempotency-Key': key}, extra: extras),
  );
  final result = TableResult.fromJson(response.data!);
  if (result.tableId != id) throw invalidResponseError();
  return TableWireReceipt(result.tableId, result.schemaVersion);
});
