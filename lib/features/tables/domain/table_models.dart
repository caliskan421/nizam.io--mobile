// Tablolar domain modeli (backend `tables` modülü; sözleşme özeti
// `docs/architecture/tablolar-backend-ve-canli-calisma.md`). Saf Dart, değişmez (S4).
import 'package:meta/meta.dart';

/// Tablonun çalışma alanı. Koordinatörlük alanı S3 (program + departman başlığı), kişisel
/// alan S2 (yalnız program) kapsamıyla okunur ve yazılır.
enum TableSpace { coordinatorship, personal, unknown }

/// Sütun tipi. Tip kümesi ekleyici genişler: bilinmeyen tip [unknown] olur ve gösterilmez.
enum TableColumnKind {
  text,
  number,
  phone,
  email,
  date,
  checkbox,
  tableReference,
  personReference,
  departmentReference,
  taskReference,
  fileReference,
  attachment,
  unknown;

  /// Referans tipi mi (`*_reference`); yalnız bunlarda `multiple` olabilir.
  bool get isReference => switch (this) {
    tableReference ||
    personReference ||
    departmentReference ||
    taskReference ||
    fileReference => true,
    _ => false,
  };
}

/// Koordinatörlük ekibinin tablo rolü (`team_role`); kişisel alanda yoktur.
enum TableTeamRole { editor, viewer, unknown }

/// Hesap bazlı paylaşım rolü (`grant`).
enum TableGrantRole { editor, viewer }

/// İsteğin kapsamı: alan + program (+ koordinatörlükte departman). Kapsam başlığı yetki
/// vermez (TABLES-K01); bir alanın tablo kimliği diğer alanın rotasında 404'tür (K-11).
@immutable
final class TableScope {
  const TableScope.coordinatorship({
    required this.programId,
    required String this.departmentId,
  }) : space = TableSpace.coordinatorship;

  const TableScope.personal({required this.programId})
    : space = TableSpace.personal,
      departmentId = null;

  final TableSpace space;
  final String programId;

  /// Yalnız koordinatörlük alanında dolu.
  final String? departmentId;

  @override
  bool operator ==(Object other) =>
      other is TableScope &&
      other.space == space &&
      other.programId == programId &&
      other.departmentId == departmentId;

  @override
  int get hashCode => Object.hash(space, programId, departmentId);
}

/// Tablo üst bilgisi (`Table`). [schemaVersion] sütun komutlarının `expected_schema`'sı,
/// [sequence] tablonun işlem sırası (olay günlüğü imlecinin başlangıcı).
@immutable
final class TableMeta {
  const TableMeta({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.scope,
    required this.schemaVersion,
    required this.sequence,
    this.teamRole,
    this.projectId,
    this.isTemplate = false,
  });

  final String id;
  final String ownerId;
  final String name;
  final TableScope scope;
  final int schemaVersion;
  final int sequence;
  final TableTeamRole? teamRole;
  final String? projectId;
  final bool isTemplate;

  TableSpace get space => scope.space;

  /// Sahip mi. Sahip dışı hesabın rolü (editor/viewer) sözleşmede okunamaz; yazma 403
  /// `tables.forbidden` alırsa istemci tabloyu salt okunur sayar.
  bool ownedBy(String? accountId) => accountId != null && ownerId == accountId;

  TableMeta copyWith({String? name, int? schemaVersion, int? sequence}) =>
      TableMeta(
        id: id,
        ownerId: ownerId,
        name: name ?? this.name,
        scope: scope,
        schemaVersion: schemaVersion ?? this.schemaVersion,
        sequence: sequence ?? this.sequence,
        teamRole: teamRole,
        projectId: projectId,
        isTemplate: isTemplate,
      );
}

@immutable
final class TableColumnSpec {
  const TableColumnSpec({
    required this.id,
    required this.name,
    required this.kind,
    required this.width,
    required this.position,
    this.multiple = false,
  });

  final String id;
  final String name;
  final TableColumnKind kind;

  /// Piksel genişliği (40–1200).
  final int width;
  final int position;
  final bool multiple;

