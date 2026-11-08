# CLAUDE.md — nizam.io--mobile/lib (harita)

Kural burada tekrar edilmez; yetkili belge `../README.md` (dizin düzeni, sınır kuralı, üretim, core katmanı).

**Giriş noktaları:** `main_dev.dart`, `main_prod.dart` (flavor derleme anında seçilir).

**Katmanlar:**
- `app/` — bootstrap, router, kabuk, yön politikası; `app/di/` tek bileşim kökü (get_it nesne grafiği + Riverpod portlarının bağlanması).
- `core/` — ekransız altyapı: `api/` (üretilmiş istemci, bkz. `core/api/CLAUDE.md`), `http/`, `server/`, `session/`, `scope/`, `errors/`, `storage/`, `i18n/`, `theme/`, `ui/`, `logging/`, `security/`; `features`/`app` içe aktarmaz.
- `features/<f>/` — özellik dilimi: `presentation/` → `application/` → `domain/` ← `data/`; açık yüz `<f>.dart`, DI kaydı `<f>_module.dart`. Başka feature yalnız `<f>.dart`'ı görür.

**Veri kalıbı:** üretilmiş DTO yalnız `data/`'da kalır ve domain varlığına eşlenir — [`../docs/architecture/veri-kalibi.md`](../docs/architecture/veri-kalibi.md). Kararlar: [ADR-0001 DI](../docs/architecture/adr-0001-di-get-it.md), [ADR-0002 paketler/yerel veri](../docs/architecture/adr-0002-paketler-tercih-yerel-veri-firebase.md), [ADR-0003 UI ve durum](../docs/architecture/adr-0003-ui-temeli.md).

**get_it / Riverpod sınırı:** ADR-0001 ve sınır kuralı G1/G2 (`../tool/boundaries.dart`); burada tekrar edilmez.

**Üretim:** `make gen` (`../tool/gen.dart`; API, hata kataloğu, ARB, token, sürüm, build_runner). Kapı `make gen-check`: yeniden üretim sonrası `git diff` ve porcelain boş. Üretilmiş dosya (`*.g.dart`, `*.freezed.dart`, `generated/`) elle düzenlenmez.

**Test:**
- `make test` (birim, golden hariç) · `make coverage` (Q1 eşikleri) · `make test-presence` (Q2) · `make golden` (yalnız Linux/CI) · `make verify` (hepsi + lint).
- Ekran matrisi: `../test/support/screen_matrix.dart` (telefon küçük/büyük, tablet küçük, tablet).
- Gerçek backend: `make integration`, yerelde YALNIZ depo kökünden `../program/araclar/verify-sirasi.sh "$PWD" integration`; cihaz üstü görsel: `../integration_test/`.

**Yetkili belge:** `../README.md`; depo kuralları `../CLAUDE.md`.
