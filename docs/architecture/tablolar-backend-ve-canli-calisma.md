# Tablolar: backend sözleşmesi ve canlı ortak çalışma (mobil)

Mobil tablolar diliminin hafızası. Bölüm 1–7 backend sözleşmesinin mobil için özetidir;
bölüm 8–9 mobil tasarımıdır. Yetkili kaynak backend'dir; buradaki her başvuru backend
deposuna göredir (`nizam.io--backend/`, dal `f64/ortak-calisma-faz3`). Kısaltmalar:
**K-NN** = `internal/modules/tables/README.md` §3 kuralı `TABLES-KNN`; **OA** =
`docs/api/openapi.yaml`; **APIR** = `docs/api/README.md`.

> **Kırmızı — pin geçicidir.** `api-pin.json` `backendTag` = `f64-faz3-onizleme`: backend
> deposunda değil, yerel bir önizleme klonunda konmuş etikettir (dal
> `f64/ortak-calisma-faz3`'ün ucu). Canlı ortak çalışma uçları (changes, stream, presence,
> comments, undo) yayımlı hiçbir `v*-api` etiketinde yok; son yayımlı `v0.17.0-api` yalnız
> çekirdek CRUD'u taşır. Birleşmeden önce pin backend'in gerçek etiketine çevrilir ve
> `make gen` yeniden koşulur; CI (`.backend/` klonu) bu önizleme etiketini bulamaz.

## 1. Ortak kurallar

| Konu | Kural | Kaynak |
|---|---|---|
| Kimlik | `Authorization: Bearer`; SSE dahil bilet yok | APIR:57-80; `internal/composition/tables.go:74` |
| Kapsam | `/v1/tables…`, `/v1/table-*` S3 (program + departman başlığı); `/v1/personal/…` S2 (yalnız program). Başlık yetki vermez (K-01); bir alanın kimliği diğer alanın rotasında 404 (K-11) | APIR:81-95, OA:97-112 |
| CSRF | Her POST/DELETE (presence dahil) `X-Requested-With`; yoksa 403 `platform.csrf_header_missing` (mobil ara katman koyar) | `internal/platform/httpguard/guard.go:195-211` |
| İşlem anahtarı | `Idempotency-Key` 22–200 bayt; create, operations, proje, kopya, öneri kararı, ek yükleme. Presence ve GET'ler almaz | OA:269; K-04; `adapter/http/http.go:129-135` |
| Anahtar tekrarı | Aynı anahtar + aynı yük → ilk makbuz `replayed: true`, ikinci uygulama/olay yok. Farklı yük → 409 `tables.idempotency_key_reused`. Yük bayt-bayt karşılaştırılır (`1e3` ≠ `1000`) | K-04; `usecase/stream.go:81-92` |
| Anahtar eksik | 422 `tables.input_invalid`, `fields[0]` = `idempotency_key` / `tables.request_key_required|invalid` | `internal/composition/errors.go:700-703` |
| Sayfalama | `limit` 1–200, **varsayılan 100**, opak `cursor`, `next_cursor` yalnız devam varsa | `adapter/http/http.go:373-384` |
| Hız | okuma 600/dk, **yazma 60/dk** (bütün POST/DELETE + akış açılışı + presence), IP 3000/dk; aşımda 429 `platform.rate_limited` + `Retry-After` | `internal/platform/config/schema.go:444-462`; `internal/composition/http.go:1300-1312` |

## 2. Uçlar

| Uç (S3; kişisel ikiz S2) | Gövde/sorgu | Başarı | Mobil |
|---|---|---|---|
| `GET /v1/tables` | `cursor`, `limit`, `template` | `TableList` | bağlı |
| `POST /v1/tables` | `{name, kind?: create_table}` + IK | 201/200 `TableResult` | bağlı |
| `GET /v1/tables/{id}` | `cursor`, `limit`, `filter`×≤3, `sort`×≤2 | `TableSnapshot` | bağlı (filter/sort yok) |
| `POST /v1/tables/{id}/operations` | `TableCommand` + IK | `TableResult` | bağlı (§4) |
| `GET /v1/tables/{id}/changes` | `after` (zorunlu), `limit` | `TableChanges` | bağlı (yakalama) |
| `GET /v1/tables/{id}/stream` | — | `text/event-stream` | bağlı (canlı döngü) |
| `POST/DELETE /v1/tables/{id}/presence` | `{row_id, column_id}` (ikisi birlikte ya da ikisi boş) | 204 | bağlı |
| `GET /v1/tables/{id}/comments` | `row_id?`, `cursor?` (= `seq`), `limit` 1–50 | `TableCommentPage` | bağlı (satır yorumları) |
| `POST/GET …/attachments` | multipart `file` + `row_id`, `column_id`, `cell_version` | `TableResult` / dosya | yok |
| `/v1/table-projects`, `/v1/table-copies`, `/v1/table-proposals…` | — | — | yok |

