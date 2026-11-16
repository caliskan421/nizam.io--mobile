import 'package:dio/dio.dart';

import '../api/generated/models/table.dart' as api;
import '../api/generated/models/table_column.dart';
import '../api/generated/models/table_result.dart';
import '../api/generated/models/table_skipped_cell.dart';
import '../errors/api_error.dart';
import 'table_numbers.dart';

/// Üretilmiş istemci metaverisi; istek gövdesi değildir.
typedef TableApiExtras = Map<String, dynamic>;

class TablePreviewCell {
  const TablePreviewCell(
    this.rowId,
    this.columnId,
    this.value, {
    this.raw,
    this.version = 0,
    this.redacted = false,
  });
  final String rowId;
  final String columnId;
  final Object? value;
  final Object? raw;
  final int version;
  final bool redacted;
}

/// TableCellValue'nin scalar JSON desteği gelene kadar dar okuma uyarlaması.
/// Kullanıcıya yalnız yan haritadaki görünür referans adları verilir.
class TablePreviewColumn {
  const TablePreviewColumn(
    this.id,
    this.name,
    this.type, {
    this.width = 180,
    this.multiple = false,
  });
  final String id;
  final String name;
  final String? type;
  final int width;
  final bool multiple;
}

class TableWirePreview {
  TableWirePreview(Map<String, dynamic> data, {List<dynamic>? exactCells}) {
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
    schema = table.schemaVersion;
    sequence = table.sequence;
    project = table.projectId;
    template = table.isTemplate ?? false;
    columns = [
      for (final c in (data['columns'] as List).cast<Map<String, dynamic>>())
        if (TableColumn.fromJson(c) case final column)
          TablePreviewColumn(
            column.id,
            column.name,
            column.type.json,
            width: column.width,
            multiple: column.multiple,
          ),
    ];
    rowIds = [
      for (final r in (data['rows'] as List).cast<Map<String, dynamic>>())
        r['id'] as String,
    ];
    hasMore = (data['next_cursor'] as String?)?.isNotEmpty ?? false;
    cursor = data['next_cursor'] as String?;
    attachments = [
      for (final a
          in (data['attachments'] as Map<String, dynamic>? ?? {}).values
              .cast<Map<String, dynamic>>())
        TableWireAttachment(
          a['id'] as String,
          a['name'] as String,
          a['content_type'] as String,
          a['size_bytes'] as int,
        ),
    ];
    final references = data['references'] as Map<String, dynamic>? ?? {};
    tableReferences.addAll(
      Map<String, String>.from(references['tables'] as Map? ?? const {}),
    );
    final dataCells = (data['cells'] as List).cast<Map<String, dynamic>>();
    for (var index = 0; index < dataCells.length; index++) {
      final c = dataCells[index];
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
          ? attachments.where((a) => a.id == value).firstOrNull?.name ?? '—'
          : type == 'checkbox'
          ? value == true
                ? '✓'
                : '—'
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
      final raw = exactCells == null
          ? value
          : (exactCells[index] as Map)['value'];
      final displayed = raw is TableWireNumber
          ? raw.text
          : value is List
          ? value.map((v) => display(v) ?? '—').join(' · ')
          : display(value);
      cells.add(
        TablePreviewCell(
          c['row_id'] as String,
          c['column_id'] as String,
          displayed,
          raw: raw,
          version: c['version'] as int? ?? 0,
          redacted: c['redacted'] == true,
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
  late final int schema;
  late final int sequence;
  late final String? project;
  late final bool template;
  late final String? cursor;
  late final List<TableWireAttachment> attachments;
  late final List<TablePreviewColumn> columns;
  late final List<String> rowIds;
  late final bool hasMore;
  final tableReferences = <String, String>{};
  final cells = <TablePreviewCell>[];
}

class TableWireAttachment {
  const TableWireAttachment(this.id, this.name, this.type, this.size);
  final String id;
  final String name;
  final String type;
  final int size;
}

Future<TableWirePreview> getTableWorkspaceWire(
  Dio dio, {
  required String path,
  required TableApiExtras extras,
  String? cursor,
  List<String> filters = const [],
  List<String> sorts = const [],
  int limit = 100,
}) => apiCall(() async {
  final response = await dio.get<String>(
    path,
    queryParameters: {
      'limit': limit,
      'cursor': ?cursor,
      if (filters.isNotEmpty) 'filter': filters,
      if (sorts.isNotEmpty) 'sort': sorts,
    },
    options: Options(
      extra: extras,
      responseType: ResponseType.plain,
      listFormat: ListFormat.multi,
    ),
  );
  final exact = decodeTableNumbers(response.data!) as Map<String, dynamic>;
  return TableWirePreview(
    tableOrdinaryNumbers(exact) as Map<String, dynamic>,
    exactCells: exact['cells'] as List,
  );
});

class TableWireReceipt {
  const TableWireReceipt(
    this.tableId,
    this.schemaVersion, {
    this.sequence = 0,
    this.id,
    this.skipped = 0,
    this.skippedCells = const [],
  });
  final String tableId;
  final int schemaVersion;
  final int sequence;
  final String? id;
  final int skipped;
  final List<({String row, String column, String reason})> skippedCells;
}

class TableWireCommand {
  TableWireCommand.fromGeneratedJson(Map<String, dynamic> body)
    : _body = Map<String, dynamic>.of(body)
        ..removeWhere((key, value) => value == null);
  TableWireCommand.cells(
    List<({String row, String column, Object? value, int version})> cells,
  ) : _body =
          '{"kind":"set_cells","cells":[${cells.map((c) => '{"row_id":${encodeTableValue(c.row)},"column_id":${encodeTableValue(c.column)},"value":${encodeTableValue(c.value)},"version":${c.version}}').join(',')}]}';
  final Object _body;
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
  return TableWireReceipt(
    result.tableId,
    result.schemaVersion,
    sequence: result.sequence,
    id: result.id,
    skipped: result.skipped?.length ?? 0,
    skippedCells: [
      for (final s in result.skipped ?? <TableSkippedCell>[])
        (
          row: s.rowId,
          column: s.columnId,
          reason: s.reason.json ?? 'unavailable',
        ),
    ],
  );
});

Future<String> postTableCopyWire(
  Dio dio, {
  required bool personal,
  required String key,
  required Map<String, dynamic> body,
  required TableApiExtras extras,
}) => apiCall(() async {
  final response = await dio.post<Map<String, dynamic>>(
    personal ? '/v1/personal/table-copies' : '/v1/table-copies',
    data: Map<String, dynamic>.of(body)..removeWhere((k, v) => v == null),
    options: Options(extra: extras, headers: {'Idempotency-Key': key}),
  );
  return TableResult.fromJson(response.data!).tableId;
});

Future<TableResult> uploadTableWire(
  Dio dio, {
  required String path,
  required String row,
  required String column,
  required int version,
  required String name,
  required Stream<List<int>> bytes,
  required int length,
  required String key,
  required TableApiExtras extras,
}) => apiCall(() async {
  final response = await dio.post<Map<String, dynamic>>(
    path,
    queryParameters: {
      'row_id': row,
      'column_id': column,
      'cell_version': version,
    },
    data: FormData.fromMap({
      'file': MultipartFile.fromStream(() => bytes, length, filename: name),
    }),
    options: Options(extra: extras, headers: {'Idempotency-Key': key}),
  );
  return TableResult.fromJson(response.data!);
});

/// Akış gövdesi okunmadan hatanın JSON zarfını çözmek mümkün değildir.
/// Çağıran bu açılışı `streamApiError` sınırında sınıflandırır.
Future<Response<ResponseBody>> openTableWireBody(
  Dio dio, {
  required String path,
  required TableApiExtras extras,
  CancelToken? cancel,
  bool events = false,
}) => dio.get<ResponseBody>(
  path,
  cancelToken: cancel,
  options: Options(
    responseType: ResponseType.stream,
    extra: extras,
    receiveTimeout: events ? Duration.zero : null,
    headers: events ? const {Headers.acceptHeader: 'text/event-stream'} : null,
  ),
);

/// Narrow read adapter: generated TableComment.author incorrectly uses the
/// unrelated Author enum instead of the contract's nullable {id, name} object.
class TableWireComment {
  TableWireComment(Map<String, dynamic> c) {
    final person = c['author'] as Map<String, dynamic>?;
    if (person != null && person['id'] is! String) {
      throw invalidResponseError();
    }
    final sequence = c['seq'] as int;
    if (sequence < 1) throw invalidResponseError();
    id = c['id'] as String;
    row = c['row_id'] as String;
    column = c['column_id'] as String?;
    author = person == null ? null : person['name'] as String;
    mine = c['mine'] as bool;
    body = c['body'] as String;
    created = DateTime.parse(c['created_at'] as String);
    edited = c['edited_at'] == null
        ? null
        : DateTime.parse(c['edited_at'] as String);
  }
  late final String id;
  late final String row;
  late final String? column;
  late final String? author;
  late final bool mine;
  late final String body;
  late final DateTime created;
  late final DateTime? edited;
}

class TableWireComments {
  const TableWireComments(this.items, this.cursor);
  final List<TableWireComment> items;
  final String? cursor;
}

Future<TableWireComments> getTableCommentsWire(
  Dio dio, {
  required String path,
  required TableApiExtras extras,
  String? row,
  String? cursor,
}) => apiCall(() async {
  final response = await dio.get<Map<String, dynamic>>(
    path,
    queryParameters: {'row_id': ?row, 'cursor': ?cursor},
    options: Options(extra: extras),
  );
  final data = response.data!;
  return TableWireComments([
    for (final raw in data['items'] as List)
      TableWireComment(raw as Map<String, dynamic>),
  ], data['next_cursor'] as String?);
});
