# Üye sayfaları — standartlara uyum çalışması

> Kapsam: `arayuz/koordinator-ve-uye-eksikleri` dalında yönetici ve koordinatör sayfaları için
> kurulan arayüz standartlarının **üye görünümüne** nasıl uygulanacağı. Belge bir öneri ve iş
> listesidir; burada önerilen kodun hiçbiri henüz yazılmadı. Tarih: 2026-11-14.
>
> Kaynaklar: bu daldaki commit'ler (`d8470da` … `758bf2e`), mobil `CLAUDE.md` (mimari kabul,
> test kapsamı), `lib/CLAUDE.md`, backend sözleşmesi `v0.20.0-api`.

---

## 1. Özet

Üye görünümü bugün **işlevsel olarak tam** (odak görevi, iade, Görevlerim, Yaklaşanlar,
Dosyalarım, Ekibim). Ancak görsel dili yönetici/koordinatör sayfalarının **eski** hâlinde kaldı:
nokta çipleri, tablo satırlı toplantılar, alt sayfa (bottom sheet) seçiciler, bilgi satırları.
Önerilen değişiklikler üç gruptur:

| Grup | Ne | Etki | Veri gereksinimi |
|---|---|---|---|
| A — Dil birliği | KPI kutuları, genel durum halkası, toplantı kartı, ikon seti, bilgi satırlarının kaldırılması | Yüksek (en çok görülen ekran) | Yok (mevcut veri) |
| B — Üyeye özgü sadeleştirme | Anlamsız sıralama/süzgeçlerin kaldırılması, "Görevlerim" odaklı akış | Orta | Yok |
| C — Sözleşme sınırları | Ekip yükü, yükleme zamanı, ekip listesi | Düşük / bekler | Backend işi gerekir |

---

## 2. Bu dalda kurulan standartlar (üyeye taşınacak olanlar)

Aşağıdakiler yönetici ve koordinatör sayfalarında **uygulanmış** ve kabul edilmiş kalıplardır.
Üye sayfası bunları yeniden yazmadan, aynı bileşenleri çağırarak kullanmalıdır.