Kaynak: `internal/modules/tables/README.md:44-83`; rota sabitleri `adapter/http/http.go:21-43`,
`stream.go:23-26`, `presence.go:13-18`, `comment.go:12-15`.

## 3. Veri modeli

- **Table** (OA:312-365): `id, owner_id, name (1–200), program_id, department_id ("" kişisel),
  space (personal|coordinatorship), team_role? (editor|viewer), project_id?, is_template,
  schema_version (≥1), sequence (≥0)`. `schema_version` her sütun şeması değişiminde artar;
  `sequence` olay üreten her yazımda +1'dir.
- **Rol okunmaz:** yanıt çağıranın editor/viewer rolünü taşımaz; yalnız `owner_id` ve ekip
  rolü vardır. Mobil sahip dışındaki tabloyu düzenlenebilir sayar, yazım 403
  `tables.forbidden` alırsa salt okunur moda geçer (açık #3).
- **Column** (OA:366-391): `id, name, type, width (40–1200), position, multiple`. Tipler:
  `text, number, phone, email, date, checkbox, table_reference, person_reference,
  department_reference, task_reference, file_reference, attachment`; bilinmeyen tip
  atlanır (ekleyici genişler). `multiple` yalnız referanslarda, sonradan değişmez.
- **Row**: `{id, position}`; konum artan sıradır, yeni satır mevcut konumları değiştirmez (K-19).
- **Cell** (OA:414-466): `{row_id, column_id, value, version, redacted?}`. Yazılmamış hücre
  yanıtta yoktur (boş, sürüm 0). `value` null = boş; metin ≤10000 bayt, telefon ≤40 bayt
  (`0-9 + boşluk - ( )`), e-posta tek adres, tarih `YYYY-MM-DD`, sayı JSON ondalık (sunucu
  normalize eder: `1e3`→`1000`, K-06), checkbox bool, tekli referans kimlik, çoklu referans
  1–50 benzersiz kimlik, ek yalnız upload ile dolar (`set_cells` yalnız null kabul eder).
  Hücre JSON ≤16 KiB (`domain/model.go:448-543`).
- **Redaksiyon:** görünmeyen referans `null` + `redacted: true`; çoklu hücrede aynı konumda
  null. İstekte `redacted: true` 422 — redakte hücre körlemesine geri yazılmaz (K-14).
- **Snapshot** (OA:1410-1457): `table, columns, rows, cells (sırasız), next_cursor?,
  references?{people|departments|tasks|files|tables: {id: ad}}, attachments?{id: meta}`.
  Yanıt 8 MiB'ı aşarsa 409 `tables.limit_reached` (K-22). Yorum taşımaz (K-26).
- **TableResult** (OA:1204-1244): `table_id, sequence (bu yazımın sırası), schema_version,
  replayed, id?, cells? (set_cells/undo: yeni sürümler, değer null), skipped? (undo),
  cleared_grants?, status?, converted?`.

## 4. Komutlar ve iyimser eşzamanlılık

`POST …/operations` gövdesi `kind` ayırıcılı `TableCommand` (OA:480-545;
`domain/model.go:166-202`). ETag/If-Match yoktur; eşzamanlılık gövdededir:

| kind | Zorunlu | CAS | Mobil |
|---|---|---|---|
| `rename_table` / `delete_table` (sahip) | name / — | — | bağlı |
| `add_column` | name, type, width, expected_schema | şema | bağlı |
| `rename_column`, `resize_column`, `delete_column`, `move_column`, `convert_column` | id, …, expected_schema | şema | convert hariç bağlı |
| `add_row`, `delete_row`, `move_row` | — / id / id, after_id? | — | bağlı |
| `set_cells` | cells[1..100] {row_id, column_id, value, version} | hücre | bağlı |
| `undo_cells` | sequence (kendi set_cells'i, ≤1000 olay geride) | koşullu | bağlı |
| `grant`, `revoke`, `set_team_role`, `set_template` (sahip) | … | — | depo var, ekran yok |
| `add_comment`, `edit_comment`, `delete_comment` | … | — | ekleme/silme ekranda; düzenleme denetleyicide |
| `set_project`, `move_table`, `propose_*`, `withdraw_proposal` | … | — | yok |

- **Hücre CAS** (K-03, K-05): `version: 0` ilk yazım; sonraki yazım mevcut sürümü ister.
  Bayat sürüm → 409 `tables.cell_conflict`, **bütün batch geri alınır**. Başarıda makbuz
  yazılan her hücrenin yeni sürümünü verir. Eksik/null `version` 422
  (`adapter/http/http.go:342-347`).
- **Şema CAS** (K-08): sütun komutları `expected_schema` = `table.schema_version`; bayat → 409
  `tables.schema_conflict`.
- **Çakışma zarfı içerik taşımaz** (`internal/composition/errors.go:744-747`): istemci tabloyu
  yeniden okur; niyet sürüyorsa güncel sürüm ve **yeni** anahtarla tekrar gönderir.
- Tek batch tek komuttur; farklı komutları birleştiren toplu uç yoktur.

## 5. Hata kodları ve istemci davranışı

| Kod | HTTP | Mobil davranış |
|---|---|---|
| `tables.input_invalid` | 422 | gönderim düşer, tablo yeniden okunur, toast |
| `tables.reference_unavailable` / `query_too_broad` | 422 | toast |
| `tables.forbidden` | 403 | tablo salt okunur; bekleyen hücreler düşer |
| `tables.not_found` | 404 | derin bağlantıda koordinatörlük → kişisel denenir; yoksa hata ekranı |
| `tables.cell_conflict` | 409 | §9.2 yakınsama |
| `tables.schema_conflict` | 409 | tablo yeniden okunur, toast; kullanıcı yeniden dener |
| `tables.idempotency_key_reused` | 409 | anahtar düşer; otomatik tekrar yok |
| `tables.limit_reached` | 409 | toast (sütun 100, satır 100000, 8 MiB, yorum 500) |
| `tables.conversion_lossy` | 409 | (convert ekranı yok) |
| `tables.cursor_stale` | 409 | (filter/sort yok) |
| `tables.replay_expired` | 409 | `fields[0].message` future/baseline/window/gap → görünüm atılır, tam snapshot |
| `tables.undo_expired` / `undo_conflict` | 409 | toast |
| `tables.presence_throttled` | 429 | `Retry-After: 1` |
| `tables.stream_unavailable` | 503 | geri çekilmeyle yeniden bağlan |
| `platform.rate_limited` | 429 | hücre batch'i `Retry-After` sonra aynı gövde/anahtarla gider |
| zaman aşımı / ağ / 5xx | — | sonuç bilinmiyor: AYNI anahtarla kullanıcı yeniden dener |

Kodlar: `docs/api/error-codes.json:894-1000`; çeviri `internal/composition/errors.go:698-750`.
TR metinleri web pininde henüz yok; geçici olarak `i18n/server_errors_ek.tr.json`'da.

## 6. Canlı ortak çalışma mekanizması

Tasarım (README:6; K-23/K-24; ADR-0039): **canlı iletim içeriksiz sıra uyarısıdır.** Doğruluk
kaynağı kalıcı olay günlüğü (`/changes`, yalnız metadata) + güncel snapshot'tır.

- **Olay günlüğü** (K-23; `adapter/store/events.go:50-64`): olay üreten her yazım aynı
  işlemde tek olay yazar, `seq` = yeni `table.sequence`, tablo başına boşluksuz. Olay
  üretmeyenler: create, kopya, öneri komutları, proje komutları, tekrar (replayed), presence,
  harici referans adı değişimi (README:115).
- **`GET …/changes`** (OA:5911-6007; `usecase/changes.go:21-73`): `after` zorunlu
  (`^(0|[1-9][0-9]{0,18})$`), `limit` 1–200. Yanıt `{changes:[{seq, kind}], cursor, sequence,
  more}`; `cursor` son döndürülen seq (olay yoksa istekteki after). Değer/aktör/zaman yok.
  409 `replay_expired`: future (after > sıra), baseline (taban öncesi), window (fark >
  **10000**), gap (eksik olay) → tam snapshot (`domain/event.go:11, 33-78`).
- **`GET …/stream`** (OA:6100-6211; `adapter/http/stream.go`, `usecase/stream.go`):
  - Açılış: kapı → abonelik → taze Head, toplam 2 sn; hata başlık yazılmadan JSON zarfıyla
    (401/403/404/422/429/503). Açılış **yazma kovasından** harcar.
  - Çerçeveler: `event: ready` `{table_id, sequence}` (açılış sırası), `event: changed`
    (birleştirilebilir, yalnız artar), `event: presence` (tam liste), `: ping` (25 sn).
    `id:`/`retry:` yok; `Last-Event-ID` ve `after` okunmaz (K-24).
  - `sequence` **tüketilmiş imleç değildir**, ipucudur.
  - Kendi yazımınız da `changed` üretir (aktör ayrımı yok). `grant`, `revoke`,
    `set_team_role`, `delete_table`, `move_table` uyarı yerine o tablonun bütün
    aboneliklerini kapatır (`usecase/stream.go:73-105`).
  - Kapanış nedeni bildirilmez (EOF): istemci, 5 dk bütçe (0–60 sn jitter; 
    `internal/composition/messaging.go:61, 109-117`), erişim commit'i, 25 sn'lik gözcünün
    oturum/üyelik kaybını görmesi (≤27 sn; `internal/composition/tables.go:53-101`), hesap
    başına 16 abonelik (17.'si en eskiyi atar; `adapter/live/hub.go:124-132`), sunucu kapanışı.
  - **Belirteç yenilemesi oturum kimliğini değiştirir**: gözcü eski belirteci reddeder, akış
    ≤27 sn'de kapanır → yenilemeden sonra akış yeni belirteçle proaktif açılmalı (ADR-0040:111).
- **Presence** (K-25; `adapter/http/presence.go`; `adapter/live/presence.go:12-21`): anahtar
  (tablo, hesap, oturum); TTL 30 sn, istemci ~10 sn'de bir yeniler; 1 sn'den sık → 429
  `presence_throttled`. Tavan tablo 50 (aşımda 503 `stream_unavailable`), hesap 16, toplam
  10000. DELETE idempotent; ekrandan çıkarken çağrılır. Çerçeve tam listedir, alıcının kendi
  oturumu yoktur, `key` opaktır, seçimsizde `row_id`/`column_id` boş metin. Süreç içi bellek:
  restart boşaltır, çok süreçte dağıtık değildir (GAP-224). Yakınsama kaynağı değildir.
- **Yorumlar** (K-26; `adapter/http/comment.go:17-41`): içerik yalnız `GET …/comments`'te;
  yazım `/operations` ile, her biri sıra artırır ve `changes`'te kendi `kind`'ıyla görünür.
  Satır başına 500; silme fizikseldir.

## 7. Sınırlar ve bilinen açıklar

| Sınır | Değer |
|---|---|
| Sütun / satır | 100 / 100000 |
| `set_cells` batch | 1–100 hücre |
| Okuma yanıtı | 8 MiB gerçek JSON |
| Replay / undo ufku | 10000 / 1000 olay |
| Yorum | 1–4000 karakter, satır başına 500, sayfa ≤50 |
| Akış | hesap 16, toplam 10000, ping 25 sn, bütçe 5 dk |

Bilinen açıklar (`docs/known-gaps.md` GAP-224, README §7): tek süreç hub/presence; değer
deltası yok (her yabancı değişiklikte snapshot); harici referans adı/görünürlük ve proje
silme sıra artırmaz (itme yok); tipli sorgu imleci her yazımda bayatlar; `COLLATE "C"`
(Türkçe sıralama yok, contains büyük/küçük harf duyarlı); undo yalnız kendi `set_cells`'i,
redo yok; dışa aktarım yok.

## 8. Mobil tasarımı (katmanlar)

| Katman | Dosya | Sorumluluk |
|---|---|---|
| domain | `lib/features/tables/domain/table_models.dart` | `TableScope` (alan + program + departman), `TableMeta` (şema sürümü, sıra, sahip, ekip rolü), sütun/satır/hücre (`TableCellData.version`, `redacted`), makbuz, changes, akış olayları, yorum |
| domain | `domain/table_operation.dart` | `TableOperation` (sealed) + `signature` (işlem anahtarı defteri için gövde imzası) |
| domain | `domain/tables_repository.dart` | port; her yöntem `TableScope` alır |
| data | `data/table_api_repository.dart` (+ `table_mapping.dart` part) | üretilmiş `TablesClient`; kapsam istek başına `withScope`/`withProgram`; DTO ↔ domain; SSE ham akış (`decodeSse`) |
| application | `tables_list_controller.dart` | iki alanın imleçli listesi; kişisel/paylaşılan ayrımı `owner_id` ile; oluşturma (anahtar defteri) |
| application | `table_controller.dart` (+ `table_cell_writes.dart` part), `table_write_queue.dart`, `table_view.dart` | snapshot sayfaları, olay imleci ve `catchUp`, hücre yazımı, komutlar, yorum komutları |
| application | `table_sync_controller.dart` | akış döngüsü (SSE), ipucu birleştirme, yeniden bağlanma, presence |
| application | `table_comments_controller.dart` | satır yorum listesi; `commentsRevision` artınca yeniden okur |
| application | `tables_providers.dart` | port + ön plan bayrağı, saat, yeniden bağlanma beklemesi, canlı zamanlama |
| core | `lib/core/domain/stream_reconnect.dart` | sohbet ve tablo akışlarının ortak geri çekilme/hata kararı/sağlıklı bağlantı kuralları |
| presentation | `presentation/*` | liste, ızgara, satır/sütun sayfaları; `table_live.dart` (canlı kapsam + durum/katılımcı çubuğu), `table_comments.dart` |
| DI | `tables_module.dart` | get_it kaydı + Riverpod port bağlama |

Üretim notları (`tool/gen/`): `TableCellValue` (skaler `oneOf`) ham JSON (`dynamic`) olarak
üretilir ve zorunlu `value` alanı `includeIfNull` alır (boş hücre `null` gider;
`scalar_unions.dart`). `TableComment.author` satır içi nesnesi `author` enum sorgu
parametresiyle ad çakışmasından `TableCommentAuthor` bileşenine taşınır (`inline_names.dart`).

Ekranda olmayan (gizlenen) backend yüzleri: paylaşım (grant/revoke — üye seçici yok), ekip
rolü, şablon, kopya/taşıma/öneri, projeler, ekler, referans hücre düzenleme (kişi/departman/
görev/dosya/tablo seçicileri), sütun tipi dönüştürme, filter/sort, yorum düzenleme. Mobil
prototipin karşılıksız özellikleri kaldırıldı: birim (koordinatörlük) kutuları ve örnek
birimler, hazır şablonlar, son açılanlar, kopyalama, tablo ilişkileri/geri bağlantılar,
program/birim paylaşımı, sahte kişi/görev/dosya seçicileri, ızgarada yerel sıralama/arama/
"tamamlanan" süzgeci.

## 9. Senkron algoritması

### 9.1 Hücre yazımı

Görünüm iki katmandır: sunucudan türeyen **taban** (snapshot + kendi makbuzlarımız) ve üstüne
uygulanan bekleyen/uçuştaki düzenlemeler. Taban monotondur: uygulanmış snapshot'tan eski
sıradaki snapshot atılır; snapshot ya da makbuz bir hücreyi daha küçük sürüme geri almaz
(geciken kendi makbuzumuz, araya giren yabancı değeri ezmez). Snapshot okumaları tek zincirde
sıraya dizilir.

1. Düzenleme yerelde hemen görünür; `TableWriteQueue`'ya CAS tabanıyla girer: okunan sürüm,
   hücre gönderilen batch'teyse o batch öğesinin tabanı. Aynı hücrenin ardışık düzenlemesi
   tabanı koruyup değeri değiştirir.
2. 1 sn sessizlik (ya da 100 hücre) → tek `set_cells`. Aynı anda tek batch vardır; gövdesi ve
   işlem anahtarı değişmezdir. Yeni düzenlemeler kuyrukta onun arkasında bekler.
3. Başarı: makbuzdaki yeni sürüm görünümdekinden büyükse değer yazılır. Görünüm aynı sürümü
   zaten gösteriyorsa (snapshot kendi yazımımızı makbuzdan önce görmüş) bu da kendi başarımızdır:
   kuyruktaki aynı hücrenin tabanı makbuz sürümüne taşınır ve yanlış çakışma işareti kalkar.
   Görünümdeki sürüm daha yüksekse (yabancı yazım) taban taşınmaz. Taban yalnız KENDİ başarılı
   makbuzumuzla taşınır.
4. Sonucu bilinmeyen hata (zaman aşımı/ağ/5xx): batch AYNI gövde+anahtarla bekletilir, şerit
   çıkar; "Yeniden dene" aynısını yollar (sunucu yazdıysa `replayed` döner, çift yazım olmaz),
   sonra kuyruktakiler ayrı batch'le gider. 429: aynı batch `Retry-After` sonra kendiliğinden.
5. Komutlar (satır/sütun/ad/yorum) önce bekleyen hücreleri gönderir. Her yeni kullanıcı işlemi
   YENİ işlem anahtarı alır (iki ayrı "satır ekle" iki ayrı kayıttır). Sonucu bilinmeyen komut
   işlem nesnesi + anahtarıyla bekletilir ve şeritte "Yeniden dene" sunulur; yeniden deneme
   aynı nesneyi ve anahtarı yollar (sunucu yazdıysa `replayed`, kayıt tek kalır). Belirsiz komut
   beklerken yeni işlem engellenmez, kendi anahtarıyla gider. Makbuz alındıktan sonraki yeniden
   okuma düşerse komut başarılı sayılır; hata raporlanır ve kalıcı "yeniden okuma gerekli"
   bayrağı sonraki yakalamada tabloyu yeniler. Komut makbuzuyla doğrulanan en yüksek sıradan
   eski snapshot tabanı (ad, sütunlar, satırlar) geri almaz; atılır, bayrak kalır. Ters yön de
   korunur: makbuzla gelen yerel metadata güncellemesi (ad, sütun adı/genişliği) yalnız makbuz
   sırası uygulanmış snapshot sırasından yeniyse uygulanır (geciken makbuz daha yeni snapshot'ı
   ezmez). İşlem nesnesi kendi başarı işleyicisini taşır: yeniden deneme de aynı sonucu işler
   (silmede listeden düşme ve ekranın listeye dönmesi).

### 9.2 Çakışma

409 `cell_conflict` → tablo yeniden okunur. Batch'teki her hücre için: sunucu sürümü tabanla
aynıysa (çakışmayı başka hücre doğurdu) yeni anahtarla yeniden gider (istek reddedilmişti);
değiştiyse hücre `conflicts`'e girer, sunucu değeri görünür, şerit çıkar — aynı hücreye
kuyrukta daha yeni düzenleme varsa o da düşer (yabancı sürüme taşınıp sessizce ezmez).
Yeniden okumada tabanı sunucuda değişmiş her kuyruk öğesi de çakışma olarak işaretlenir.
Çözümleme okuması düşerse batch (yeni anahtarla) bekletilir, kuyruk korunur, hata görünür;
gönderim hiçbir zaman yakalanmamış hata fırlatmaz.

### 9.3 Canlı senkron (gerçekleşen)

Referans istemci: backend `internal/modules/tables/integration/yakinsama_istemci_test.go:1-16,
160-400`; protokol APIR:299-325, OA:6130-6140.

1. **Açılış:** `TableController` snapshot'ın ilk sayfasını okur, `cursor` = `table.sequence`.
   Tablo yüklenince `TableSyncController` akışı açar; `ready` her zaman yakalamayı tetikler.
   Referans istemcideki "önce akış, sonra snapshot" sırası yerine "snapshot, sonra akış +
   `ready` ile yakalama" kullanılır: aradaki commit `changes?after=cursor` ile kapanır, sonuç
   aynıdır. Çok sayfalı yeniden okumada sayfalar arasında `table.sequence` değişirse yürüyüş
   baştan alınır (en çok 3 deneme).
2. **İpucu:** `changed(s)` için `s ≤ cursor` ise yok sayılır; değilse 1 sn birleştirilir. Nesil
   başına tek yakalama uçuştadır; uçuşta gelen ipuçları tek bekleyen yakalamada toplanır (okuma
   kotası 600/dk). Uçuş ve bekleyen talep nesle bağlıdır: arka plan/ön plan geçişinden sonra eski
   neslin uçuşu, yeni bağlantının `ready` yakalamasını tüketmez (backend aynı sıra için yeniden
   `changed` üretmez, `stream.go:132,162-170`).
3. **`catchUp()`:** `changes?after=cursor&limit=200` sayfaları `more=false` olana dek okunur;
   imleç ancak gereken yeniden okuma ve yorum güncellemesi BAŞARIYLA bitince ilerler (okuma ya
   da sonraki sayfa düşerse imleç yerinde kalır, aynı olaylar yeniden işlenir); tutarlı
   snapshot uygulanınca da sırasına ilerler ve atlanan aralıkta yorum olayı olabileceği için
   açık yorum listeleri yenilenir. Kendi makbuz sırası imleci ilerletmez. Yeni seq `ownSequences`'te
   değilse ve yorum türü değilse snapshot yeniden okunur; yalnız yorum olayları
   `commentsRevision`'ı artırır (açık yorum listesi yeniden okunur). 409 `replay_expired` →
   tam yeniden yükleme; 403/404 → `accessLost` (salt okunur + şerit).
4. **Kendi yankısı:** makbuz `sequence`'i `ownSequences`'e girer; bu seq'ler snapshot
   okutmaz. Yapı değiştiren kendi komutlarımız zaten komut sonrası yeniden okuma yapar. Bilinen
   sapma: kendi `number` yazımımızın sunucu normalizasyonu (`1e3`→`1000`) sonraki yeniden
   okumaya kadar görünmez. Uçuşta yazım varken makbuzu gelmemiş kendi olayımız yabancı sayılır
   (güvenli taraf: bir fazla yeniden okuma).
5. **Bekleyen yazım ezilmez:** yeniden okuma sonucu üstüne kuyruktaki ve uçuştaki değerler
   uygulanır; kuyruktaki hücrenin tabanı sunucuda değiştiyse hücre `conflicts`'e girer
   (ızgarada işaret + şerit); gönderim 409 alınca §9.2 yakınsaması çalışır. Açık düzenleyici
   (`TextField`) kendi yerel metnini korur.
6. **Kopma:** EOF/ağ hatası/60 sn çerçevesiz (dio `receiveTimeout`) → `retrying`; bekleme
   `reconnectDelay` (0–5 sn jitter + 1,2,4…≤60 sn; 10 sn yaşamış bağlantı sayacı sıfırlar),
   6 ardışık başarısızlıktan sonra `offline`. 401/403/404/422 → `offline` (401'de kimlik
   halkası belirteci zaten bir kez yeniledi); 429 → `Retry-After` bitene kadar açılmaz.
   Belirteç yenilemesinde sunucu gözcüsü akışı ≤27 sn içinde keser; bu normal kopma olarak
   yeniden bağlanır (proaktif yeniden açma kancası yok — açık #9).
7. **Yaşam döngüsü:** tek görünürlük kararı `tableLiveVisible` (`TickerMode`); kapsam ve
   durum çubuğu (`TableLiveBar`) yalnız görünürken dinler, gizli ekran akışı açık tutmaz.
   Durdurma nesli artırır: uçuştaki yakalama bitince bekleyen yakalama kurulmaz.
   `TableLiveScope` ekran görünürken denetleyiciyi dinler;
   uygulama arka plana geçince (`AppLifecycleListener`) akış kapanır ve presence silinir; öne
   dönünce akış açılır, `ready` imleçten yakalar. Oturum/kapsam değişince akış yeniden kurulur.
8. **Presence:** akış canlıyken hemen ve 10 sn'de bir `POST`; satır sayfası açılınca seçim
   (satır + odak/ilk sütun). Bütün gönderimler tek kapıdan geçer: aynı anda tek istek, son
   gönderimden en az 1 sn, 429 `Retry-After` süresince yok; erken istek en erken ana ertelenir
   ve o andaki seçimi taşır, kapanınca seçim temizlenir; akış
   kopunca yenileme durur, ekrandan çıkış/arka planda `DELETE`. `presence` çerçevesi tam
   katılımcı listesidir; başlıkta avatar yığını, ipucunda ad + satır/sütun.
9. **Durum göstergesi:** başlıkta `Canlı` / `Yeniden bağlanıyor` / `Çevrimdışı`.
10. **Sayfa:** aşağı çekerek yenileme (bekleyen hücreler önce gider), silme sonrası liste
    açılır (bölünmüş görünümde sağ bölme kapanır).

**Ortak politika taşıması:** sohbetin genel yeniden bağlanma kuralları (`reconnectDelay`,
`streamErrorAction`, `nextFailures`, eşikler) `lib/core/domain/stream_reconnect.dart`'a
çıkarıldı; `messages/domain/chat_stream_policy.dart` bunları yeniden dışa verir, sohbete özgü
sabitler orada kalır (davranış aynı, sohbet testleri değişmeden geçer). Döngüler ayrıdır:
sohbetinki program genelinde tek akış + sinyal veri yolu, tablonunki tablo başına akış + yakalama
+ presence.

**Yazma kovası hesabı (hesap başına 60/dk, ADR-0028):**

| Kaynak | Normal | Tavan |
|---|---|---|
| Presence yenileme | 6/dk | 6/dk |
| Presence seçim değişimi | satır sayfası açılışı başına 1–2 | 60/dk (1 sn aralık) |
| Akış açılışı | ~0,2/dk (5 dk bütçe) | yeniden bağlanma sıklığı (geri çekilmeyle azalır) |
| Hücre yazımı (`set_cells`) | düzenleme duraklaması başına 1 | ~60/dk (1 sn birleştirme, tek uçuş) |
| Yorum / satır / sütun komutu | kullanıcı eylemi başına 1 | — |

Sürekli düzenleme + presence + açık ikinci tablo kovayı aşabilir: hücre batch'i 429'da
`Retry-After` sonra aynı gövde/anahtarla gider; presence 429'u (ya da `presence_throttled`)
`Retry-After` süresince sonraki gönderimleri bekletir. Presence için ayrı (sinyal) kova yoktur (açık #4).

## 10. Açıklar (kırmızılar)

1. **Pin:** `f64-faz3-onizleme` yerel önizleme etiketi; backend gerçek `v*-api` etiketi
   gelmeden birleşme yok; CI bu etiketi çözemez.
2. Tablo akışı için ayrı istemci rehberi yok; sohbet rehberi (`docs/api/istemci-akislari.md:
   643-708`) kıyasla uygulanır. Kapanış nedeni bildirilmez.
3. Çağıranın tablo rolü (editor/viewer) yanıtta yok; mobil 403'te salt okunura geçer.
4. Yazma kovası 60/dk presence, akış açılışı, hücre ve yorumla paylaşımlı; presence için ayrı
   kova yok.
5. `kind` bazlı daraltma ve yankı ayrımı türetilmiştir; backend sentetik istemcisi her yeni
   olayda snapshot okur.
6. Büyük tabloda her yabancı değişiklikte tam snapshot okuma kovasını (600/dk) ve mobil
   veriyi tüketir; kısmi pencere tazeleme sözleşmesi yok.
7. Presence tavanı aşımı 503 `stream_unavailable` döner (özgün kod değil).
8. Kendi `number` yazımının sunucu normalizasyonu sonraki yeniden okumaya kadar görünmez.
9. Belirteç yenilemesinden sonra akışı proaktif yeniden açan kanca yok; sunucu eski belirteçli
   akışı ≤27 sn içinde kapatır ve döngü yeniden bağlanır (o arada eski oturumun presence kaydı
   ≤30 sn "hayalet" görünebilir).
10. Yorum düzenleme denetleyicide var, ekranda yok; tablo düzeyi yorum sözleşmede yok
    (`add_comment` `row_id` ister).
8. `tables.*` TR hata metinleri web pininde yok (`i18n/server_errors_ek.tr.json` geçici).
