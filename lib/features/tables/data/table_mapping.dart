part of 'table_api_repository.dart';

// Üretilmiş tablo DTO'ları ↔ domain eşlemesi (yalnız data katmanı; A1). Bilinmeyen enum
// değeri domain `unknown` üyesine düşer; yeni backend etiketi uygulamayı kırmaz.

TableMeta _tableMetaOf(api.Table t) => TableMeta(
  id: t.id,
  ownerId: t.ownerId,
  name: t.name,
  scope: switch (t.space) {
    api.TableSpace.personal => TableScope.personal(programId: t.programId),
    // Bilinmeyen alan koordinatörlük rotasıyla denenir; sunucu reddederse 404.
    _ => TableScope.coordinatorship(
      programId: t.programId,
      departmentId: t.departmentId,
    ),
  },
  schemaVersion: t.schemaVersion,
  sequence: t.sequence,
  teamRole: t.teamRole == null
      ? null
      : enumFromWire(
          TableTeamRole.values,
          t.teamRole!.json,
          TableTeamRole.unknown,
        ),
  projectId: t.projectId,
  isTemplate: t.isTemplate ?? false,
);

TableColumnKind _columnKindOf(api.TableColumnType t) =>
    enumFromWire(TableColumnKind.values, t.name, TableColumnKind.unknown);

TableColumnSpec _columnOf(api.TableColumn c) => TableColumnSpec(
  id: c.id,
  name: c.name,
  kind: _columnKindOf(c.type),
  width: c.width,
  position: c.position,
  multiple: c.multiple,
);

/// Ham JSON hücre değeri domain değerine: metin, sayı, mantık ya da kimlik listesi
/// (redakte öğe aynı konumda null). Başka biçim → `client.invalid_response` (apiCall içinde).
Object? _cellValueOf(Object? raw) => switch (raw) {
  null || String() || num() || bool() => raw,
  final List<Object?> l => [
    for (final e in l)
      if (e == null || e is String)
        e
      else
        throw const FormatException('hücre öğesi'),
  ],
  _ => throw const FormatException('hücre değeri'),
};

TableSnapshotPage _snapshotOf(api.TableSnapshot s) {
  final refs = <TableRefKey, String>{};
  for (final group in (s.references ?? const {}).entries) {
    final kind = TableRefKind.values
        .where((k) => k.name == group.key)
        .firstOrNull;
    if (kind == null) continue;
    for (final e in group.value.entries) {
      refs[TableRefKey(kind, e.key)] = e.value;
    }
  }
  return TableSnapshotPage(
    meta: _tableMetaOf(s.table),
    columns: [
      for (final c in s.columns.map(_columnOf))
        if (c.kind != TableColumnKind.unknown) c,
    ]..sort((a, b) => a.position.compareTo(b.position)),
    rows: [for (final r in s.rows) TableRowRef(id: r.id, position: r.position)],
    cells: {
      for (final c in s.cells)
        TableCellKey(c.rowId, c.columnId): TableCellData(
          value: _cellValueOf(c.value),
          version: c.version,
          redacted: c.redacted ?? false,
        ),
    },
    references: refs,
    attachments: {
      for (final a in (s.attachments ?? const {}).values)
        TableAttachmentId(a.id): TableAttachmentInfo(
          id: a.id,
          name: a.name,
          contentType: a.contentType,
          sizeBytes: a.sizeBytes,
        ),
    },
    nextCursor: s.nextCursor == null || s.nextCursor!.isEmpty
        ? null
        : s.nextCursor,
  );
}

TableReceipt _receiptOf(api.TableResult r) => TableReceipt(
  tableId: r.tableId,
  sequence: r.sequence,
  schemaVersion: r.schemaVersion,
  replayed: r.replayed,
  id: r.id,
  cellVersions: {
    for (final c in r.cells ?? const <api.TableCell>[])
      TableCellKey(c.rowId, c.columnId): c.version,
  },
  skipped: [
    for (final s in r.skipped ?? const <TableSkippedCell>[])
      TableUndoSkip(
        rowId: s.rowId,
        columnId: s.columnId,
        reason: switch (s.reason) {
          api.TableSkippedCellReason.gone => TableUndoSkipReason.gone,
          api.TableSkippedCellReason.changed => TableUndoSkipReason.changed,
          api.TableSkippedCellReason.unavailable =>
            TableUndoSkipReason.unavailable,
          _ => TableUndoSkipReason.unknown,
        },
      ),
  ],
  converted: r.converted,
);

TableChangesPage _changesOf(api.TableChanges c) => TableChangesPage(
  changes: [
    for (final e in c.changes)
      TableChangeEntry(
        seq: e.seq,
        kind: enumFromWire(
          TableChangeKind.values,
          e.kind == api.TableChangeKind.$unknown ? null : e.kind.name,
          TableChangeKind.unknown,
        ),
      ),
  ],
  cursor: c.cursor,
  sequence: c.sequence,
  more: c.more,
);