  TableColumnSpec copyWith({String? name, int? width}) => TableColumnSpec(
    id: id,
    name: name ?? this.name,
    kind: kind,
    width: width ?? this.width,
    position: position,
    multiple: multiple,
  );
}

@immutable
final class TableRowRef {
  const TableRowRef({required this.id, required this.position});
  final String id;
  final int position;
}

/// Hücre anahtarı (satır + sütun kimliği).
extension type const TableCellKey._(String _key) {
  factory TableCellKey(String rowId, String columnId) =>
      TableCellKey._('$rowId\u0000$columnId');
}

/// Hücre içeriği. [value] ham JSON değeridir (String, num, bool ya da referans kimliği
/// listesi; `null` boş). Hiç yazılmamış hücre sürüm 0'dır ([empty]).
@immutable
final class TableCellData {
  const TableCellData({this.value, this.version = 0, this.redacted = false});

  static const empty = TableCellData();

  final Object? value;

  /// Hücre CAS sürümü: yazımda gönderilir; bayatsa 409 `tables.cell_conflict` (K-03).
  final int version;

  /// Okuyana görünmeyen referans gizlendi; bu değer körlemesine geri yazılamaz (K-14).
  final bool redacted;

  bool get isEmpty =>
      value == null ||
      value == '' ||
      (value is List && (value! as List).isEmpty);
}

/// Referans görünen adının türü (snapshot `references` haritası).
enum TableRefKind { people, departments, tasks, files, tables }

extension type const TableRefKey._(String _key) {
  factory TableRefKey(TableRefKind kind, String id) =>
      TableRefKey._('${kind.name}\u0000$id');
}

extension type const TableAttachmentId(String value) {}

@immutable
final class TableAttachmentInfo {
  const TableAttachmentInfo({
    required this.id,
    required this.name,
    required this.contentType,
    required this.sizeBytes,
  });
  final String id;
  final String name;
  final String contentType;
  final int sizeBytes;
}

/// Bir snapshot sayfası (`GET /v1/tables/{id}`). Satırlar konum sırasında; hücreler
/// satır/sütun kimliğiyle eşlenmiştir; yazılmamış hücre haritada yoktur.
@immutable
final class TableSnapshotPage {
  TableSnapshotPage({
    required this.meta,
    required List<TableColumnSpec> columns,
    required List<TableRowRef> rows,
    required Map<TableCellKey, TableCellData> cells,
    Map<TableRefKey, String> references = const {},
    Map<TableAttachmentId, TableAttachmentInfo> attachments = const {},
    this.nextCursor,
  }) : columns = List.unmodifiable(columns),
       rows = List.unmodifiable(rows),
       cells = Map.unmodifiable(cells),
       references = Map.unmodifiable(references),
       attachments = Map.unmodifiable(attachments);

  final TableMeta meta;
  final List<TableColumnSpec> columns;
  final List<TableRowRef> rows;
  final Map<TableCellKey, TableCellData> cells;
  final Map<TableRefKey, String> references;
  final Map<TableAttachmentId, TableAttachmentInfo> attachments;

  /// Sonraki satır sayfasının opak imleci; `null` son sayfa.
  final String? nextCursor;
}

/// Tek hücre yazımı (`set_cells` öğesi). [version] okunan sürüm (ilk yazım 0).
@immutable
final class TableCellWrite {
  const TableCellWrite({
    required this.rowId,
    required this.columnId,
    required this.value,
    required this.version,
  });
  final String rowId;
  final String columnId;
  final Object? value;
  final int version;

  TableCellKey get key => TableCellKey(rowId, columnId);
}

enum TableUndoSkipReason { gone, changed, unavailable, unknown }

@immutable
final class TableUndoSkip {
  const TableUndoSkip({
    required this.rowId,
    required this.columnId,
    required this.reason,
  });
  final String rowId;
  final String columnId;
  final TableUndoSkipReason reason;
}

