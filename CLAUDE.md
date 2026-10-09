# CLAUDE.md — nizam.io--mobile (mobil istemci)

Bu depo NIZAM.IO'nun Flutter mobil istemcisidir. Süreç kaydı **bu depodadır** (PR + CI);
yönetim deposundaki eski kayıt sistemine (`project-control`) bağlı değildir.

**Yığın:** Flutter 3.47.2 · get_it (bileşim kökü, `lib/app/di/`) · Riverpod 3 (reaktif durum;
altyapı sağlayıcıları port) · go_router · dio · freezed/json_serializable (OpenAPI'den) ·
flutter_secure_storage · intl/ARB · shared_preferences · google_fonts (gömülü) · gap · drift ·
Firebase (başlatılmamış) · splash/simge (ADR-0002). DI ayrımı: `docs/architecture/adr-0001-di-get-it.md`
(D-0182); get_it yalnız `lib/app/**` ve `features/<f>/<f>_module.dart` (sınır kuralı G1/G2).
Üretilmiş API DTO'ları features içinde yalnız `data` katmanında; dışarıya domain varlığı döner (A1).
Boşluk standardı `Gap` (U1); tercih yalnız `AppPreferences` üzerinden (S5); firebase yalnız app/core/telemetry (S6).

## Okuma sırası (oturum başı)

1. `../program/DURUM.md` — aktif faz ve sıradaki tek iş (yönetim deposu `NIZAM.IO/program/`).
2. `../program/fazlar/FNN-*.md` — aktif mobil fazının amacı, kapsamı, kabul ölçütü.
3. Backend API sözleşmesi (tek kaynak): `../nizam.io--backend/docs/api/`
   - `openapi.yaml` — uçlar, şemalar, kapsam başlıkları, hata yanıtları
   - `error-codes.json` — hata kodu → HTTP durumu → `fields[]` → mesaj anahtarı
   - `README.md` — sürüm ve etiket ilkesi
4. Bu depodaki `README.md` (komutlar, flavor'lar, dizin düzeni) ve açık PR'lar.

Spec her zaman bir **backend etiketinden** okunur (ilk pin: `v0.1.0-api`). Etiketsiz
`main` spec'inden kod üretilmez.

## Kurallar

- **Sözleşme tek taraflıdır:** backend `docs/api/` yetkilidir; yerel kopya düzenlenmez,
  uyuşmazlıkta backend'de iş açılır.
- **Sunucu bağı:** tek sunucu adresi (elle URL ya da yalnız URL taşıyan QR). Doğrulama:
  https (prod flavor) + `GET /.well-known/nizamio-instance` + `GET /v1/instance/profile`
  (`api_version` uyumu, `minimum_mobile_version` ≤ uygulama sürümü). Uyumsuzluk açık
  "güncelleme gerekli" ekranıdır; TLS hatası yutulmaz. Fail-closed.
- **Belirteçler:** erişim + yenileme gövdede, yalnız `flutter_secure_storage`'da; yeni
  belirteç kaydedilmeden eski silinmez; log'a belirteç yazılmaz. Yenileme belirsiz
  düşerse (zaman aşımı/ağ) aynı belirteçle tekrar denenmez → yeniden giriş.
- **Kapsam açık taşınır:** S2'de `X-Nizamio-Program`, S3'te ek `X-Nizamio-Department`.
- **Hata zarfı:** `{code, message, request_id, fields[]}`; metin `code`'dan ARB anahtarıyla.
- v1'de push yok (uygulama içi çan + ön planda yoklama); pinning ve biyometrik yok.
- Eski mobil kod veya sahte kontrol düzlemi geri getirilmez.
- Backend veya yönetim deposuna bu depodan yazılmaz.

## Teslim

Her değişiklik PR ile gelir; şablon `.github/pull_request_template.md`. "Bitti" yalnız
CI yeşil + kabul ölçütü kanıtıyla söylenir. Faz sonunda Codex tek koşum (salt okunur)
hükmü `docs/reviews/` altına yazılır; faz kapanışı `../program/DURUM.md`'ye işlenir.
Ürün sahibine oturum içinde soru sorulmaz; kırmızı karar (ör. mobil yenileme ömrü,
uygulama kimliği/imzalama) faz dosyasındaki varsayılanla ilerler ve DURUM.md'ye yazılır.
