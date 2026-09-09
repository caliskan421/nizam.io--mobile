# CLAUDE.md — nizam.io--mobile

Bu dosya, bu depoda çalışan Claude oturumları için geçerlidir. Yetkili süreç protokolü
(`gecis-v2.md`, "V2") burada **kopyalanmaz**; yalnız işaret edilir. V2'nin hiçbir hükmü
bu dosyayla sessizce geçersiz kılınmaz.

## 1. Platform sınırı

Bu depoda **kod yalnız aktif bir Faz 4 iş paketinin (WP-4xx) yazılabilir alanı
belirttiği ölçüde yazılır.** Böyle bir kart yoksa hiçbir kod, iskelet, bağımlılık
dosyası veya build yapılandırması yazılmaz — bu depo bugün itibarıyla dört yönetişim
dosyasından ibarettir (bkz. `README.md`).

Faz 4 henüz başlatılmamıştır ([D-0068](../project-control/decision-register.md#d-0068),
[D-0078](../project-control/decision-register.md#d-0078)). Faz 3'te mobil tarafı yalnız
sunucudaki açık sistem bilgi/keşif ucu ve sözleşme testleriydi
([D-0057](../project-control/decision-register.md#d-0057)) — mobil istemci kodu **hiçbir
zaman** Faz 3 kapsamında değildi; bu depo o kapsamın dışındaydı. WP-340 (bu depoyu açan
paket) bir Faz 4 paketi **değildir** ve Faz 4'ü açmaz.

## 2. Okunacak kayıtlar (sıra)

Kod yazmadan önce, göreli yol + bağımsız checkout notu (`README.md` §"Yönetim
kayıtlarına erişim") ile:

1. [`../project-control/START-HERE.md`](../project-control/START-HERE.md) — oturum giriş noktası, okuma sırası, yetki sınırları, durma koşulları.
2. [`../project-control/STATE.md`](../project-control/STATE.md) — güncel faz, aktif iş paketi.
3. Aktif iş paketi (`../project-control/work/active/`) — yalnız onaylı kart kapsamında çalışılır. Kart yoksa bu depoda kod yazılmaz.
4. Mobile özgü temel mimari kararları: [ADR-0006 tek uygulama/tek şirket](../project-control/architecture/decisions/ADR-0006-tek-mobil-uygulama-ve-tek-sirkete-baglanma.md),
   [ADR-0007 discovery/instance doğrulaması](../project-control/architecture/decisions/ADR-0007-mobil-discovery-ve-instance-dogrulamasi.md),
   [ADR-0008 API sürümü](../project-control/architecture/decisions/ADR-0008-api-surumu-ve-destek-penceresi.md)
   — yalnız Kapsam notu'ndaki temel mimari bölümleri onaylıdır; taslaklar ve teknik
   varsayılanlar onaylı değildir.
5. İlgili sözleşmeler: [C4 discovery](../project-control/contracts/mobile-discovery/discovery-contract.md),
   [C1 kimlik/kapsam](../project-control/contracts/api/identity-and-scope.md),
   [C2 API/hata](../project-control/contracts/api/api-and-error-contract.md),
   [C6 uyumluluk](../project-control/contracts/compatibility/README.md).
6. İlgili karar kaydı: [D-0057](../project-control/decision-register.md#d-0057) (mobilin
   Faz 3 kapsam sınırı), [D-0075](../project-control/decision-register.md#d-0075)
   (discovery ucu adı ve imza algoritması).

Bağımsız checkout'ta yönetim deposu (`NIZAM.IO/project-control`) bu deponun üst
dizinine kardeş olarak ayrıca alınmalıdır; alınmazsa yukarıdaki bağlantılar çözülmez.

## 3. Yazılabilir alan

Aktif iş paketinin kartı **§8 (Değiştirilebilecek dosya veya alanlar)** neyi, hangi
yazarın değiştirebileceğini tanımlar. Kart dışında hiçbir dosya değiştirilmez. Bugün
için yazılabilir alan yalnız bu dört dosyadır ve kart olmadığı sürece **kapalıdır**.

## 4. Doğrulama ve teslim kuralları

Her teslim V2 §15.3 biçimini karşılar (özetle; tam metin `gecis-v2.md`'dedir, burada
kopyalanmaz): iş/gereksinim kimlikleri, incelenen/değiştirilen sürüm, kullanıcı
davranışındaki sonuç, değişen kod/migration/sözleşme, çalıştırılan doğrulamalar ve kanıt
konumu, açık riskler, yeni bulunan davranış, sonraki somut adım. **"Bitti", "çalışıyor"
veya yalnız test sayısı teslim kabul edilmez.**

Discovery/instance doğrulama zinciri **fail-closed** tasarlanmıştır: zincirin herhangi
bir adımı doğrulanamazsa kimlik bilgisi gönderilmez. Bu zincire dokunan her teslimde
kabul senaryosu (SRC-ARCH §17.3 eşdeğeri: değiştirilmiş QR/davet reddi, yanlış sertifikalı
sunucuya parola göndermeme, sürüm uyumsuzluğunda açık hata) test kanıtıyla gösterilir.

Üretici ve bağımsız denetçi aynı ajan/bağlam olamaz (V2 §5, §22). Kanıtsız `PARITY`
sınıfı verilmez; kanıt yoksa `UNRESOLVED` kalır ve ilerlemez.

## 5. Yapılmayacaklar

- Backend'in API/discovery/hata sözleşmesini (C1/C2/C4/C6) **tek taraflı** değiştirmek
  veya bu depoda yerel bir kopyasını tutmak — sözleşme değişikliği `project-control/`'de
  karar gerektirir.
- Eski Teknofest frontend kodunu kopyalamak — mobil `NEW`'dir, eski üründe hiç
  karşılığı yoktur ([D-0007](../project-control/decision-register.md#d-0007)); Teknofest
  web istemcisi mobil için davranış kanıtı bile sayılmaz.
- Discovery girdisine (QR/davet) veya sunucu adresine, imza/instance kimliği doğrulaması
  tamamlanmadan **güvenmek**; "belki doğrudur" davranışı yasaktır (ADR-0007 §4/2).
- Aynı anda birden çok şirkete bağlı bir mobil oturum/hesap durumu tasarlamak
  (ADR-0006 §4/2 — bir kurulum, bir şirket).
- Kart olmadan iskelet, bağımlılık dosyası veya CI yapılandırması eklemek.
- `project-control/` veya `nizam.io--backend` dosyalarına bu depodan yazmak.
- Kaynak depolara (`sources.md`) herhangi bir yazma işlemi (branch, commit, stash,
  checkout, temizlik).
