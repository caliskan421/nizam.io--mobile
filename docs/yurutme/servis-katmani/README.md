# Servis katmanı — backend işlemleri ↔ Flutter karşılığı

Durum: 2026-10-29 · dal `servis/katman` · pin `v0.2.0-api` (140 işlem). Ekran entegrasyonu **başlamadı**:
`Api*Repository` sınıfları yazıldı ve testli, ama `<f>_module.dart` bağlamaları hâlâ örnek (`Sample*`) repository'lerde.
Entegrasyon ürün sahibi onayıyla ekran ekran yapılır.

## Kapsam

| Parça (envanter) | Backend istemcisi | İşlem | Karşılık | Mobil yeri |
|---|---|---|---|---|
| [org](envanter-org.md) | identity, program, organization, platform | 50 | 48 | `identity`, `scope`, `coordinatorships`, yeni `administration` |
| [work](envanter-work.md) | work | 33 | 33 | `tasks`, `timeline` |
| [records-meetings](envanter-records-meetings.md) | records + collaboration (toplantı) | 12 + 20 | 32 | `archive`, yeni `meetings` |
| [messaging-notifications](envanter-messaging-notifications.md) | collaboration (mesaj) + notifications | 6 + 7 | 13 | `messages`, yeni `notifications` |
| [reporting](envanter-reporting.md) | reporting | 12 | 12 | `scope` (ana sayfa), `coordinatorships`, yeni `reports` |
| **Toplam** | | **140** | **138** | |

Karşılıksız 2 işlem: `healthLive`, `healthReady` (core'da sağlık denetimi yok; istemci için gerekli değil).
Core'da zaten olanlar: `refresh` → `SessionController`; `systemInfo`, `instanceProfile` → `ServerBindingController`.

`v0.3.0-api` ile gelecekler (pin yükselince eklenir, yalnız ekleme): `/v1/me` `full_name` + `company_admin`,
3 konferans ucu, `/v1/assistant/*`.

## Ortak kurallar (uygulanan)

- Repository yalnız `Dio` alır, üretilmiş istemciyi içeride kurar, her çağrı `apiCall`; DTO yalnız `data/` (A1/A2).
- Mevcut UI domain varlıkları spec ile **örtüştüğü kadar birleştirildi**; UI'ın kullandığı ama sunucuda olmayan alanlar
  silinmedi, isteğe bağlı yapıldı ve "sunucuda yok — entegrasyonda karar" yorumu taşıyor. Ayrıntı her envanterin
  "Domain değişiklikleri" bölümünde.
- Bütün domain enum'larında `unknown` var (sunucunun yeni değeri istemciyi düşürmez).
- Üretici düzeltmeleri (`tool/gen/wire_types.dart`): ikili yanıtlar (8 işlem: dosya/ZIP/PDF) bayt olarak okunur;
  `format: date` alanları (13 model) `YYYY-MM-DD` yazılır. Belgeli CSRF istisnası `attachFile`; web'de TR metni
  olmayan 4 sunucu kodu `i18n/server_errors_ek.tr.json`'da (web eklenince gen bayat satırı düşürür).

## Entegrasyonda karar gerektirenler (özet; ayrıntı envanterlerde)

1. **Rol/kapsam:** rapor ve pano uçları yalnız şirket yöneticisine açık; koordinatör/üye ana sayfası sunucu panosu
   olmadan kurulacak. Görev ve arşiv uçları departman kapsamlı (S3); çok departmanlı ekran departman başına istek ister.
2. **Mesajlar:** sunucu konulu, birebir gelen/giden kutusu; sohbet görünümü istemcide karşı tarafa göre birleştirilir.
   Gönderim konu ister. Grup/tepki/anket/sabitleme sunucuda yok.
3. **Görevler:** liste ucu tarih taşımaz (`TaskSummary`), tek görev okuma ucu yok; görev kodu (`ALT-7`) sunucuda yok;
   kanıt etiketleri sunucuda `ister/plan/girdi/analiz/cikti/sonuc`; `urgent` (`acil`) önceliği eklendi, ARB metni yok.
4. **İndirme:** bilet akışı (`IdentityRepository.issueDownloadTicket` → `downloadUri`) hazır; uygulama içi indirme
   gerekirse `redeemDownloadTicket`'ın üretilmiş imzası `Future<void>` (gövde okunamaz) — core'da bayt yolu gerekir.
   Doğrudan uçlar (`ApiRecordsRepository.download*`) bayt döner.
5. **activity:** sunucu karşılığı yok (audit okuma ucu yok).
6. **Takvim:** toplantılar `meetings`'ten; sezon, satın alma ve tablo kayıtlarının karşılığı yok.

## Ortaklaştırma adayları (entegrasyondan önce küçük core işi)

- `X-Result-Truncated` başlık okuyucusu (3 repository'de kopya) → `core/domain`.
- Boş `next_cursor` → `null` dönüşümü (birkaç repository'de) → `PageSlice` yardımcısı.
- Görev durumu/öncelik tel eşlemesi (tasks, timeline, reports, meetings'te kopya) ve `DepartmentRole`/`DepartmentKind`.
- Sayfasız liste + sunucu `total`'i (`CountedList`), testlerdeki sahte HTTP bağdaştırıcısı → `test/support/`.

## Kapılar (`servis/katman` @ birleşme sonrası)

`flutter analyze` temiz · `check_boundaries` ihlalsiz (969 dosya) · `test-presence` eksiksiz · `format-check` temiz ·
`flutter test -j 2`: 1905 geçti, 14 kırmızı — hepsi önceden var olan örnek veri testleri (coordinatorships 12, tasks 2;
örnek katalogdaki fazladan koordinatör "Kadir Özbek"), `f6e7185`'te de kırmızı; servis işinden yeni kırmızı yok.
