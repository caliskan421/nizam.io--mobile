import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/tables_client.dart';
import '../../../core/api/generated/models/table.dart' as api;
import '../../../core/api/generated/models/table_add_column_command_kind.dart';
import '../../../core/api/generated/models/table_add_comment_command_kind.dart';
import '../../../core/api/generated/models/table_add_row_command_kind.dart';
import '../../../core/api/generated/models/table_cell.dart' as api;
import '../../../core/api/generated/models/table_change_kind.dart' as api;
import '../../../core/api/generated/models/table_changes.dart' as api;
import '../../../core/api/generated/models/table_column.dart' as api;
import '../../../core/api/generated/models/table_column_type.dart' as api;
import '../../../core/api/generated/models/table_command.dart' as api;
import '../../../core/api/generated/models/table_comment.dart' as api;
import '../../../core/api/generated/models/table_convert_column_command_kind.dart';
import '../../../core/api/generated/models/table_create_request.dart';
import '../../../core/api/generated/models/table_create_request_kind.dart';
import '../../../core/api/generated/models/table_delete_column_command_kind.dart';
import '../../../core/api/generated/models/table_delete_command_kind.dart';
import '../../../core/api/generated/models/table_delete_comment_command_kind.dart';
import '../../../core/api/generated/models/table_delete_row_command_kind.dart';
import '../../../core/api/generated/models/table_edit_comment_command_kind.dart';
import '../../../core/api/generated/models/table_grant_command_kind.dart';
import '../../../core/api/generated/models/table_grant_command_role.dart';
import '../../../core/api/generated/models/table_move_column_command_kind.dart';
import '../../../core/api/generated/models/table_move_row_command_kind.dart';
import '../../../core/api/generated/models/table_presence_frame.dart';
import '../../../core/api/generated/models/table_presence_request.dart';
import '../../../core/api/generated/models/table_rename_column_command_kind.dart';
import '../../../core/api/generated/models/table_rename_command_kind.dart';
import '../../../core/api/generated/models/table_resize_column_command_kind.dart';
import '../../../core/api/generated/models/table_result.dart' as api;
import '../../../core/api/generated/models/table_revoke_command_kind.dart';
import '../../../core/api/generated/models/table_set_cells_command_kind.dart';
import '../../../core/api/generated/models/table_set_team_role_command_kind.dart';
import '../../../core/api/generated/models/table_set_team_role_command_role.dart';
import '../../../core/api/generated/models/table_set_template_command_kind.dart';
import '../../../core/api/generated/models/table_skipped_cell.dart';
import '../../../core/api/generated/models/table_skipped_cell_reason.dart'
    as api;
import '../../../core/api/generated/models/table_snapshot.dart' as api;
import '../../../core/api/generated/models/table_space.dart' as api;
import '../../../core/api/generated/models/table_stream_frame.dart';
import '../../../core/api/generated/models/table_undo_cells_command_kind.dart';
import '../../../core/api/generated/models/template.dart';
import '../../../core/domain/enum_parse.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/domain/stream_reconnect.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
import '../../../core/http/sse.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/telemetry/error_report.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/table_models.dart';
import '../domain/table_operation.dart';
import '../domain/tables_repository.dart';

part 'table_mapping.dart';

/// Tablolar uçlarına üretilmiş istemciyle erişim. DTO'lar bu katmanda kalır (A1). Her istek
/// kapsamı [TableScope]'tan sabitlenir: koordinatörlük `withScope` (program + departman),
/// kişisel `withProgram`. Bütün hatalar [ApiError].
class ApiTablesRepository implements TablesRepository {
  /// [dio]: doğrulanmış bağın güncel API istemcisi; bağ yoksa null →
  /// `client.server_not_verified`. İstek anında okunur.
  ApiTablesRepository(this._dio);

  final Dio? Function() _dio;

