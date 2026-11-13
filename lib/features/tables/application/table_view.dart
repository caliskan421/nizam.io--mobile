import 'package:meta/meta.dart';

import '../../../core/errors/api_error.dart';
import '../domain/table_models.dart';

/// Mobilde düzenlenebilen sütun tipleri. Referans (kişi/departman/görev/dosya/tablo) seçicileri
/// ve ek yükleme henüz bağlanmadı: bu sütunlar gösterilir, düzenlenmez.
const editableColumnKinds = {
  TableColumnKind.text,
  TableColumnKind.number,
  TableColumnKind.phone,
  TableColumnKind.email,
  TableColumnKind.date,
  TableColumnKind.checkbox,
};

/// Seçiciyle yazılan referans tipleri (ek sütunu yalnız yükleme ucuyla yazılır; mobilde yok).
const referenceColumnKinds = {
  TableColumnKind.tableReference,
  TableColumnKind.personReference,
  TableColumnKind.departmentReference,
  TableColumnKind.taskReference,
  TableColumnKind.fileReference,
};

/// Referans sütun tipinin görünen ad grubu (snapshot `references` haritası).
TableRefKind? tableRefKindOf(TableColumnKind kind) => switch (kind) {
  TableColumnKind.personReference => TableRefKind.people,
  TableColumnKind.departmentReference => TableRefKind.departments,
  TableColumnKind.taskReference => TableRefKind.tasks,
  TableColumnKind.fileReference => TableRefKind.files,
  TableColumnKind.tableReference => TableRefKind.tables,
  _ => null,
};

/// Tablo ekranının durumu: yüklenen snapshot sayfaları + yerel (henüz gönderilmemiş ya da
/// uçuştaki) hücre düzenlemeleri.
@immutable
final class TableView {
  TableView({
    required this.meta,
    required List<TableColumnSpec> columns,
    required List<TableRowRef> rows,
    required Map<TableCellKey, TableCellData> cells,
    required this.accountId,
    Map<TableRefKey, String> references = const {},
    Map<TableAttachmentId, TableAttachmentInfo> attachments = const {},
    this.nextCursor,
    this.loadingMore = false,
    this.readOnly = false,
    this.pendingWrites = 0,
    this.writeError,
    Set<TableCellKey> conflicts = const {},
    this.undoSequence,
    this.commentsRevision = 0,
    this.accessLost = false,
    this.uncertainCommands = 0,
    this.deleted = false,
  }) : columns = List.unmodifiable(columns),
       rows = List.unmodifiable(rows),
       cells = Map.unmodifiable(cells),
       references = Map.unmodifiable(references),
       attachments = Map.unmodifiable(attachments),
       conflicts = Set.unmodifiable(conflicts);

  factory TableView.fromPage(TableSnapshotPage page, String? accountId) =>
      TableView(
        meta: page.meta,
        columns: page.columns,
        rows: page.rows,
        cells: page.cells,
        references: page.references,
        attachments: page.attachments,
        nextCursor: page.nextCursor,
        accountId: accountId,
      );

  final TableMeta meta;
  final List<TableColumnSpec> columns;
  final List<TableRowRef> rows;
  final Map<TableCellKey, TableCellData> cells;
  final Map<TableRefKey, String> references;
  final Map<TableAttachmentId, TableAttachmentInfo> attachments;
  final String? accountId;

  /// Sonraki satır sayfası imleci; null → bütün satırlar yüklü.
  final String? nextCursor;
  final bool loadingMore;

  /// Sunucu yazmayı reddetti (403 `tables.forbidden`): düzenleme denetimleri kapanır.
  /// Sahip dışı hesabın rolü sözleşmede okunmadığı için başlangıçta düzenlenebilir sayılır.
  final bool readOnly;

  /// Gönderilmeyi ya da yanıtı bekleyen hücre sayısı.
  final int pendingWrites;

