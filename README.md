# NIZAM.IO — Mobil İstemci

Bu depo, NIZAM.IO ürününün **mobil istemcisi** için ayrılmıştır. **Bu depoda henüz
uygulama kodu yoktur** — ne framework iskeleti, ne `pubspec.yaml`/`package.json`
benzeri bir bağımlılık dosyası, ne de build yapılandırması. Bu dört yönetişim dosyası
(`README.md`, `CLAUDE.md`, `AGENTS.md`, `.gitignore`) deponun ilk içeriğidir.

Mobil, eski Teknofest ürününde **hiç yoktu**; NIZAM.IO'da tamamen yeni bir yüzeydir
([D-0007](../project-control/decision-register.md#d-0007) — mobil `NEW`;
[capability-inventory.md](../project-control/product/capability-inventory.md) satır 39).

## Mevcut durum

- **Faz 3** backend'de tamamlanmış, **G3 ön-kabul** teknik olarak geçmiştir
  ([REV-0018](../project-control/verification/reviews/REV-0018-g3-on-kabul-ve-kayit-tutarliligi.md)
  §7, 5/5 koşulsuz uygun) — **ürün sahibinin kişisel G3 kabulü henüz verilmemiştir.**
- **Faz 4 (modül dikey dilimleri) başlatılmamıştır.**
- **Mobilin Faz 3 kapsamı istemci kodunu kapsamıyordu.** [D-0057](../project-control/decision-register.md#d-0057)
  gereği Faz 3 Pilot 3'te (`WP-330`) mobil tarafı **yalnız sunucudaki açık sistem bilgi/keşif
  ucu (`GET /.well-known/nizamio-instance`) ve buna karşı yazılan sözleşme testleridir**
  — mobil istemci uygulamasının kendisi ve uçtan uca mobil kabul senaryoları
  (QR/davetle bağlanma, yanlış sertifikalı sunucuya parola göndermeme, şirket
  değişiminde cihaz verisinin doğrulanabilir temizliği) **Faz 4**'e bırakılmıştır.
  Yani bugüne kadar mobil için üretilen tek somut çıktı backend tarafındaki bu uçtur;
  bu depoda değildir.
- Aktif yönetim iş paketi [WP-340](../project-control/work/active/WP-340-faz4-oncesi-toparlama.md)
  kapsamında bu depo **ilk kez açılmıştır**; WP-340 bir Faz 4 paketi değildir ve Faz 4'ü
  başlatmaz ([D-0078](../project-control/decision-register.md#d-0078)).
- **Teknoloji seçimi (native/cross-platform framework) henüz karara bağlanmamıştır.**
  Backend'in Go yığını kararı ([D-0068](../project-control/decision-register.md#d-0068))
  mobili kapsamaz; bu depoda hayalî bir mimari, çalışmayan bir komut veya var olmayan
  bir dizin **tarif edilmez**.

## Uygulanmış / plânlanan ayrımı

**Uygulanmış:** yok. Bu depoda yalnız bu dört yönetişim dosyası vardır.

**Plânlanan (Faz 4 dilimleriyle, henüz uygulanmadı):**

- **Tek şirkete bağlanma modeli** ([ADR-0006](../project-control/architecture/decisions/ADR-0006-tek-mobil-uygulama-ve-tek-sirkete-baglanma.md)
  — yalnız Kapsam notu temel mimari bölümü onaylı): mağazalarda tek ürün olarak
  yayımlanan tek mobil uygulama; bir kurulumun aynı anda **yalnız bir** doğrulanmış
  şirket sunucusuna bağlanması; iş trafiğinin merkezden geçmemesi; şirket değişiminin
  normal menü işlemi olmayıp yeniden bağlama olması ve eski şirkete ait yerel verinin
  (token, DB, cache, dosya, bildirim) güvenli temizliği.
- **Discovery ve instance doğrulaması** ([ADR-0007](../project-control/architecture/decisions/ADR-0007-mobil-discovery-ve-instance-dogrulamasi.md)
  — yalnız Kapsam notu temel mimari bölümü onaylı; sözleşme [C4 — Mobil discovery ve
  bağlanma sözleşmesi](../project-control/contracts/mobile-discovery/discovery-contract.md)):
  QR/davet bağlantısının yalnız **taşıyıcı** olması; merkez imzalı kayıt belgesinin güven
  kökü olması; doğrulanmış HTTPS ve instance kimliği karşılaştırması tamamlanmadan hiçbir
  kimlik bilgisinin gönderilmemesi (fail-closed zincir); açık sistem bilgi ucunun
  (`GET /.well-known/nizamio-instance`, [D-0075](../project-control/decision-register.md#d-0075))
  yalnız doğrulama amaçlı, hassas veri taşımayan alanları döndürmesi.
- **API sürümü/uyumluluk** ([ADR-0008](../project-control/architecture/decisions/ADR-0008-api-surumu-ve-destek-penceresi.md),
  [C6 — Sürüm uyumluluk beyanı](../project-control/contracts/compatibility/README.md)):
  mobilin desteklediği API sürümünü bildirmesi; backend'in minimum mobil sürümünü
  bildirmesi; sürüm uyumsuzluğunda sessiz düşüş yerine açık hata.
- Backend'in `/v1` uçlarının [C1 kimlik/kapsam](../project-control/contracts/api/identity-and-scope.md),
  [C2 API/hata](../project-control/contracts/api/api-and-error-contract.md) ve
  [errors/README.md](../project-control/contracts/errors/README.md) sözleşmeleriyle
  tüketilmesi.

Hiçbiri henüz uygulanmadı; hiçbir dosya, dizin veya komut bu depoda mevcut değildir.

## Temel akış (plânlanan — henüz uygulanmadı)

QR/davet ile discovery girdisi alınır → imza/süre/hedef/tekrar-kullanım doğrulanır →
merkezden instance kaydı ve imzalı kayıt belgesi alınır → yalnız doğrulanmış HTTPS ile
bağlanılır → açık sistem bilgi ucundaki instance kimliği kayıt belgesiyle karşılaştırılır
→ API uyumluluğu kontrol edilir → tüm adımlar geçerse giriş ekranı açılır ve kimlik
bilgisi **doğrudan** şirket backend'ine gönderilir. Zincirin herhangi bir adımı
başarısız olursa bağ kurulmaz ve kimlik bilgisi istenmez (fail-closed). Bu akış
**tasarım niyetidir**; hiçbir adımı bu depoda kodlanmamıştır ve bugüne kadar yalnız
zincirin sunucu ucundaki tek bir parçası (açık sistem bilgi ucu, `nizam.io--backend`
içinde) uygulanmış ve sözleşme testleriyle doğrulanmıştır.

## Depo düzeni

Şu an yalnız:

```text
README.md
CLAUDE.md
AGENTS.md
.gitignore
```

Framework seçimi yapıldığında iskelet ve bağımlılık dosyaları ilgili Faz 4 iş paketinin
yazılabilir alanında eklenir.

## Bağımlılıklar

- **`nizam.io--backend`** — API ve açık sistem bilgi ucu sağlayıcısı; bu depoyla aynı
  üst dizinin kardeşidir (`../nizam.io--backend/README.md`). Backend'de bugün var olan
  tek mobile ilişkili uç: `GET /.well-known/nizamio-instance` (S0, hız sınırlı).
- **Sözleşmeler** — `../project-control/contracts/` (C1 kimlik/kapsam, C2 API/hata, C4
  discovery, C6 uyumluluk; ayrıca [contracts/README.md](../project-control/contracts/README.md)
  tam liste).
- **Framework/teknoloji seçimi** — bekliyor; ilgili Faz 4 iş paketinde kararlaştırılır.

## Çalıştırma ve test komutları

**Henüz yok.** Bu depoda çalıştırılabilir hiçbir kod, script veya bağımlılık dosyası
yoktur; bu nedenle kurulum, çalıştırma, test veya lint komutu **uydurulmamıştır**.

## Yapılandırma

**Henüz yok.** Ortam değişkeni, config dosyası veya build parametresi tanımlanmamıştır.

## CI

**Henüz yok.** İlk kod dilimiyle birlikte eklenir (bkz. backend `nizam.io--backend/.github/workflows/verify.yml`
yalnız CI'nın nasıl anlatıldığına örnektir — bu depoya kopyalanmaz, framework seçimiyle
yeniden yazılır).

## Bilinen sınırlar

- Framework/teknoloji seçimi yok → hiçbir kod yazılamaz.
- Minimum desteklenen mobil platform sürümleri henüz açık bir karar değildir
  (`[Çıkarım — D-0037 T-11 teknik varsayılan]`; `D-0030` açık — ADR-0006 §4/6).
- Discovery kayıt belgesinin ömrü, yenilenmesi ve iptali WP-230 §10.4 sözleşmesine
  bırakılmıştır; bu depoda henüz istemci tarafı karşılığı yoktur.
- Sertifika pinning tamamlayıcı bir kontrol olarak ayrıca değerlendirilecektir
  (ADR-0007 §4/3); bu depoda henüz uygulanmamıştır.
- Ortak web ve mobil deneyim tutarlılığı ([product/scope.md](../project-control/product/scope.md)
  madde 4) henüz doğrulanacak bir uygulama yok.

## Yönetim kayıtlarına erişim

Bu depo kod ve depo-yerel belgeyi taşır; **yönetişim kayıtları** (karar kaydı, durum,
sözleşmeler, ADR'ler) `NIZAM.IO` yönetim deposunda `project-control/` altında yaşar ve
bu ürün deposunun **kardeşi** olarak yerleşir:

```text
NIZAM.IO/
├── project-control/        ← yönetim kayıtları (bu depo değil)
├── nizam.io--backend/
├── nizam.io--frontend/
└── nizam.io--mobile/        ← bu depo
```

Bu README'deki `../project-control/...` bağlantıları bu yerleşime göredir. **Bağımsız
checkout'ta** (yalnız bu depo klonlanırsa) yönetim deposu ayrıca ve aynı üst dizine
kardeş olarak alınmalıdır; aksi halde bağlantılar çözülmez.

**Sürüm ilişkisi** — bu README'nin yazıldığı anda:

| Depo | Commit |
|---|---|
| `NIZAM.IO` yönetim deposu | `433f1f2` |
| `nizam.io--backend` | `08ef2ac` |
| `nizam.io--mobile` (bu depo) | ilk commit: `git log -1` (WP-340, 2026-09-09) |

Güncel değerler `git -C <depo> log -1 --format=%h` ile alınır; bu tablo yalnız yazım
anının anlık görüntüsüdür, kendisi yetkili kayıt değildir.