TableCommentItem _commentOf(api.TableComment c) => TableCommentItem(
  id: c.id,
  rowId: c.rowId,
  columnId: c.columnId,
  authorId: c.author?.id,
  authorName: c.author?.name,
  mine: c.mine,
  body: c.body,
  seq: c.seq,
  createdAt: c.createdAt,
  editedAt: c.editedAt,
);

api.TableColumnType _columnType(TableColumnKind k) {
  if (k == TableColumnKind.unknown) {
    throw ArgumentError.value(k, 'kind', 'bilinmeyen sütun tipi gönderilemez');
  }
  return api.TableColumnType.values.byName(k.name);
}

/// Domain komutu → üretilmiş `TableCommand` gövdesi.
api.TableCommand _commandOf(TableOperation op) => switch (op) {
  RenameTable(:final name) => api.TableCommand.renameTable(
    kind: TableRenameCommandKind.renameTable,
    name: name,
  ),
  DeleteTable() => const api.TableCommand.deleteTable(
    kind: TableDeleteCommandKind.deleteTable,
  ),
  AddColumn() => api.TableCommand.addColumn(
    kind: TableAddColumnCommandKind.addColumn,
    name: op.name,
    type: _columnType(op.kind),
    width: op.width,
    expectedSchema: op.expectedSchema,
    multiple: op.multiple,
  ),
  RenameColumn() => api.TableCommand.renameColumn(
    kind: TableRenameColumnCommandKind.renameColumn,
    id: op.id,
    name: op.name,
    expectedSchema: op.expectedSchema,
  ),
  ResizeColumn() => api.TableCommand.resizeColumn(
    kind: TableResizeColumnCommandKind.resizeColumn,
    id: op.id,
    width: op.width,
    expectedSchema: op.expectedSchema,
  ),
  DeleteColumn() => api.TableCommand.deleteColumn(
    kind: TableDeleteColumnCommandKind.deleteColumn,
    id: op.id,
    expectedSchema: op.expectedSchema,
  ),
  MoveColumn() => api.TableCommand.moveColumn(
    kind: TableMoveColumnCommandKind.moveColumn,
    id: op.id,
    expectedSchema: op.expectedSchema,
    afterId: op.afterId,
  ),
  ConvertColumn() => api.TableCommand.convertColumn(
    kind: TableConvertColumnCommandKind.convertColumn,
    id: op.id,
    type: _columnType(op.kind),
    expectedSchema: op.expectedSchema,
  ),
  AddRow() => const api.TableCommand.addRow(
    kind: TableAddRowCommandKind.addRow,
  ),
  DeleteRow(:final id) => api.TableCommand.deleteRow(
    kind: TableDeleteRowCommandKind.deleteRow,
    id: id,
  ),
  MoveRow() => api.TableCommand.moveRow(
    kind: TableMoveRowCommandKind.moveRow,
    id: op.id,
    afterId: op.afterId,
  ),
  SetCells(:final cells) => api.TableCommand.setCells(
    kind: TableSetCellsCommandKind.setCells,
    cells: [
      for (final c in cells)
        api.TableCell(
          rowId: c.rowId,
          columnId: c.columnId,
          value: c.value,
          version: c.version,
        ),
    ],
  ),
  UndoCells(:final sequence) => api.TableCommand.undoCells(
    kind: TableUndoCellsCommandKind.undoCells,
    sequence: sequence,
  ),
  GrantAccess() => api.TableCommand.grant(
    kind: TableGrantCommandKind.grant,
    accountId: op.accountId,
    role: switch (op.role) {
      TableGrantRole.editor => TableGrantCommandRole.editor,
      TableGrantRole.viewer => TableGrantCommandRole.viewer,
    },
  ),
  RevokeAccess(:final accountId) => api.TableCommand.revoke(
    kind: TableRevokeCommandKind.revoke,
    accountId: accountId,
  ),
  SetTeamRole(:final role) => api.TableCommand.setTeamRole(
    kind: TableSetTeamRoleCommandKind.setTeamRole,
    role: switch (role) {
      TableGrantRole.editor => TableSetTeamRoleCommandRole.editor,
      TableGrantRole.viewer => TableSetTeamRoleCommandRole.viewer,
      null => TableSetTeamRoleCommandRole.none,
    },
  ),
  SetTemplate(:final template) => api.TableCommand.setTemplate(
    kind: TableSetTemplateCommandKind.setTemplate,
    template: template,
  ),
  AddComment() => api.TableCommand.addComment(
    kind: TableAddCommentCommandKind.addComment,
    rowId: op.rowId,
    body: op.body,
    columnId: op.columnId,
  ),
  EditComment() => api.TableCommand.editComment(
    kind: TableEditCommentCommandKind.editComment,
    id: op.id,
    body: op.body,
  ),
  DeleteComment(:final id) => api.TableCommand.deleteComment(
    kind: TableDeleteCommentCommandKind.deleteComment,
    id: id,
  ),
};
