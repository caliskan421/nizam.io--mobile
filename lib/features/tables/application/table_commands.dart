part of 'table_controller.dart';

/// Tablo komutları. İşlem anahtarı KULLANICI İŞLEMİ başınadır: defter yuvası komutun gövde
/// imzasıdır (`op:<imza>`), bu yüzden sonucu bilinmeyen bir komutun anahtarı araya giren
/// başka komutla kaybolmaz; aynı işlem yeniden denenince aynı anahtar gider (sunucu tekrarı
/// `replayed` makbuzla döner, kayıt tek kalır). Makbuz alındıktan sonraki yan okuma (yeniden
/// okuma) düşerse komut başarılı sayılır; yan okuma hatası raporlanır ve sonraki yakalama
/// tabloyu yeniden okur ([TableController._needsReload]).
extension TableCommands on TableController {
  int get _schema => _base!.meta.schemaVersion;

  /// Komutu gönderir (önce bekleyen hücreler). Yazım hatası fırlar; 403 tabloyu salt okunur
  /// yapar, 409 `tables.schema_conflict` tabloyu yeniden okutur.
  Future<TableReceipt> _command(TableOperation op, {bool reload = true}) async {
    await flush();
    final action = 'op:${op.signature}';
    final (keys, key) = _keys.keyFor(action, op.signature);
    _keys = keys;
    final generation = _generation;
    final TableReceipt r;
    try {
      r = await _repo.apply(_scope, _id, op, requestKey: key);
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      if (!isOutcomeUnknown(e)) _keys = _keys.clear(action);
      if (generation == _generation && _mounted) {
        if (e.code == 'tables.forbidden') {
          _update((b) => b.copyWith(readOnly: true));
        } else if (e.code == 'tables.schema_conflict') {
          await _sideRead();
        }
      }
      rethrow;
    }
    _keys = _keys.clear(action);
    ownSequences.add(r.sequence);
    if (generation == _generation && _mounted) {
      _update(
        (b) => b.copyWith(
          meta: b.meta.copyWith(
            sequence: r.sequence > b.meta.sequence ? r.sequence : null,
            schemaVersion: r.schemaVersion,
          ),
        ),
      );
      if (reload) await _sideRead();
    }
    return r;
  }

  /// Makbuz sonrası yeniden okuma: düşerse yazım hatası gibi sunulmaz; kalıcı bayrak kalır.
  Future<void> _sideRead() async {
    try {
      await _reload();
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      _needsReload = true;
    }
  }

  Future<void> rename(String name) async {
    final trimmed = name.trim();
    await _command(RenameTable(trimmed), reload: false);
    _update((b) => b.copyWith(meta: b.meta.copyWith(name: trimmed)));
    _listOrNull?.renamed(_id, trimmed);
  }

  /// Yalnız sahip; başarıda listeden düşer.
  Future<void> deleteTable() async {
    _queue.clear();
    await _command(const DeleteTable(), reload: false);
    _listOrNull?.removed(_id);
  }

  /// Yeni satır (kimliği sunucu üretir) ve kimliği.
  Future<String?> addRow() async => (await _command(const AddRow())).id;

  Future<void> deleteRow(String rowId) async {
    _queue.removeWhere((w) => w.rowId == rowId);
    await _command(DeleteRow(rowId));
  }

  Future<void> moveRow(String rowId, {String? afterId}) =>
      _command(MoveRow(id: rowId, afterId: afterId));

  /// Varsayılan genişlik 200 px (40–1200).
  Future<String?> addColumn(
    String name,
    TableColumnKind kind, {
    int width = 200,
  }) async => (await _command(
    AddColumn(
      name: name.trim(),
      kind: kind,
      width: width,
      expectedSchema: _schema,
    ),
  )).id;

  Future<void> renameColumn(String columnId, String name) async {
    final trimmed = name.trim();
    await _command(
      RenameColumn(id: columnId, name: trimmed, expectedSchema: _schema),
      reload: false,
    );
    _update(
      (b) => b.copyWith(
        columns: [
          for (final c in b.columns)
            c.id == columnId ? c.copyWith(name: trimmed) : c,
        ],
      ),
    );
  }

  Future<void> resizeColumn(String columnId, int width) async {
    await _command(
      ResizeColumn(id: columnId, width: width, expectedSchema: _schema),
      reload: false,
    );
    _update(
      (b) => b.copyWith(
        columns: [
          for (final c in b.columns)
            c.id == columnId ? c.copyWith(width: width) : c,
        ],
      ),
    );
  }

  Future<void> deleteColumn(String columnId) async {
    _queue.removeWhere((w) => w.columnId == columnId);
    await _command(DeleteColumn(id: columnId, expectedSchema: _schema));
  }

  /// [afterId] null → ilk sıraya.
  Future<void> moveColumn(String columnId, {String? afterId}) => _command(
    MoveColumn(id: columnId, afterId: afterId, expectedSchema: _schema),
  );

  /// Satıra (ya da hücreye) yorum ekler; açık yorum listeleri yenilenir.
  Future<void> addComment(String rowId, String body, {String? columnId}) async {
    await _command(
      AddComment(rowId: rowId, body: body.trim(), columnId: columnId),
      reload: false,
    );
    _bumpComments();
  }

  Future<void> editComment(String commentId, String body) async {
    await _command(
      EditComment(id: commentId, body: body.trim()),
      reload: false,
    );
    _bumpComments();
  }

  Future<void> deleteComment(String commentId) async {
    await _command(DeleteComment(commentId), reload: false);
    _bumpComments();
  }

  /// Son kendi hücre yazımını koşullu geri alır; geri alınamayan hücre sayısını döner.
  Future<int> undoLast() async {
    final seq = _base?.undoSequence;
    if (seq == null) return 0;
    final r = await _command(UndoCells(seq));
    _update((b) => b.copyWith(undoSequence: () => null));
    return r.skipped.length;
  }
}
