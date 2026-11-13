import '../../../core/domain/page_slice.dart';
import 'table_models.dart';
import 'table_operation.dart';

/// Tablolar uçları (backend `tables` modülü). Her yöntem [TableScope] alır: koordinatörlük
/// alanı `/v1/tables…` (S3: program + departman), kişisel alan `/v1/personal/tables…` (S2:
/// program) rotasına gider; kapsam başlıkları istek başına bu değerle sabitlenir.
/// Gerçekleştirme `data/table_api_repository.dart`. Bütün hatalar `ApiError`.
///
/// Yazma uçları `Idempotency-Key` ister ([requestKey], 22–200 bayt): aynı anahtar + aynı
/// gövde ilk makbuzu `replayed: true` ile döndürür; farklı gövde 409
/// `tables.idempotency_key_reused`. Sözleşme özeti:
/// `docs/architecture/tablolar-backend-ve-canli-calisma.md`.
abstract interface class TablesRepository {
  /// `GET /v1/tables` · `/v1/personal/tables` — görünür tablolar, imleçli (limit 1–200,
  /// varsayılan 100). [template] verilirse yalnız şablonlar / şablon olmayanlar.
  Future<PageSlice<TableMeta>> list(
    TableScope scope, {
    PageRequest page = const PageRequest(),
    bool? template,
  });

  /// `POST /v1/tables` · `/v1/personal/tables` — yeni boş tablo; oluşturan sahip olur.
  Future<TableReceipt> create(
    TableScope scope,
    String name, {
    required String requestKey,
  });

  /// `GET /v1/tables/{id}` — tek snapshot sayfası (satır imleci opak). Yanıt 8 MiB'ı
  /// aşarsa 409 `tables.limit_reached` (limit düşürülür).
  Future<TableSnapshotPage> snapshot(
    TableScope scope,
    String tableId, {
    PageRequest page = const PageRequest(),
  });

  /// `POST /v1/tables/{id}/operations` — tek komut. Çakışmalar: 409
  /// `tables.cell_conflict` (bayat hücre sürümü, batch geri alınır),
  /// `tables.schema_conflict` (bayat `expected_schema`); zarf güncel değeri taşımaz.
  Future<TableReceipt> apply(
    TableScope scope,
    String tableId,
    TableOperation operation, {
    required String requestKey,
  });

  /// `GET /v1/tables/{id}/changes?after=` — olay günlüğü (yalnız metadata). Ufuk dışı
  /// imleç 409 `tables.replay_expired` (`fields[0].message`: future|baseline|window|gap) →
  /// yerel görünüm atılır, tam snapshot okunur.
  Future<TableChangesPage> changes(
    TableScope scope,
    String tableId, {
    required int after,
    int? limit,
  });

  /// `GET /v1/tables/{id}/comments` — `seq` artan; imleç son tüketilen yorumun `seq`'i.
  Future<PageSlice<TableCommentItem>> comments(
    TableScope scope,
    String tableId, {
    String? rowId,
    PageRequest page = const PageRequest(),
  });

  /// `POST /v1/tables/{id}/presence` — seçili hücre (ikisi birlikte ya da ikisi null).
  /// İşlem anahtarı yok; aynı oturumdan 1 sn'den sık → 429 `tables.presence_throttled`.
  Future<void> setPresence(
    TableScope scope,
    String tableId, {
    String? rowId,
    String? columnId,
  });

  /// `DELETE /v1/tables/{id}/presence` — çağıran oturumun kaydı; idempotent.
  Future<void> leavePresence(TableScope scope, String tableId);

  /// `GET /v1/tables/{id}/stream` — SSE. Açılış hatası (401/403/404/422/429/503) akışın
  /// ilk hatası olarak gelir; sunucu kapanışı akışın bitişidir (neden bildirilmez).
  /// Dinleyici bırakınca bağlantı kapanır.
  Stream<TableStreamEvent> stream(TableScope scope, String tableId);
}