| # | Standart | Bileşen / yer | Kural |
|---|---|---|---|
| S1 | Özet kutusu | `NzKpiTile` (`lib/core/ui/widgets/surfaces/nz_kpi_tile.dart`) | Alt açıklama metni yok; ikon `NzGlyph` (tasarım ikon seti); köşede çapraz ok; sayı + oran çubuğu; dokunma ilgili listeyi açar. Telefonda 2 sütun, tablette 4 sütun. |
| S2 | Genel durum | `HomeOverview` (`home_overview.dart`) | Halka + durum yüzdeleri; ana dört durum (onay dahil) sıfır olsa da görünür. `statuses:` ile herhangi bir görev kümesine uygulanır; tablette `legendGrid: true` (2×2). |
| S3 | Tablet çiftleri | `IntrinsicHeight` + `Row(stretch)` | Yan yana iki kart aynı yükseklikte; içerik `LayoutBuilder` kullanmamalı (ölçülemez). |
| S4 | Toplantı kartı | `MeetingCard` (`meetings.dart`'tan dışa açık) | Ana sayfadaki "Yaklaşan toplantılar" toplantılar sayfasındaki kartın aynısı; küme `MeetingsTab.upcoming` (bugünün "bekliyor" toplantıları dahil). |
| S5 | Kısayol menüsü | `NzFlyoutMenu` (`anchor`, `below`, `alignEnd`) | Seçim/ek menüleri alt sayfa yerine cam menü; başlık satırı yok; dokunulan öğenin üstünde/altında açılır. |
| S6 | Basma geri bildirimi | `NzPressable` + `GestureDetector` | Karta basınca küçülme; `InkWell` vurgusu yok. |
| S7 | Bilgi satırları | — | "… görev · n açık · yalnız X görevlerini görüyorsun", liste sonundaki "n görev" gibi açıklama satırları kaldırıldı; bilgi kart başlıklarında. |
| S8 | Başlıklar | `NzKicker` ("Ekip", "Bekleyen işler"), `NzSectionHeader` (listeler) | Küçük başlık büyük harfle başlar; yanında özet sayı yazılmaz. |
| S9 | Görünüm satırı | `HomeViewLine` | Koordinatörde kaldırıldı (rol alt çubukta yazıyor: "Koordinatör"). |
| S10 | Arama | Başlıkta arama simgesi + `NzReveal` içinde `NzSearchField` | Sürekli açık alan yok; simge açar, dışarı dokunma kapatır ve temizler. |
| S11 | Kişi satırı | Ekip yükü kartı (`HomeTeamLoad`) | Ad · sağda "n açık · n geç" · ayrık parçalı şerit; avatar ve satır zemini yok. |
| S12 | Test | Ekran matrisi (`test/support/screen_matrix.dart`) | Yeni düzen 4 boyutta taşmasız çizim testiyle korunur; görsel sabit test edilmez. |

---

## 3. Bugünkü üye sayfaları (envanter)

| Sayfa | Dosya | Bugün | Standarttan sapma |
|---|---|---|---|
| Ana sayfa | `lib/features/scope/presentation/home/home_member.dart`, `home_member_cards.dart` | Karşılama + `HomeViewLine` + odak kartı + iade kartı + Görevlerim (nokta çipleri + 5 satır) + Yaklaşanlar (toplantı satırı + bitişler) | S1, S2, S4, S9 |
| Görevlerim | `lib/features/tasks/presentation/tasks_page.dart`, `tasks/tasks_list_parts.dart` | Görünüm ızgarası (Tümü, Gecikmede, İade, Devam, Onay, Başlamadı, Tamamlandı), sıralama, süzgeç | Sıralamada "Koordinatörlüğe göre" üyede anlamsız; süzgeçte "Kişi" anlamsız (yalnız kendisi) |
| Görev ayrıntısı | `tasks/presentation/detail/detail_member_band.dart` | Üye bandı (Başla / Tamamlandı bildir / Düzeltmeye başla / onay bekliyor) | Uyumlu; yalnız S6 ve ikon seti gözden geçirilmeli |
| Dosyalarım | `lib/features/archive/presentation/archive_page.dart:210`, `archive/archive_role_views.dart` | "Dosyalarım" (kendi yüklediği dosyalar) + "görev klasörleri · n" listesi, ipucu "yalnız sana atananlar" | S7 (ipucu satırı); yönetici depolama kartının üye karşılığı yok |
| Ekibim | `lib/features/administration/presentation/team_roster_view.dart` | Başlık + sayı satırı, arama simgesi (S10 uygulandı), rol sekmeleri, salt okunur liste (sohbet grubundan türetilmiş) | Başlık altındaki "Koordinatörlük · n kişi" satırı (S7) |
| Takvim / Zaman çizelgesi | `calendar`, `timeline` | Ortak sayfalar | Hafta kartları S6'ya geçti; üyeye özel fark yok |
| Toplantılar, Mesajlar | ortak | Ortak sayfalar | S4/S5 uygulandı (mesaj ek menüsü) |
| Menü ve alt çubuk | `module_menu.dart:96`, `shell_tabs.dart` | Üye menüsü: Ana sayfa, Görevlerim, Takvim, Zaman çizelgesi; Toplantılar, Dosyalarım, Mesajlar; Ekibim | Alt çubukta "Üye" yazıyor (uygulandı); kenar çubuğu seçicileri S5'e geçti |

---

## 4. Sayfa sayfa önerilen değişiklikler

### 4.1 Ana sayfa (en yüksek öncelik)

**Hedef düzen — telefon**

```
Merhaba / Ad                       (görünüm satırı YOK — S9)
┌ Sıradaki işin (odak kartı) ┐      (kalır; ikonlar NzGlyph)
┌ İade edildi (varsa) ┐             (kalır)
┌ Gecikmede ┐┌ Onayda    ┐          2×2 NzKpiTile (S1)
┌ İade      ┐┌ Tamamlanma %┐
Görevlerim  ·  Tümü ›               (yalnız satırlar; nokta çipleri kalkar)
Yaklaşanlar ·  Takvim ›             (toplantı = MeetingCard, bitiş = mevcut satır)
```

**Hedef düzen — tablet**

```
[ Genel durum (kendi görevlerim, legendGrid) ][ Sıradaki işin ]   ← çift, aynı yükseklik (S3)
[ Gecikmede ][ Onayda ][ İade ][ Tamamlanma % ]                    ← 4 sütun (S1)
[ İade edildi (varsa) ............................ tam genişlik ]
[ Görevlerim ]                    [ Yaklaşanlar ]                  ← çift (S3)
```

| # | Değişiklik | Gerekçe | Yer | Not |
|---|---|---|---|---|
| U1 | `HomeViewLine` kaldırılır | S9; rol alt çubukta ve kenar çubuğunda zaten görünüyor | `home_page.dart:229` | Koordinatörde aynısı yapıldı |
| U2 | `HomeMemberStats` (nokta çipleri) yerine 4 `NzKpiTile`: Gecikmede, Onayda, İade, Tamamlanma (%) | S1; yönetici/koordinatörle aynı dil | `home_member_cards.dart:225` → yeni `homeMemberKpis()` (koordinatördeki `homeCoordinatorKpis` kalıbı) | Veri hazır: `MemberHome.stats` (`CoordinatorSummary`). "Toplam" kutusu yerine Tamamlanma yüzdesi |
| U3 | Tablette `HomeOverview(statuses: kendi görevlerim, legendGrid: true)` + odak kartı çifti | S2/S3; üyenin "genel durumu" kendi görev dağılımıdır | `home_member.dart` geniş dal | Odak kartı `IntrinsicHeight` içinde ölçülebilir olmalı (LayoutBuilder yok — kontrol edilecek). Telefonda halka **eklenmez** (odak kartı ilk ekranda kalmalı) |
| U4 | Yaklaşanlar'daki toplantı satırı `HomeMeetingRow` → `MeetingCard` | S4; koordinatörle aynı | `home_member.dart:146` | Bitiş satırları (`HomeMemberDueRow`) kalır; karışık liste: kartlar + satırlar. Alternatif: iki alt bölüm ("Toplantılar" kart, "Bitişler" satır) — **karar gerekli (§7-K1)** |
| U5 | Görevlerim bölümünde istatistik şeridi kalkar, yalnız ilk 5 satır | U2 ile tekrar olmasın | `home_member.dart` (`below:`) | Kesik liste uyarısı kalır |
| U6 | Odak / iade kartlarında ikonlar `NzGlyph` setine | Görsel birlik | `home_member_cards.dart:22`, `:145` | Zip'te `onay-tik`, `kanit-yukle`, `devam-eden-simsek` var |
| U7 | Kartlarda basma vurgusu yerine küçülme | S6 | `_Row`, odak kartı düğmeleri hariç | Düğmeler `NzButton` (zaten uyumlu) |

**Bilinçli olarak eklenmeyenler (ana sayfa)**

- *Hızlı işlemler*: üyenin görev açma/toplantı/üye ekleme yetkisi yok; boş bölüm çizilmez (bugünkü davranış doğru).
- *Ekip yükü*: üye yalnız kendine atanan görevleri görür; başkalarının yükü sayılamaz
  (`TeamSourceFacts.countsLoad` üyede `false`). Gösterilirse yanıltır.
- *Bekleyen işler (Onay / Atanmamış / Tarih talebi)*: üye onaylamaz, atanmamış görev göremez,
  tarih talebi açamaz (WORK-K38). Üyenin "bekleyen işi" zaten odak + iade kartıdır.
- *Koordinatörlük kartları*: üye tek koordinatörlükte çalışır; seçici kenar çubuğunda.

### 4.2 Görevlerim

| # | Değişiklik | Gerekçe | Yer |
|---|---|---|---|
| G1 | Üyede "Koordinatörlüğe göre" sıralaması kaldırılır; seçenekler: Bitiş (varsayılan), Başlangıç, Tanımlanma | Üye etkin koordinatörlüğün görevlerini görür; gruplama tek grup üretir | `coordinator_board.dart:230` `taskSortsFor` → `role` parametresi |
| G2 | Süzgeç sayfasında "Kişi" grubu üyede gizlenir | Küme zaten yalnız kendisine atananlar | `tasks_filter_sheet.dart`, `task_filter_groups.dart` |
| G3 | Görünüm ızgarası sırası üyeye göre: Gecikmede, İade, Devam, Onayda, Başlamadı, Tamamlandı, Tümü (önce eyleme dönük) | Ana sayfa KPI sırasıyla tutarlı | `coordinator_board.dart:208` |
| G4 | Kartta kendi adının yazdığı kişi satırı üyede gizli kalır (bugün böyle) | — | `tasks_list_parts.dart:345` (kontrol) |

> Not: Liste altındaki sayı satırı ve "yalnız sana atananlar" ipucu bu dalda kaldırıldı (`758bf2e`).

### 4.3 Görev ayrıntısı

Üye bandı (`detail_member_band.dart`) tasarım §4.2.2 ile uyumlu; değişiklik **önerilmez**.
Yalnız:

- D1 — Bant ikonları `NzGlyph` setine (`kanit-yukle`, `onay-tik`).
- D2 — "Tamamlandı bildir" kaplaması ve kanıt yükleme menüsü, mesajlardaki ek menüsüyle
  aynı kısayol menüsüne (S5) alınabilir: Fotoğraflar / Kamera / Dosyalar. Bugün alt sayfa.

### 4.4 Dosyalarım (arşiv)

**Hedef düzen**

```
Dosyalarım                       [ara] [yükle]
[Etiketler ▾]                                     ← yöneticideki etiket hapı (aynı bileşen)
┌ Dosyalarım: 12 dosya · 4,2 MB  [türe göre şerit] ┐   ← depolama kartının üye karşılığı
Görev klasörleri · 5                               ← ipucu satırı YOK (S7)
[ görev satırları … ]
```

| # | Değişiklik | Gerekçe | Yer | Veri |
|---|---|---|---|---|
| A1 | "yalnız sana atananlar" ipucu kaldırılır | S7 | `archive_page.dart:222` | — |
| A2 | Üstte `ArchiveStorageCard`'ın sade hâli: kendi yüklediği dosya sayısı, toplam boyut, türe göre şerit | Yöneticiyle aynı dil | `archive_storage.dart` (parametre: `stats`, "Klasör/Görev" sütunları gizlenebilir) | `archiveAttachments` + `uploader_id` süzgeci (üyeye açık; RECORDS-K18) |
| A3 | Etiket hapı (`ArchiveTagChip`) üyede de görünür; süzgeç kendi dosyalarına ve görev klasörlerine uygulanır | Yöneticiyle aynı | `archive_page.dart` üye dalı | Mevcut `archiveStatsProvider` üye kapsamında `departments` ile çalışır |
| A4 | "Dosyalarım" listesi (`PersonFiles`) ilk 5 dosya + "Tümü ›" | Ana sayfanın uzun liste kuralı | `archive_role_views.dart` | — |

### 4.5 Ekibim

| # | Değişiklik | Gerekçe | Yer |
|---|---|---|---|
| E1 | Başlığın altındaki "Koordinatörlük · n kişi" satırı kaldırılır | S7 | `team_roster_view.dart` (caption) |
| E2 | Rol sekmeleri (Tümü / Koordinatör / Üye) kalır; kişi satırı S11 dilinde (ad, rol rozeti; yük sayısı **yok**) | Üyede yük sayılamaz | `_TeamRow` |
| E3 | Grup yoksa boş durum metni: "Koordinatörlüğün sohbet grubu kurulunca ekip burada görünür" | Bugün "backend bekliyor" anlamı boş listede kayboluyor | `team_roster_view.dart:219` (`source.derived`) |

### 4.6 Menü, alt çubuk, kenar çubuğu

Bu dalda uygulandı; üyede ek iş yok:

- Alt çubuk Ana sayfa alt yazısı "Üye".
- Kenar çubuğu program / rol / koordinatörlük seçicileri kısayol menüsü (S5); program
  dairesindeki okunmamış sayı kaldırıldı.
- Üye menüsünde "Görevlerim", "Dosyalarım", "Ekibim" adları korunur.

---

## 5. Sözleşme ve veri sınırları (uydurulmayacaklar)

| Konu | Durum (`v0.20.0-api`) | Sonuç |
|---|---|---|
| Ekip yükü (başkalarının görevleri) | Üye yalnız kendine atananları görür; `GET /v1/departments/{id}/members` üyeye kapalı | Üyede ekip yükü yok; Ekibim sohbet grubundan türetilir |
| Dosya yükleme zamanı | `FileListItem`'da `uploaded_at` yok | "Son yükleme", "bu hafta" gösterilmez (yöneticide de yok) |
| Dashboard raporu | `GET /v1/reports/dashboard` yönetici | Üye sayıları katalogdan (`memberHome`) türetilir; zaten öyle |
| Tarih talebi | Yalnız koordinatör açar (WORK-K38) | Üye ana sayfasında tarih talebi kutusu yok |
| Onay | Yalnız koordinatör/yönetici | Üye "Onayda" yalnız sayı ve liste; düğme yok |

---

## 6. Uygulama sırası ve kabul ölçütü

| Sıra | Paket | İçerik | Kabul ölçütü |
|---|---|---|---|
| 1 | Ana sayfa A | U1, U2, U5, U6, U7 | Üye ana sayfası telefon ve tablette 4 boyutta taşmasız (yeni `home_member_test.dart`, `home_coordinator_test.dart` kalıbı); KPI dokunuşları doğru görünümü açar (`RecordingAppNav`) |
| 2 | Ana sayfa B | U3, U4 (§7-K1 kararından sonra) | Tablet çiftleri aynı yükseklik; yaklaşan "bekliyor" toplantı görünür (`memberUpcoming` testi mevcut) |
| 3 | Görevlerim | G1–G3 | `taskSortsFor`/`taskViewsFor` birim testleri üye dalıyla güncel |
| 4 | Dosyalarım | A1–A4 | Arşiv sayfa testi üye dalında depolama kartı ve etiket hapını bulur |
| 5 | Ekibim + ayrıntı | E1–E3, D1–D2 | Yönetim testleri (98) yeşil; boş durum metni görünür |

Her paket kendi commit'i; [skip ci]; push ürün sahibi isteyince. Hot reload/restart kuralları
geçerli (yapı değişikliğinde restart).

---

## 7. Karar gerekenler

- **K1** — Yaklaşanlar'da toplantılar `MeetingCard` olursa bitiş satırlarıyla karışık liste
  mi, yoksa iki alt bölüm mü ("Toplantılar" kart, "Bitişler" satır)? *Öneri: iki alt bölüm,
  her biri en çok 3 öğe.*
- **K2** — Telefonda üye ana sayfasına genel durum halkası eklensin mi? *Öneri: hayır;
  odak kartı ilk ekranda kalmalı. Tablette evet.*
- **K3** — Görevlerim'de "İade" görünümü ızgarada ikinci sırada mı olsun? *Öneri: evet
  (üyenin en acil eylemi).*
- **K4** — Dosyalarım'da depolama kartı yalnız **kendi yüklediği** dosyaları mı, yoksa
  atandığı görevlerin **bütün** dosyalarını mı saysın? *Öneri: atandığı görevlerin bütün
  dosyaları (görev klasörleriyle tutarlı); "Dosyalarım" listesi kendi yükledikleri.*
