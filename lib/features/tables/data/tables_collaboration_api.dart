part of 'tables_api_repository.dart';

/// SSE ve akışlı dosya yolları üretilmiş `Future<String>`/`File` imzaları yerine
/// ham Dio kullanır; üretilmiş kapsam/kimlik metaverisi aynen korunur.
mixin _TableCollaborationApi {
  Dio get _http;
  TableApiExtras _scope(TableApiExtras meta, TableLocation scope);
  String _path(TableLocation l, String id);

  Future<TablePageSlice<TableCommentEntry>> comments(
    TableLocation l,
    String id, {
    String? row,
    String? cursor,
  }) async {
    final page = await getTableCommentsWire(
      _http,
      path: '${_path(l, id)}/comments',
      row: row,
      cursor: cursor,
      extras: _scope(
        l.personal
            ? TablesClient.getPersonalTableCommentsOpenapiExtras
            : TablesClient.getTableCommentsOpenapiExtras,
        l,
      ),
    );
    return TablePageSlice([
      for (final c in page.items)
        TableCommentEntry(
          id: c.id,
          row: c.row,
          column: c.column,
          author: c.author,
          mine: c.mine,
          body: c.body,
          created: c.created,
          edited: c.edited,
        ),
    ], page.cursor);
  }

  Future<TableChangePage> changes(TableLocation l, String id, int after) async {
    final client = TablesClient(_http);
    final p = await apiCall(
      () => l.personal
          ? client.getPersonalTableChanges(
              tableId: id,
              after: '$after',
              extras: _scope(
                TablesClient.getPersonalTableChangesOpenapiExtras,
                l,
              ),
            )
          : client.getTableChanges(
              tableId: id,
              after: '$after',
              extras: _scope(TablesClient.getTableChangesOpenapiExtras, l),
            ),
    );
    if (p.tableId != id) throw invalidResponseError();
    var previous = after;
    for (final change in p.changes) {
      if (change.tableId != id ||
          change.seq <= previous ||
          change.seq > p.cursor) {
        throw invalidResponseError();
      }
      previous = change.seq;
    }
    if (p.cursor < after ||
        p.cursor > p.sequence ||
        (p.more && p.cursor == after)) {
      throw invalidResponseError();
    }
    return TableChangePage(
      [for (final c in p.changes) TableChangeEntry(c.seq, c.kind.json ?? '')],
      p.cursor,
      p.sequence,
      p.more,
    );
  }

  Stream<TableLiveEvent> watch(TableLocation l, String id) async* {
    final cancel = CancelToken();
    try {
      final response = await openTableWireBody(
        _http,
        path: '${_path(l, id)}/stream',
        cancel: cancel,
        events: true,
        extras: _scope(
          l.personal
              ? TablesClient.streamPersonalTableChangesOpenapiExtras
              : TablesClient.streamTableChangesOpenapiExtras,
          l,
        ),
      );
      if (response.data == null) throw invalidResponseError();
      await for (final raw in decodeSse(response.data!.stream)) {
        if (raw.event == 'presence') {
          final frame = api.TablePresenceFrame.fromJson(
            sseJsonObject(raw.data),
          );
          if (frame.tableId != id) throw invalidResponseError();
          yield TableLiveEvent(null, [
            for (final p in frame.participants)
              TableParticipant(p.key, p.accountId, p.name, p.rowId, p.columnId),
          ]);
        } else if (raw.event == 'ready' || raw.event == 'changed') {
          final frame = api.TableStreamFrame.fromJson(sseJsonObject(raw.data));
          if (frame.tableId != id) throw invalidResponseError();
          yield TableLiveEvent(frame.sequence);
        }
      }
    } on Object catch (e, st) {
      final error = await streamApiError(e, st, null, ReportSource.network);
      if (!cancel.isCancelled) throw error;
    } finally {
      cancel.cancel();
    }
  }

  Future<void> presence(
    TableLocation l,
    String id, {
    String? row,
    String? column,
    bool leave = false,
  }) async {
    final client = TablesClient(_http);
    if (leave) {
      await apiCall(
        () => l.personal
            ? client.leavePersonalTablePresence(
                tableId: id,
                extras: _scope(
                  TablesClient.leavePersonalTablePresenceOpenapiExtras,
                  l,
                ),
              )
            : client.leaveTablePresence(
                tableId: id,
                extras: _scope(TablesClient.leaveTablePresenceOpenapiExtras, l),
              ),
      );
    } else {
      final body = api.TablePresenceRequest(rowId: row, columnId: column);
      await apiCall(
        () => l.personal
            ? client.setPersonalTablePresence(
                tableId: id,
                body: body,
                extras: _scope(
                  TablesClient.setPersonalTablePresenceOpenapiExtras,
                  l,
                ),
              )
            : client.setTablePresence(
                tableId: id,
                body: body,
                extras: _scope(TablesClient.setTablePresenceOpenapiExtras, l),
              ),
      );
    }
  }

  Future<TableOperationReceipt> upload(
    TableLocation l,
    String id, {
    required String row,
    required String column,
    required int version,
    required String name,
    required Stream<List<int>> bytes,
    required int length,
    required String key,
  }) async {
    final r = api.TableResult.fromJson(
      await uploadTableWire(
        _http,
        path: '${_path(l, id)}/attachments',
        row: row,
        column: column,
        version: version,
        name: name,
        bytes: bytes,
        length: length,
        key: key,
        extras: _scope(
          l.personal
              ? TablesClient.attachPersonalTableFileOpenapiExtras
              : TablesClient.attachTableFileOpenapiExtras,
          l,
        ),
      ),
    );
    if (r.tableId != id) throw invalidResponseError();
    return TableOperationReceipt(
      table: id,
      sequence: r.sequence,
      schema: r.schemaVersion,
      id: r.id,
    );
  }

  Future<Stream<List<int>>> download(
    TableLocation l,
    String id,
    String attachment,
  ) async {
    try {
      final r = await openTableWireBody(
        _http,
        path: '${_path(l, id)}/attachments/${Uri.encodeComponent(attachment)}',
        extras: _scope(
          l.personal
              ? TablesClient.downloadPersonalTableAttachmentOpenapiExtras
              : TablesClient.downloadTableAttachmentOpenapiExtras,
          l,
        ),
      );
      if (r.data == null) throw invalidResponseError();
      return r.data!.stream;
    } on Object catch (e, st) {
      throw await streamApiError(e, st, null, ReportSource.network);
    }
  }
}
