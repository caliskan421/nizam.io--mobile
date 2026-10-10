# MOB-0 r3 — paket seti (tercihler, gömülü yazı tipi, Gap, drift, Firebase, splash/simge): Codex hükmü

Ürün sahibi talebi (2026-10-09/10); kararlar `docs/architecture/adr-0002-paketler-tercih-yerel-veri-firebase.md`.
Denetçi: Codex `gpt-5.6-sol`, salt okunur, 6 koşum. Ürün kararları denetim konusu değildi; uygulama
doğruluğu ve önceki değişmezler denetlendi.

| Koşum | Commit | Hüküm | Bulgular → düzeltme |
|---|---|---|---|
| 1 | `4ec739a` | UYGUN DEĞİL | CX-r3-Ö-01 tercih okuması açılışı sınırsız bekletir; Ö-02 ham port serbest anahtarla her katmana açık; Ö-03 SDK barrel export'u; K-01 U1 `typedef`/`.new`; K-02 `make branding` kirli pbxproj'u ezer → `90ebdd4`, `f607901` (süre aşımı + test, S7, export yasağı, U1, fail-closed branding) |
| 2 | `f607901` | UYGUN DEĞİL | Ö-02 ham port barrel ile; K-01 yapıcı tear-off; K-03 Gradle raporu commit'lenmiş → `c3b1e68` |
| 3 | `c3b1e68` | UYGUN DEĞİL | Ö-04 izinli dizinden getter/fabrika ile ham depo/Firebase nesnesi taşıma → `b6eba59` (A4, tip çözümlemeli) |
| 4 | `b6eba59` | UYGUN DEĞİL | Ö-04 `dynamic`/`Object`/geri çağrı ile tip silme → `f27f96c` (S5/S6/S7 kesin dosya listesi + A5) |
| 5 | `f27f96c` | UYGUN DEĞİL | Ö-04 `AppPreferences` muafiyeti adlandırılmış tiple taşıma → `598899a` (A4 yönsel muafiyet) |
| 6 | `598899a` | **UYGUN** | yok |

Kanıt (yerel): `make verify` 245/245, lint/sınır temiz. Cihaz: iPhone 17, iPad Pro 13 (iOS 26.3.1 sim),
Android 17 AVD — açılış hatasız.

## Son hüküm (6. koşum, aynen)

- Hüküm: **UYGUN**
- Denetlenen: f14-r3-paketler @ `598899adec0bfdbf4d513955854a5b1a3cfb855a` (6. koşum) (diff `origin/main..`)
- Gerekçe: Ö-04 kapanmış; `AppPreferences` artık ham depoyu adlandırılmış tip, tip sınırı veya dolaylı açık API üzerinden dışarı veremiyor ve yalnız yapıcı girdisi yönsel olarak muaf.
  K-05, oturum nesli, kuruluma bağlı Bearer/refresh, CX-Ö-03 açılış sırası, DI yaşam döngüsü, tercih/tema dinleyicileri, paket sınırları, gömülü fontlar, başlatılmamış Firebase ve native marka çıktıları korunmuş.

## Bulgular

yok