  /// Son hücre gönderiminin sonucu bilinmeyen hatası (yeniden deneme kullanıcıyla).
  final ApiError? writeError;

  /// Başkası değiştirdiği için yazılamayan hücreler (sunucu değeri gösteriliyor).
  final Set<TableCellKey> conflicts;

  /// Geri alınabilecek son kendi `set_cells` sırası.
  final int? undoSequence;

  /// Yorum değişikliği sayacı: canlı akış ya da kendi yorum komutu yorum olayı görünce artar;
  /// açık yorum listeleri buna göre yeniden okunur (snapshot yorum taşımaz, K-26).
  final int commentsRevision;

  /// Tablo bu oturumda silindi (ekran listeye döner).
  final bool deleted;

  /// Sonucu bilinmeyen (yeniden denenebilir) komut sayısı.
  final int uncertainCommands;

  /// Canlı senkronda tabloya erişim kaybı (changes 403/404): görünüm salt okunur kalır.
  final bool accessLost;

  bool get isOwner => meta.ownedBy(accountId);
  bool get editable => !readOnly && !accessLost && !deleted;
  bool get hasMore => nextCursor != null;

  TableCellData cell(String rowId, String columnId) =>
      cells[TableCellKey(rowId, columnId)] ?? TableCellData.empty;

  TableColumnSpec? column(String id) =>
      columns.where((c) => c.id == id).firstOrNull;

  /// Referans kimliğinin görünen adı (yoksa null).
  String? referenceName(TableColumnKind kind, String id) {
    final group = tableRefKindOf(kind);
    return group == null ? null : references[TableRefKey(group, id)];
  }

  TableView copyWith({
    TableMeta? meta,
    List<TableColumnSpec>? columns,
    List<TableRowRef>? rows,
    Map<TableCellKey, TableCellData>? cells,
    Map<TableRefKey, String>? references,
    String? Function()? nextCursor,
    bool? loadingMore,
    bool? readOnly,
    int? pendingWrites,
    ApiError? Function()? writeError,
    Set<TableCellKey>? conflicts,
    int? Function()? undoSequence,
    int? commentsRevision,
    bool? accessLost,
    int? uncertainCommands,
    bool? deleted,
  }) => TableView(
    meta: meta ?? this.meta,
    columns: columns ?? this.columns,
    rows: rows ?? this.rows,
    cells: cells ?? this.cells,
    references: references ?? this.references,
    attachments: attachments,
    accountId: accountId,
    nextCursor: nextCursor == null ? this.nextCursor : nextCursor(),
    loadingMore: loadingMore ?? this.loadingMore,
    readOnly: readOnly ?? this.readOnly,
    pendingWrites: pendingWrites ?? this.pendingWrites,
    writeError: writeError == null ? this.writeError : writeError(),
    conflicts: conflicts ?? this.conflicts,
    undoSequence: undoSequence == null ? this.undoSequence : undoSequence(),
    commentsRevision: commentsRevision ?? this.commentsRevision,
    accessLost: accessLost ?? this.accessLost,
    uncertainCommands: uncertainCommands ?? this.uncertainCommands,
    deleted: deleted ?? this.deleted,
  );

  /// Yeni sayfa(lar)la birleştirir: satırlar eklenir, hücre/referans/ek haritaları birleşir.
  TableView appendPage(TableSnapshotPage page) => TableView(
    meta: page.meta,
    columns: page.columns,
    rows: [...rows, ...page.rows],
    cells: {...cells, ...page.cells},
    references: {...references, ...page.references},
    attachments: {...attachments, ...page.attachments},
    accountId: accountId,
    nextCursor: page.nextCursor,
    readOnly: readOnly,
    pendingWrites: pendingWrites,
    writeError: writeError,
    conflicts: conflicts,
    undoSequence: undoSequence,
    commentsRevision: commentsRevision,
    accessLost: accessLost,
    uncertainCommands: uncertainCommands,
    deleted: deleted,
  );
}
