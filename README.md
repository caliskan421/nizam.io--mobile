# NIZAM.IO — Mobil istemci

NIZAM.IO'nun iOS/Android istemcisi. Durum: **iskelet henüz yok** — ilk kod MOB-0 mobil altyapı
fazında (`../program/fazlar/F14-mob-1-kimlik-kabuk-can.md`; ekransız) gelir. Ekran tasarımı ve UI
geliştirmesi program sonrası ayrı çalışmadadır (`../program/` D-0174).

## Yığın

Flutter (stable pin) · Riverpod 3 · go_router · dio · freezed + json_serializable
(OpenAPI'den üretim) · flutter_secure_storage · intl/ARB. Asgari platform: iOS 16+,
Android 8.0 (API 26)+.

## Flavor'lar

- `dev` — `http://localhost` serbest, yerel backend.
- `prod` — yalnız `https://`; OS güven zinciri.

## Backend ile ilişki

- Sözleşme: `../nizam.io--backend/docs/api/openapi.yaml` + `error-codes.json`, backend
  etiketinden. Üretilen Dart kodu commit'lenir; CI "yeniden üret, diff = 0".
- Bağlanma durum makinesi: bağ yok → sunucu doğrulandı → oturum → kapsam.
- Yenileme belirteci ömrü sunucu yapılandırmasındadır
  (`NIZAMIO_SESSION_MOBILE_REFRESH_TTL`, varsayılan 24 saat).

## Dizin düzeni (plan — MOB-0)

```text
lib/core/                 http, güvenli depo, sunucu bağı, tema, i18n
lib/features/<modul>/     presentation, application, domain, data
integration_test/         gerçek backend'e karşı akışlar
```

## Süreç

Faz sırası ve durum: `../program/DURUM.md`. Her değişiklik PR + CI; faz sonunda
Codex tek koşum. Bu depoda `project-control` kaydı tutulmaz. Mağaza yayını ve imzalama program
dışıdır (D-0174).