  Dio get _http {
    final d = _dio();
    if (d == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return d;
  }

  TablesClient get _client => TablesClient(_http);

  static bool _personal(TableScope s) => s.space == TableSpace.personal;

  static String? _cursor(String? c) => c == null || c.isEmpty ? null : c;

  @override
  Future<PageSlice<TableMeta>> list(
    TableScope scope, {
    PageRequest page = const PageRequest(),
    bool? template,
  }) async {
    final t = template == null
        ? null
        : (template ? Template.valueTrue : Template.valueFalse);
    final r = await apiCall(
      () => _personal(scope)
          ? _client.listPersonalTables(
              limit: page.limit,
              cursor: page.cursor,
              template: t,
              extras: withProgram(
                TablesClient.listPersonalTablesOpenapiExtras,
                scope.programId,
              ),
            )
          : _client.listTables(
              limit: page.limit,
              cursor: page.cursor,
              template: t,
              extras: withScope(
                TablesClient.listTablesOpenapiExtras,
                scope.programId,
                scope.departmentId ?? '',
              ),
            ),
    );
    return PageSlice(
      items: [for (final t in r.items) _tableMetaOf(t)],
      nextCursor: _cursor(r.nextCursor),
    );
  }

  @override
  Future<TableReceipt> create(
    TableScope scope,
    String name, {
    required String requestKey,
  }) async {
    final body = TableCreateRequest(
      name: name,
      kind: TableCreateRequestKind.createTable,
    );
    final r = await apiCall(
      () => _personal(scope)
          ? _client.createPersonalTable(
              idempotencyKey: requestKey,
              body: body,
              extras: withProgram(
                TablesClient.createPersonalTableOpenapiExtras,
                scope.programId,
              ),
            )
          : _client.createTable(
              idempotencyKey: requestKey,
              body: body,
              extras: withScope(
                TablesClient.createTableOpenapiExtras,
                scope.programId,
                scope.departmentId ?? '',
              ),
            ),
    );
    return _receiptOf(r);
  }

  @override
  Future<TableSnapshotPage> snapshot(
    TableScope scope,
    String tableId, {
    PageRequest page = const PageRequest(),
  }) async {
    final r = await apiCall(
      () => _personal(scope)
          ? _client.getPersonalTable(
              tableId: tableId,
              limit: page.limit,
              cursor: page.cursor,
              extras: withProgram(
                TablesClient.getPersonalTableOpenapiExtras,
                scope.programId,
              ),
            )
          : _client.getTable(
              tableId: tableId,
              limit: page.limit,
              cursor: page.cursor,
              extras: withScope(
                TablesClient.getTableOpenapiExtras,
                scope.programId,
                scope.departmentId ?? '',
              ),
            ),
    );
    return apiCall(() async => _snapshotOf(r));
  }

  @override
  Future<TableReceipt> apply(
    TableScope scope,
    String tableId,
    TableOperation operation, {
    required String requestKey,
  }) async {
    final r = await apiCall(() {
      final body = _commandOf(operation);
      return _personal(scope)
          ? _client.applyPersonalTableOperation(
              tableId: tableId,
              idempotencyKey: requestKey,
              body: body,
              extras: withProgram(
                TablesClient.applyPersonalTableOperationOpenapiExtras,
                scope.programId,
              ),
            )
          : _client.applyTableOperation(
              tableId: tableId,
              idempotencyKey: requestKey,
              body: body,
              extras: withScope(
                TablesClient.applyTableOperationOpenapiExtras,
                scope.programId,
                scope.departmentId ?? '',
              ),
            );
    });
    return _receiptOf(r);
  }

  @override
  Future<TableChangesPage> changes(
    TableScope scope,
    String tableId, {
    required int after,
    int? limit,
  }) async {
    final r = await apiCall(
      () => _personal(scope)
          ? _client.getPersonalTableChanges(
              tableId: tableId,
              after: '$after',
              limit: limit,
              extras: withProgram(
                TablesClient.getPersonalTableChangesOpenapiExtras,
                scope.programId,
              ),
            )
          : _client.getTableChanges(
              tableId: tableId,
              after: '$after',
              limit: limit,
              extras: withScope(
                TablesClient.getTableChangesOpenapiExtras,
                scope.programId,
                scope.departmentId ?? '',
              ),
            ),
    );
    return _changesOf(r);
  }

  @override
  Future<PageSlice<TableCommentItem>> comments(
    TableScope scope,
    String tableId, {
    String? rowId,
    PageRequest page = const PageRequest(),
  }) async {
    final r = await apiCall(
      () => _personal(scope)
          ? _client.getPersonalTableComments(
              tableId: tableId,
              rowId: rowId,
              limit: page.limit,
              cursor: page.cursor,
              extras: withProgram(
                TablesClient.getPersonalTableCommentsOpenapiExtras,
                scope.programId,
              ),
            )
          : _client.getTableComments(
              tableId: tableId,
              rowId: rowId,
              limit: page.limit,
              cursor: page.cursor,
              extras: withScope(
                TablesClient.getTableCommentsOpenapiExtras,
                scope.programId,
                scope.departmentId ?? '',
              ),
            ),
    );
    return PageSlice(
      items: [for (final c in r.items) _commentOf(c)],
      nextCursor: _cursor(r.nextCursor),
    );
  }

  @override
  Future<void> setPresence(
    TableScope scope,
    String tableId, {
    String? rowId,
    String? columnId,
  }) {
    final body = TablePresenceRequest(rowId: rowId, columnId: columnId);
    return apiCall(
      () => _personal(scope)
          ? _client.setPersonalTablePresence(
              tableId: tableId,
              body: body,
              extras: withProgram(
                TablesClient.setPersonalTablePresenceOpenapiExtras,
                scope.programId,
              ),
            )
          : _client.setTablePresence(
              tableId: tableId,
              body: body,
              extras: withScope(
                TablesClient.setTablePresenceOpenapiExtras,
                scope.programId,
                scope.departmentId ?? '',
              ),
            ),
    );
  }

  @override
  Future<void> leavePresence(TableScope scope, String tableId) => apiCall(
    () => _personal(scope)
        ? _client.leavePersonalTablePresence(
            tableId: tableId,
            extras: withProgram(
              TablesClient.leavePersonalTablePresenceOpenapiExtras,
              scope.programId,
            ),
          )
        : _client.leaveTablePresence(
            tableId: tableId,
            extras: withScope(
              TablesClient.leaveTablePresenceOpenapiExtras,
              scope.programId,
              scope.departmentId ?? '',
            ),
          ),
  );

  /// Ham akış isteği (üretilmiş istemci `Future<String>` döner; akış okunamaz). Kapı halkası
  /// işlem kimliğini üretilmiş `extras`'tan alır; yol üretilmiş `@GET` ile aynıdır.
  @override
  Stream<TableStreamEvent> stream(TableScope scope, String tableId) async* {
    final personal = _personal(scope);
    final operationId = personal
        ? 'streamPersonalTableChanges'
        : 'streamTableChanges';
    final cancel = CancelToken();
    try {
      final Response<ResponseBody> response;
      try {
        response = await _http.get<ResponseBody>(
          personal
              ? '/v1/personal/tables/${Uri.encodeComponent(tableId)}/stream'
              : '/v1/tables/${Uri.encodeComponent(tableId)}/stream',
          cancelToken: cancel,
          options: Options(
            responseType: ResponseType.stream,
            receiveTimeout: StreamReconnect.idleTimeout,
            headers: {Headers.acceptHeader: 'text/event-stream'},
            // Kapı halkası `extra`'ya yazar; sabit harita kopyalanır.
            extra: personal
                ? withProgram(
                    Map.of(
                      TablesClient.streamPersonalTableChangesOpenapiExtras,
                    ),
                    scope.programId,
                  )
                : withScope(
                    Map.of(TablesClient.streamTableChangesOpenapiExtras),
                    scope.programId,
                    scope.departmentId ?? '',
                  ),
          ),
        );
      } on Object catch (e, st) {
        throw await streamApiError(
          e,
          st,
          ReportOperation.tableStream,
          ReportSource.tables,
        );
      }
      final body = response.data;
      if (body == null) {
        throw invalidResponseError(
          operation: ReportOperation.tableStream,
          source: ReportSource.tables,
          apiOperationId: operationId,
        );
      }
      try {
        await for (final raw in decodeSse(body.stream)) {
          final event = _event(raw.event, raw.data, operationId);
          if (event != null) yield event;
        }
      } on ApiError {
        rethrow;
      } on Object catch (e, st) {
        // Ağ/IO kopması beklenen durumdur; beklenmeyen iç hata özgün yığınla raporlanır.
        reportUnexpected(
          e,
          st,
          operation: ReportOperation.tableStream,
          source: ReportSource.tables,
        );
        throw e is DioException
            ? toApiError(e)
            : ApiError(ClientErrorCode.networkError);
      }
    } finally {
      cancel.cancel();
    }
  }

  /// Bilinmeyen olay adı atlanır (ekleyici genişleme); şemaya uymayan yük
  /// `client.invalid_response`.
  static TableStreamEvent? _event(String? name, String data, String opId) {
    try {
      switch (name) {
        case 'ready':
          return TableStreamReady(
            TableStreamFrame.fromJson(sseJsonObject(data)).sequence,
          );
        case 'changed':
          return TableStreamChanged(
            TableStreamFrame.fromJson(sseJsonObject(data)).sequence,
          );
        case 'presence':
          final f = TablePresenceFrame.fromJson(sseJsonObject(data));
          return TablePresenceUpdate([
            for (final p in f.participants)
              TableParticipant(
                key: p.key,
                accountId: p.accountId,
                name: p.name,
                rowId: p.rowId.isEmpty ? null : p.rowId,
                columnId: p.columnId.isEmpty ? null : p.columnId,
              ),
          ]);
      }
      return null;
    } on Object catch (e, st) {
      throw invalidResponseError(
        cause: e,
        stack: st,
        operation: ReportOperation.tableStream,
        source: ReportSource.tables,
        apiOperationId: opId,
      );
    }
  }
}
