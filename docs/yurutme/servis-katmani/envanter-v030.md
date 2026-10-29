# Servis envanteri: `v0.3.0-api` ekleri (konferans + asistan)

Pin `v0.3.0-api` (147 işlem). Bu parça yalnız bu etiketle gelen 7 işlemi kapsar: `collaboration_client.dart`
içindeki 3 konferans işlemi ve `assistant_client.dart`'taki 4 işlem. Toplam **7 işlem, 7 karşılık**.
`/v1/me` `full_name` + `company_admin` eki pin commit'inde (`0bccb2b`) `CurrentAccount`'a işlendi; işlem sayısını
değiştirmez.

Kapsam sınıfları ve CSRF `lib/core/api/generated/operations.gen.dart`'tan; başlıklar ara katmandan gelir.
UI, controller, modül ve DI bağlaması değişmedi.

## Konferans → `lib/features/meetings/`

Arayüz `MeetingsRepository`'ye 3 metot eklendi; uygulama `ApiMeetingsRepository`. Testler
`test/features/meetings/data/meetings_api_repository_test.dart` (`konferans` grubu + `getMeeting`).

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| startConference | POST `/v1/meetings/{id}/conference` | S2, CSRF | `MeetingsRepository.startConference(meetingId)` | `MeetingConference` | Gövdesiz gönderilir (`ConferenceEmptyRequest` boş gövde; gövdesiz istek kabul). Yönetici ve bağlı departmanın koordinatörü. Aktif konferans varsa sunucu yenisini açmaz, mevcut döner. Sağlayıcı yoksa `409 collaboration.conference_disabled` → `ApiError`. |
| endConference | DELETE `/v1/meetings/{id}/conference` | S2, CSRF | `MeetingsRepository.endConference(meetingId)` | — | Aktif konferans yoksa ya da sağlayıcı odayı kapatamazsa da 204. |
| joinConference | POST `/v1/meetings/{id}/conference/token` | S2, CSRF | `MeetingsRepository.joinConference(meetingId)` | `ConferenceJoinToken` | Toplantıyı gören her rol; hesap başına dakikada 30 (429 `ApiError`, `retryAfter`). **Token gizli:** `ConferenceJoinToken.toString` token'ı yazmaz (identity `DownloadTicket` emsali); repository log'a yazmaz. `url` wss adresi (dizge). `role` `host`/`speaker`, bilinmeyen → `ConferenceRole.unknown`. |

Domain değişiklikleri (`domain/meeting.dart`):

- Yeni: `ConferenceStatus { starting, live, ending, unknown }`, `ConferenceRole { host, speaker, unknown }`,
  `MeetingConference { id, status, startedAt, startedByAccountId }`, `ConferenceJoinToken`.
- `MeetingDetail`'e `conference` (`MeetingConference?`; aktif ya da kapanmakta olan konferans, yoksa `null`) ve
  `conferenceAvailable` (`bool`, sağlayıcı oda açabiliyor mu; başlat düğmesi buna göre) eklendi. İkisi de isteğe
  bağlı parametre (varsayılan `null`/`false`), mevcut yapıcı çağrıları bozulmaz; `getMeeting` sunucudan doldurur.

