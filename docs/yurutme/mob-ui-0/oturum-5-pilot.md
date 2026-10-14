# O5 — A7 Pilot dikey dilim + MOB-UI-0 kapanışı

Sıralı oturum: tek uygulayıcı, ardından bağımsız inceleme ve kapanış.

## Açılış istemi (Opus oturumuna yapıştır)

```
MOB-UI-0 O5 oturumunu koordinatör olarak yürüt.
Oku: nizam.io--mobile/docs/yurutme/mob-ui-0/koordinator.md → oturum-5-pilot.md → ilerleme.md (O1–O4)
→ yol-haritasi-ui-temeli.md (A7, §4, §5) → adr-0003 → docs/architecture/veri-kalibi.md
→ nizam.io--mobile/CLAUDE.md "Kurallar" → backend etiketindeki openapi.yaml (bağ, giriş, parola, kapsam uçları).
W41'i başlat; ardından kapanış adımlarını uygula. Ürün sahibine soru sorma.
```

## Hazırlık (koordinatör)

- A7 zincirinin her halkası için mevcut kodu haritala: hangi servis/controller zaten var
  (`IdentityService`, `SessionController`, `ServerBinding`, kapsam), hangi ekran yeni. W41'e
  **dosya listesi** olarak ver.
- "Son seçili kapsam" tercihi kararı (O2/W14'te ertelendi): kapsam kimliği oturuma bağlı
  olduğu için varsayılan **SecureStore, oturumla silinir**. Kararı ADR-0003'e ek olarak yaz.

## W41 — Pilot dilim

```
Görev: tasarımsız, kit'le kurulmuş işlevsel ekranlar: sunucu bağlama → giriş → zorunlu
parola değişikliği → kapsam seçimi → boş ana kabuk. Zincir: controller → service →
repository → üretilmiş istemci; hata → ARB; faz → router; compact/expanded.
Koordinatörün verdiği dosya haritasını izle.

Sahip olduğun: lib/features/<koordinatörün listesi>/presentation/**, gerekiyorsa
lib/features/<f>/application/** ve data/** (yalnız eksik metotlar), lib/features/<f>/<f>.dart
(rota yüzü), i18n/ui/<f>.tr.json, test/features/**, integration_test/ ya da test_integration/
içinde tek akış testi, lib/app/router/routes.dart (yalnız feature rota birleştirme satırı),
lib/app/di/composition.dart (yalnız modül kaydı).

KESİN:
- Ekran NzPage ile başlar; async veri NzAsyncView; hatalar ref.listenErrors; kullanıcı
  metni ARB; hata metni errorText. Ham renk/TextStyle/sayı boşluk yok.
- Controller (@riverpod AsyncNotifier) domain varlığı taşır, DTO görmez, iş kuralı içermez.
- CLAUDE.md "Kurallar"ın tamamı: sunucu bağı fail-closed (https prod, well-known +
  profile, api_version ve minimum_mobile_version — uyumsuzlukta açık "güncelleme gerekli"
  ekranı), TLS hatası yutulmaz, belirteç yalnız SecureStore ve log'da yok, yeni belirteç
  kaydedilmeden eski silinmez, belirsiz yenileme tekrar denenmez, kapsam başlıkları açık
  taşınır.
- Mevcut güvenlik akışını (bağ/oturum/kapsam controller'ları, startup sırası) yeniden
  yazmazsın; ekranlar onları kullanır. Değişiklik gerekiyorsa SAHİPLİK-DIŞI İHTİYAÇ.
- Parola alanları NzPasswordField; parola hiçbir duruma/log'a/analitiğe yazılmaz.
- Test: her controller birim testi, her ekran widget testi (compact + expanded),
  uçtan uca tek akış testi (mevcut entegrasyon hattında; koşumunu koordinatör yapar).
- Q1 presentation ≥ %60.

SERBEST: ekran içi düzen, alt widget bölümü, QR ile bağlama ekranda yer tutucu mu
(QR kütüphanesi YOK — yeni paket yasak; yalnız URL alanı yeterli), kabuk sekmelerinin yer
tutucu içeriği.
```

Denetimde özellikle bak (koordinatör satır satır): bağ ekranında TLS/uyumsuzluk yolları;
parola değişikliğinde belirteç değişimi sırası; kapsam seçiminde başlıkların sonraki
isteğe gerçekten girdiği (test); hata ekranlarında sunucu `message` gövdesinin gösterilmediği
(yalnız `errorText(code)`).

## Kapanış adımları (koordinatör, sıralı)

1. W41 birleşti, `main` CI yeşil.
2. Entegrasyon: `../program/araclar/verify-sirasi.sh "$PWD" integration` (kilitle); çıktı
   PR'a / ilerleme.md'ye.
3. **Codex tek koşum, salt okunur**: kapsam O1–O5 bütün MOB-UI-0 diff'i
   (`git diff <O1 öncesi main hash>..main`). İstemde: yol haritası §5 kontrol listesi,
   CLAUDE.md "Kurallar", ADR-0001/0002/0003, A0 kurallarının atlatılabilirliği. İsteme sayı
   yazacaksan önce koş (koordinator.md KESİN 6). Hüküm `docs/reviews/MOB-UI-0-codex.md`.
   Önemli/Kritik bulgu → düzeltme uygulayıcısı (Sonnet) → yeniden denetim; Codex ikinci
   kez koşulmaz, düzeltme kanıtı hükme ek olarak yazılır.
4. Yol haritası durum satırı "Uygulandı (<tarih>, main <hash>)"; ADR-0003 son hâli.
5. `../program/DURUM.md` oturum günlüğüne tek satır (program dışı çalışma, D-0174) —
   `program/araclar/kilit.sh al kayit MOB-UI-0` → yaz → yol yoluna commit → `birak`.
6. Worktree/dal temizliği; `ilerleme.md` O5 + "MOB-UI-0 KAPANDI".

## Oturum çıkış ölçütü

Pilot zincir uçtan uca çalışır (entegrasyon kanıtı); Codex hükmü UYGUN ya da bulguları
kapatılmış; bütün kapılar yeşil; yol haritası A8 ("tasarım gelince") için açık kalanlar
`ilerleme.md`'de listeli (`TOKEN-BEKLİYOR` sayısı dahil — `grep -rc` ile ölçülmüş).