/// İşlem makbuzu (`TableResult`). [sequence] bu yazımın tablo sırasıdır (yankı ayrımında
/// kullanılır); [replayed] aynı anahtarın tekrarıdır (komut ikinci kez uygulanmadı).
@immutable
final class TableReceipt {
  TableReceipt({
    required this.tableId,
    required this.sequence,
    required this.schemaVersion,
    required this.replayed,
    this.id,
    Map<TableCellKey, int> cellVersions = const {},
    List<TableUndoSkip> skipped = const [],
    this.converted,
  }) : cellVersions = Map.unmodifiable(cellVersions),
       skipped = List.unmodifiable(skipped);

  final String tableId;
  final int sequence;
  final int schemaVersion;
  final bool replayed;

  /// Oluşturulan/hedef kimlik (tablo, yeni satır/sütun, yorum).
  final String? id;

  /// `set_cells`/`undo_cells`: yazılan hücrelerin YENİ sürümleri.
  final Map<TableCellKey, int> cellVersions;

  /// `undo_cells`: geri alınamayan hücreler.
  final List<TableUndoSkip> skipped;

  /// `convert_column`: dönüştürülen hücre sayısı.
  final int? converted;
}

/// Olay günlüğü türü (`TableChange.kind`); bilinmeyen tür [unknown].
enum TableChangeKind {
  renameTable,
  deleteTable,
  addColumn,
  renameColumn,
  resizeColumn,
  deleteColumn,
  moveColumn,
  addRow,
  deleteRow,
  moveRow,
  setCells,
  grant,
  revoke,
  setTeamRole,
  setTemplate,
  setProject,
  uploadAttachment,
  convertColumn,
  moveTable,
  addComment,
  editComment,
  deleteComment,
  undoCells,
  unknown,
}

@immutable
final class TableChangeEntry {
  const TableChangeEntry({required this.seq, required this.kind});
  final int seq;
  final TableChangeKind kind;
}

/// `GET …/changes` yanıtı. [cursor] son döndürülen sıra (olay yoksa istekteki `after`),
/// [sequence] okuma anındaki tablo sırası, [more] `cursor < sequence`.
@immutable
final class TableChangesPage {
  TableChangesPage({
    required List<TableChangeEntry> changes,
    required this.cursor,
    required this.sequence,
    required this.more,
  }) : changes = List.unmodifiable(changes);
  final List<TableChangeEntry> changes;
  final int cursor;
  final int sequence;
  final bool more;
}

/// Canlı akış çerçevesi. `ready`/`changed` içeriksiz sıra ipucudur (tüketilmiş imleç
/// değildir); doğruluk `changes` + snapshot'tan gelir (K-23/K-24).
sealed class TableStreamEvent {
  const TableStreamEvent();
}

final class TableStreamReady extends TableStreamEvent {
  const TableStreamReady(this.sequence);
  final int sequence;
}

final class TableStreamChanged extends TableStreamEvent {
  const TableStreamChanged(this.sequence);
  final int sequence;
}

/// Tam katılımcı listesi (delta değil); alıcının kendi oturumu listede yoktur.
final class TablePresenceUpdate extends TableStreamEvent {
  TablePresenceUpdate(List<TableParticipant> participants)
    : participants = List.unmodifiable(participants);
  final List<TableParticipant> participants;
}

@immutable
final class TableParticipant {
  const TableParticipant({
    required this.key,
    required this.accountId,
    required this.name,
    this.rowId,
    this.columnId,
  });

  /// Opak süreç içi katılımcı anahtarı (oturum kimliği değil).
  final String key;
  final String accountId;
  final String name;

  /// Seçimsiz katılımcıda null.
  final String? rowId;
  final String? columnId;
}

@immutable
final class TableCommentItem {
  const TableCommentItem({
    required this.id,
    required this.rowId,
    required this.mine,
    required this.body,
    required this.seq,
    required this.createdAt,
    this.columnId,
    this.authorId,
    this.authorName,
    this.editedAt,
  });
  final String id;
  final String rowId;
  final String? columnId;

  /// Yazar okuyana görünmüyorsa null.
  final String? authorId;
  final String? authorName;
  final bool mine;
  final String body;

  /// Değişmez oluşturma sırası; sayfa imleci budur.
  final int seq;
  final DateTime createdAt;
  final DateTime? editedAt;
}
