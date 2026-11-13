part of 'table_controller.dart';

/// Sonucu bilinmeyen komut: işlem nesnesi ve anahtarı DEĞİŞMEZ; yalnız kendi yeniden
/// denemesi aynı anahtarı kullanır.
/// Makbuzla güncellenen metadata alanı (tablo adı; sütun kimliği bazında ad/genişlik).
/// Tipli anahtar: alan başına uygulanmış en yüksek makbuz sırasının anahtarı.
extension type const _MetaField._((int, String) _key) {
  const _MetaField.tableName() : this._((0, ''));
  _MetaField.columnName(String id) : this._((1, id));
  _MetaField.columnWidth(String id) : this._((2, id));
}

final class _PendingCommand {
  _PendingCommand(this.op, this.key, {this.field, this.apply, this.done});
  final TableOperation op;
  final String key;

  /// [apply]'ın yazdığı metadata alanı.
  final _MetaField? field;

  /// Makbuzla gelen yerel görünüm güncellemesi (ad, sütun). YALNIZ makbuz sırası hem
  /// uygulanmış snapshot sırasından hem de aynı alana uygulanmış son makbuz sırasından yeniyse
  /// çalışır: geciken makbuz daha yeni snapshot'ı ya da aynı alandaki daha yeni kendi
  /// makbuzumuzu geri ezmez; farklı alanların güncellemeleri birbirini engellemez.
  final void Function(TableReceipt r)? apply;

  /// Her başarıda çalışan sonuç işlemi (liste güncellemesi, silindi işareti); ilk deneme ve
  /// [TableCommands.retryCommands] aynı işleyiciyi kullanır.
  final void Function(TableReceipt r)? done;
}

/// Tablo komutları. Her yeni kullanıcı işlemi YENİ işlem anahtarı alır (aynı gövdeli iki
/// ayrı işlem — ör. iki "satır ekle" — iki ayrı kayıttır). Sonucu bilinmeyen komut
/// [TableView.uncertainCommands] olarak bekletilir; "yeniden dene" ([retryCommands]) aynı
/// işlem nesnesini ve anahtarını yollar (sunucu yazdıysa `replayed` makbuz döner, kayıt tek
/// kalır). Belirsiz komut beklerken yeni işlem engellenmez; kendi anahtarıyla gider. Makbuz
/// alındıktan sonraki yan okuma düşerse komut başarılı sayılır; sonraki yakalama tabloyu
/// yeniden okur ([TableController._needsReload]).
extension TableCommands on TableController {
  int get _schema => _base!.meta.schemaVersion;

  /// Komutu gönderir (önce bekleyen hücreler). Yazım hatası fırlar; 403 tabloyu salt okunur
  /// yapar, 409 `tables.schema_conflict` tabloyu yeniden okutur.
  Future<TableReceipt> _command(
    TableOperation op, {
    bool reload = true,
    _PendingCommand? retry,
    _MetaField? field,
    void Function(TableReceipt r)? apply,
    void Function(TableReceipt r)? done,
  }) async {
    await flush();
    final pending =
        retry ??
        _PendingCommand(
          op,
          newRequestKey(),
          field: field,
          apply: apply,
          done: done,
        );
    final generation = _generation;
    final TableReceipt r;
    try {
      r = await _repo.apply(_scope, _id, pending.op, requestKey: pending.key);
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
      if (generation == _generation && _mounted) {
        if (isOutcomeUnknown(e)) {
          if (!_uncertain.contains(pending)) _uncertain.add(pending);
        } else {
          _uncertain.remove(pending);
        }
        _update((b) => b.copyWith(uncertainCommands: _uncertain.length));
        if (e.code == 'tables.forbidden') {
          _update((b) => b.copyWith(readOnly: true));
        } else if (e.code == 'tables.schema_conflict') {
          await _sideRead();
        }
      }
      rethrow;
    }
    _uncertain.remove(pending);
    ownSequences.add(r.sequence);
    if (generation == _generation && _mounted) {
      final field = pending.field;
      final floor = math.max(
        _viewSequence,
        field == null ? 0 : (_fieldSequence[field] ?? 0),
      );
      if (r.sequence > floor) {
        pending.apply?.call(r);
        if (field != null) _fieldSequence[field] = r.sequence;
      }
      pending.done?.call(r);
      if (r.sequence > _confirmedSequence) _confirmedSequence = r.sequence;
      _update(
        (b) => b.copyWith(
          uncertainCommands: _uncertain.length,
          meta: b.meta.copyWith(
            sequence: r.sequence > b.meta.sequence ? r.sequence : null,
            // Şema sürümü monotondur: geciken makbuz daha yeni şemayı geri almaz.
            schemaVersion: r.schemaVersion > b.meta.schemaVersion
                ? r.schemaVersion
                : null,
          ),
        ),
      );
      if (reload) await _sideRead();
    }
    return r;
  }

  /// Sonucu bilinmeyen komutları AYNI işlem nesnesi ve anahtarla yeniden yollar. İlk hata
  /// fırlar (kalanlar bekler).
  Future<void> retryCommands() async {
    for (final p in [..._uncertain]) {
      await _command(p.op, retry: p, reload: p.op is! DeleteTable);
    }
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
    await _command(
      RenameTable(trimmed),
      reload: false,
      field: const _MetaField.tableName(),
      apply: (_) {
        _update((b) => b.copyWith(meta: b.meta.copyWith(name: trimmed)));
        _listOrNull?.renamed(_id, trimmed);
      },
    );
  }

  /// Yalnız sahip; başarıda (yeniden deneme dahil) listeden düşer ve görünüm "silindi" olur
  /// (ekran listeye döner).
  Future<void> deleteTable() async {
    _queue.clear();
    await _command(
      const DeleteTable(),
      reload: false,
      done: (_) {
        _listOrNull?.removed(_id);
        _update((b) => b.copyWith(deleted: true));
      },
    );
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
      field: _MetaField.columnName(columnId),
      apply: (_) => _patchColumn(columnId, (c) => c.copyWith(name: trimmed)),
    );
  }

  Future<void> resizeColumn(String columnId, int width) async {
    await _command(
      ResizeColumn(id: columnId, width: width, expectedSchema: _schema),
      reload: false,
      field: _MetaField.columnWidth(columnId),
      apply: (_) => _patchColumn(columnId, (c) => c.copyWith(width: width)),
    );
  }

  void _patchColumn(
    String columnId,
    TableColumnSpec Function(TableColumnSpec c) change,
  ) => _update(
    (b) => b.copyWith(
      columns: [for (final c in b.columns) c.id == columnId ? change(c) : c],
    ),
  );

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