Entegrasyonda karar: konferans istemcisi (wss bağlantısı, video SDK'sı) mobilde yok; token yalnız alınır.
Token kısa ömürlüdür, katılmadan hemen önce istenmeli ve saklanmamalı.

## Asistan → `lib/features/assistant/` (yeni; yalnız `domain/` + `data/`)

Arayüz `AssistantRepository` (`domain/assistant_repository.dart`), uygulama `ApiAssistantRepository`
(`data/assistant_api_repository.dart`), varlıklar `domain/assistant.dart`. Testler
`test/features/assistant/data/assistant_api_repository_test.dart`, SSE çekirdeği `test/core/http/sse_test.dart`.

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| assistantChat | POST `/v1/assistant/chat` | S2, CSRF | `AssistantRepository.chat(AssistantQuestion)` | `Stream<AssistantEvent>` | `text/event-stream`. **Ham Dio** (aşağıda). Olaylar `x-nizamio-sse-events`: `metin` → `AssistantTextChunk`, `arac` → `AssistantToolUse`, `gorunum` → `AssistantViewRequest`, `adlar` → `AssistantNames` (`AssistantAlias` listesi), `kaynaklar` → `AssistantSources`, `kullanim` → `AssistantUsage`, `bitti` → `AssistantDone`, `hata` → `AssistantFailure`. Bilinmeyen olay adı yok sayılır; bilinmeyen araç → `AssistantTool.unknown`. |
| assistantConversations | GET `/v1/assistant/conversations` | S2 | `AssistantRepository.listConversations()` | `PageSlice<AssistantConversation>` | Sayfasız, en yeni önce, en çok 200; `X-Result-Truncated` → `truncated`, imleç yok. |
| assistantConversation | GET `/v1/assistant/conversations/{id}` | S2 | `AssistantRepository.getConversation(id)` | `AssistantConversationDetail` | Mesaj rolü `kullanici`/`asistan` → `user`/`assistant`, diğer → `unknown`. Geçmişte takma ad → gerçek ad eşlemesi yok (yalnız canlı akışta). Başkasının sohbeti `404 assistant.not_found`. |
| deleteAssistantConversation | DELETE `/v1/assistant/conversations/{id}` | S2, CSRF | `AssistantRepository.deleteConversation(id)` | — | Kalıcı silme. |

### Neden ham Dio (yalnız `chat`)

Üretilmiş `AssistantClient.assistantChat` imzası `Future<String>`: SSE gövdesini tamamen bekler, olayları
geldikçe veremez ve dinleyici bırakınca isteği iptal edemez. Bu yüzden `chat` aynı `Dio` (aynı kapı, kimlik ve
hata halkaları) üzerinden `ResponseType.stream` ile çağrılır:

- Kapı halkası işlemi gerçek yöntem + yoldan çözer ve taşınan operationId ile karşılaştırır; üretilmiş
  `AssistantClient.assistantChatOpenapiExtras` aynen (kopyalanarak) `extra`'ya konur. S2 program başlığı, CSRF
  başlığı ve Bearer böylece normal yoldan eklenir. Bu, gerçek ara katman zinciriyle test edildi.
- Gövde üretilmiş `AssistantChatRequest.toJson()`'dan gelir (elle JSON yok; `sohbet_id` boşsa gönderilmez).
- `Accept: text/event-stream`; akışa özgü okuma süresi 45 sn (ortak 20 sn model turları arasında erken kesebilir;
  sunucu döngüsü en çok 30 sn).
- Dinleyici aboneliği bırakınca `CancelToken` ile bağlantı kapatılır.

Features katmanında `dart:convert` yasak (D2), bu yüzden UTF-8 çözme, SSE çerçeveleme ve `data:` JSON'ı
`lib/core/http/sse.dart`'tadır (`decodeSse`, `sseJsonObject`, `streamApiError`). Çerçeveleme WHATWG SSE: boş
satır olayı bitirir, `:` yorum, `id`/`retry` yok sayılır, CRLF/LF; parçalar herhangi bir baytta (çok baytlı UTF-8
ortasında da) bölünebilir.

### Hata ve bitiş kuralları

- **Akış başlamadan** doğan hata (kapsam, kota, kapasite, sohbet sahipliği, ilk model çağrısı) normal zarftır.
  Akış isteğinde 2xx dışı gövde okunmamış bir `ResponseBody`'dir; `streamApiError` gövdeyi okuyup zarfı
  `toApiError` kuralıyla (`code`, `status`, `request_id`, `fields[]`, `Retry-After`) çözer → akışın hatası `ApiError`.
- **Akış başladıktan sonra** doğan hata HTTP 200 içinde tek `hata` olayıdır → `AssistantFailure` olayı (istisna
  değil); `bitti` gelmez ve sonrasında okuma durur. Kod sözleşmedeki dördünden biri (`assistant.limit_exceeded`,
  `assistant.refused`, `assistant.provider_unavailable`, `platform.internal`); sözleşmede olmayan yeni kod
  `platform.internal`'a düşer (üretilmiş enum ham değeri korumuyor). Metin koddan ARB ile; `message` sunucunun
  Türkçe metni.
- Akış `bitti`/`hata` olmadan kapanırsa (yarım cevap) ya da bilinen olayın gövdesi şemaya uymazsa →
  `client.invalid_response`. Akış ortasında okuma zaman aşımı → `client.timeout`; diğer G/Ç hatası →
  `client.network_error`.
- **Asistan kapalı:** uç bayrağı (`NIZAMIO_ASSISTANT_ENABLED`) kapalıyken yol tanımsızdır ve sunucu
  `404 platform.route_not_found` döner. Repository yalnız bu durum + kod çiftinde domain istisnası
  `AssistantDisabled` (`requestId` taşır) fırlatır; dört metodun hepsinde. `404 assistant.not_found` ve
  `404 program.not_found` `ApiError` olarak kalır. Uydurma kod yok; eşleştirme `AssistantDisabled.matches`.

### Bilinen sınır (entegrasyondan önce core işi)

**Akış isteğinde 401 yenileme tetiklemez.** `AuthInterceptor` yenilemeye yalnız zarf kodu
`platform.unauthenticated` ise karar verir ve bunu eşzamanlı `toApiError` ile okur; akış isteğinde gövde henüz
okunmamış `ResponseBody` olduğundan kod `client.invalid_response` görünür, yenileme + tekrar yapılmaz. Sonuç:
erişim belirteci süresi dolmuşken soru `ApiError(platform.unauthenticated, 401)` ile düşer (bir sonraki normal
istek yenilemeyi yapar). Test bu davranışı sabitler (`BİLİNEN SINIR` testi). Düzeltme core'da küçük iş: hata
halkalarından önce `ResponseType.stream` isteğinin 2xx dışı gövdesini okuyup `Map`'e çeviren bir ara katman
(ya da `AuthInterceptor.onError`'da eşzamansız okuma). Feature katmanından yapılamaz.

### Entegrasyonda karar

- `gorunum` olayı rotaya çevrilmeli: görünüm adları ve `filtre` şeması backend görünüm kataloğundadır, spec'te
  tipli değil (`filtre` `Object?` olarak taşınır).
- `adlar` eşlemesi yalnız canlı akışta gelir; geçmiş görünümünde `Üye-N` takma adları kalır.
- ARB'de `assistant.*` sunucu kodlarının metni var; "asistan kapalı" için ayrı metin yok
  (`errors.platform.route_not_found` genel metin) — UI girişi gizlemeli.
