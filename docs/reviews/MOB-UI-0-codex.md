# MOB-UI-0 — Codex nihai denetimi (tek koşum, salt okunur)

- Tarih: 2026-10-15 · Araç: `codex exec --sandbox read-only` (codex-cli 0.153.0)
- Kapsam: `git diff 2524a14..3e39551` (MOB-UI-0 öncesi main → O5/W41 sonrası main)
- İstem ölçütleri: yol haritası §5 + A0–A7, CLAUDE.md "Kurallar", ADR-0001/0002/0003, `ui-api-a3.md`,
  `veri-kalibi.md`, A0 sınır kurallarının atlatılabilirliği, Q1/Q2/Q3, CI.
- Codex ikinci kez koşulmaz (oturum-5-pilot.md): bulgular düzeltme uygulayıcılarına (Sonnet) verildi,
  koordinatör (Opus) yeniden denetledi; kanıt aşağıdaki "Düzeltme kanıtları" ekindedir.

---

## Hüküm

**UYGUN DEĞİL** — Yenileme koşulu, eşzamanlı sayfalama ve sınır/kalite kapılarının atlatılabilirliğinde kabul ölçütlerini karşılamayan açıklar var.

Denetlenen aralık: `2524a14..3e39551148f699bac016453e0927150c0111454e`. HEAD yerel `origin/main` ile aynı; worktree dalı `mob-ui/o5-codex`. İzlenen dosyalarda fark bulunmadı. Dosya değiştirilmedi; ağ, Docker, test veya süreç yönetimi komutu çalıştırılmadı.

## Bulgular

1. **Önemli — Belirsiz 401, yenileme ve isteğin tekrarını tetikliyor.**  
   **Yer:** `lib/core/http/interceptors.dart:185`, `:217`, `:225`.  
   `_expiresAccess`, `platform.unauthenticated` yanında `client.invalid_response` için de `true` döndürüyor. Gövdesiz/bozuk 401 dolayısıyla belirteç rotasyonu ve parola değiştirme dahil ilk isteğin tekrarı mümkün. Kullanıcının belirttiği O5 koşulu “yalnız `platform.unauthenticated`” sağlanmıyor.  
   **Düzeltme:** `invalidResponse` istisnasını kaldırın; gövdesiz, bozuk ve farklı kodlu 401’lerde yenileme/tekrar sayısının sıfır olduğunu sınayın.

2. **Önemli — Parola bayrağı değişimi, sürmekte olan yenilemeyi geçersizleştirip oturumu tutarsız bırakabiliyor.**  
   **Yer:** `lib/core/session/session_controller.dart:127`, `:169`, `:215`; yeni çağrı: `lib/features/identity/application/identity_service.dart:118`.  
   Yenileme eski `TokenPair p` ile beklerken `markForcePasswordChange(false)` yeni bir çift nesnesini etkinleştirirse, yenileme yanıtı `identical(_pair, p)` kontrolünden geçmez. Sunucunun döndürdüğü yeni belirteçler atılır, eski yenileme belirteci “yanmış” sayılır; fakat bu kol oturumu `SessionReauthRequired` durumuna geçirmez. Depo yazımlarını kapsayan ortak bir koordinasyon da yoktur.  
   **Düzeltme:** Bayrak güncellemesini rotasyonla aynı koordinasyon altında yürütün; bayrağı en güncel çift üzerinde birleştirin. Geciktirilmiş yenileme ve parola değişikliği yanıtlarını iki tamamlanma sırasıyla sınayın.

3. **Önemli — `NzPagedList` yenileme sırasında tek istek garantisini korumuyor.**  
   **Yer:** `lib/core/ui/widgets/lists/nz_paged_list.dart:69`, `:98`, `:134`, `:146`.  
   `_loadFirst(showLoader: false)` `_loadingFirst` değerini etkinleştirmiyor, `_loadingMore` değerini sıfırlıyor ve eski imleci bırakıyor. Liste sonunun yeniden çizilmesi, ilk sayfa beklenirken eski imleçle `_loadMore` başlatabilir. İki yeni istek aynı nesil numarasını taşıdığı için nesil kontrolü de bunları ayıramaz; sonuç sırasına göre satırlar kaybolabilir veya karışabilir.  
   **Düzeltme:** Görsel yükleme durumundan bağımsız ortak istek kilidi kullanın; yenileme boyunca ek sayfa yüklemeyi durdurun. Bekleyen ek sayfa + aşağı çek yenile + ters yanıt sırası testi ekleyin.

4. **Önemli — Pilotun kullandığı istek DTO’ları parolaları `toString()` içinde açığa çıkarıyor.**  
   **Yer:** `lib/core/api/generated/models/change_password_request.freezed.dart:249`, `lib/core/api/generated/models/login_request.freezed.dart:251`; kullanım: `lib/features/identity/data/identity_repository.dart:46`.  
   Form controller’ları maskeli ve Riverpod durumu parola taşımıyor; ancak `ChangePasswordRequest.toString()` mevcut/yeni parolayı, `LoginRequest.toString()` giriş parolasını içeriyor. Bu üretilmiş davranış tabanda da mevcut; A7 tarafından kullanılan yol açısından “toString’e düşmez” şartı sağlanmıyor. Mevcut log zincirinin bu DTO’ları yazdığını saptamadım.  
   **Düzeltme:** Üretici yapılandırmasında hassas modellerin `toString` üretimini kapatın veya maskeli üretin; üretilmiş dosyaları elle değiştirmeyin. Gerçek DTO örneklerinin dize çıktısını sınayın.

5. **Önemli — API sürümü uyumsuzluğu “güncelleme gerekli” ekranına gitmiyor.**  
   **Yer:** `lib/core/server/server_binding.dart:159`, `:164`; `lib/app/router/router.dart:15`.  
   API sürümü uyumsuzluğu `BindingFailed` üretip `/server` ekranında kalıyor. Yalnız `minimum_mobile_version` koşulu `BindingUpdateRequired` oluşturuyor. Bağlantı güvenli biçimde kapanıyor, ancak `CLAUDE.md` ve `docs/yurutme/mob-ui-0/oturum-5-pilot.md:41` tarafından istenen açık güncelleme ekranı iki uyumsuzluk türünü kapsamıyor.  
   **Düzeltme:** API uyumsuzluğunu da gerekçesiyle güncelleme durumuna taşıyın; keşif ve profil sürüm uyuşmazlıkları için ekran testleri ekleyin.

6. **Önemli — UI ve DI sınırları birkaç somut yolla aşılabiliyor.**  
   **Yer:** `tool/boundaries.dart:279`, `:573`, `:756`, `:823`; `tool/api_surface.dart:333`, `:462`.  
   Statik atlatma örnekleri:
   - **U1:** Dosyada yerel `class SizedBox {}` tanımlamak, aynı dosyadaki `m.SizedBox(height: …)` denetimini de tamamen kapatıyor.
   - **U2/U3/U6:** İzinli tema/core dosyasında tanımlanan `typedef C = Color`, `typedef T = TextStyle`, `typedef S = Scaffold` dışarı aktarılıp sunumda `C(...)`, `T(...)`, `S(...)` olarak çağrılabilir. Çağrı yerinde yalnız yazılan ad karşılaştırılıyor.
   - **U5:** `extension E on ThemeData { … get x => extensions[…]; }` içindeki örtük `this` erişimi ve `final f = extension<T>;` biçimindeki örtük tear-off yakalanmıyor.
   - **G3:** Sunumda `class Local extends SomeService` ve `Local(...) : super(...)` yolu yakalanmıyor; ziyaretçi yalnız instance creation ve constructor reference denetliyor.
   - **N1:** Dizeyle gezinmeyi `core` içindeki bir extension/helper’a taşımak ve feature’dan bu yardımcıyı çağırmak denetimi geçiyor; `core` N1 kapsamı dışında.
   
   **Düzeltme:** Çözümlenmiş element/köken bilgisiyle takma adları ve kalıtımı denetleyin; örtük üye erişimlerini kapsayın. N1’in dolaylı çağrı yüzeyini sınırlandırın. Her örneği ayrı negatif teste ekleyin.

7. **Önemli — URI ve yeniden dışa aktarma yollarında sınır denetimi eksik.**  
   **Yer:** `tool/boundaries.dart:315`, `:326`, `:349`, `:356`, `:391`, `:421`.  
   `_canonical`, `file:///…` URI’lerini reddetmiyor; `_resolve` bunlar için `null` döndürüp yerel katman denetimlerini atlıyor. Böylece B1–B4, G2, A1 ve S7’nin yol tabanlı kontrolleri aşılabilir. Ayrıca `core/storage` üzerinden `flutter_secure_storage` yeniden dışa aktarımı S1’i, core üzerinden Flutter/dio yeniden dışa aktarımı S4’ü aşar. S5/S6 için bulunan export yasağı S1/S4’e uygulanmamış.  
   **Düzeltme:** İzinli URI şemalarını açıkça sınırlandırın; yerel hedefleri kanonik kaynak yolundan çözün. Hassas paketlerin transitif export ve açık yüzeylerini de denetleyin.

8. **Önemli — D2, S2 ve A5’in alternatif sözdizimi/tip yolları eksik.**  
   **Yer:** `tool/boundaries.dart:553`, `:680`; `tool/api_surface.dart:505`.  
   - **D2:** `final body = {'password': password};` veya `<String, Object?>{…}` literalinde `Map` adlı `NamedType` bulunmadığından elle gövde kurulması yakalanmıyor.
   - **S2:** Denetim yalnız `SimpleIdentifier` adlarına bakıyor; `typedef O = HttpOverrides` gibi `NamedType` üzerinden takma ad oluşturma kapsanmıyor.
   - **A5:** `_erased`, `TypeParameterType` incelemiyor. Bağdaştırıcıdaki `T expose<T>() => _store.setString as T;` gibi genel metotla ham yazma geri çağrısı taşınabilir.
   
   **Düzeltme:** Map literal/çıkarımlı tipleri, çözümlenmiş yasak sınıf referanslarını ve tip parametrelerini denetleyin; bağdaştırıcıların genel tip üzerinden değer çıkarmasını kapatın.

9. **Önemli — Q2 ve Q3 vaat ettikleri zorunluluğu tam sağlamıyor.**  
   **Yer:** `tool/check_test_presence.dart:6`; `test/app/composition_test.dart:95`, `:154`.  
   Q2 yalnız `presentation/controllers` dizinini kapsıyor; pilot controller’ları ise `application` altında. Mevcut testleri var, fakat bu testler kaldırıldığında Q2 onları zorunlu tutmaz. Q3 portları yalnız belirli tek tırnaklı hata metinlerinden keşfediyor; örneğin `throw UnimplementedError()` kullanan yeni port keşfedilmez. Override kontrolü de yorumları ayırmadan metinde `...name(locator)` arıyor.  
   **Düzeltme:** Q2’yi gerçek controller yerleşimine hizalayın. Q3’te AST/üretilmiş port envanteri kullanın ve override listesinin gerçekten bileşime katıldığını doğrulayın.

10. **Küçük — Liste kesilme bilgisi sözleşmedeki başlıktan okunmuyor.**  
    **Yer:** `lib/features/scope/data/program_repository.dart:22`; `docs/architecture/veri-kalibi.md:43`.  
    Repository, `X-Result-Truncated` yerine `items.length >= 200` kullanıyor. Tam 200 kayıt içeren eksiksiz yanıtı kesilmiş gösterebilir; belgelenmiş veri kalıbına aykırı.  
    **Düzeltme:** Üretilmiş istemcide yanıt başlıklarını erişilebilir kılıp gerçek başlığı eşleyin; 200 kayıt/başlık yok ve başlık `true` durumlarını ayrı sınayın.

11. **Küçük — UI standardı ve kapanış kaydı eksik uygulanmış.**  
    **Yer:** `lib/core/ui/widgets/feedback/nz_error_state.dart:73`, `lib/core/ui/widgets/buttons/nz_button.dart:72`, `lib/core/ui/page/nz_page.dart:94`, `lib/app/router/transitions.dart:6`, `.github/pull_request_template.md:12`, `docs/yurutme/mob-ui-0/ilerleme.md:14`.  
    `NzErrorState.build` yaklaşık 130 satır; §5’in alt widget’a bölme ölçütünü aşıyor. Opaklık/süre sabitleri ADR karar 14’ün istediği tek tema noktasına toplanmamış. PR şablonuna §5 kontrol listesi eklenmemiş. Süreç kaydında O5 hâlâ “Bekliyor” ve O5 uygulama/kanıt kaydı yok.  
    **Düzeltme:** Widget’ı bölün, geçici görsel sabitleri merkezileştirin, PR kontrol listesini ve O5’in mevcut durum/kanıt kaydını tamamlayın.

## Kontrol listesi

“GEÇER”, aşağıda **statik inceleme sonucunu** ifade eder; testlerin bu koşumda geçtiği anlamına gelmez.

| Ölçüt | Sonuç | Kısa kanıt |
|---|---|---|
| 1 — §5 kontrol listesi | **KALIR** | Uzun build, merkezi olmayan sabitler ve eksik PR listesi; bulgu 11. |
| A0 — Sınırlar ve kapılar | **KALIR** | Bulgular 6–9. |
| A1 — Tema | **KALIR** | Rol eşlemesi doğru (`app_theme.dart:29`); görsel sabitler dağılmış, bulgu 11. |
| A2 — Uyarlanabilir layout | **GEÇER** | Genişlikten sınıflama ve 16/24/32 dolgu: `lib/core/ui/layout/nz_layout.dart:28`, `:43`. |
| A3 — Durum/sayfa/bağlantı | **GEÇER** | `nz_page.dart:45`, `nz_async_view.dart:37`, `connectivity_monitor.dart:42`. |
| A4 — Widget kiti | **KALIR** | Sayfalama yarışı; bulgu 3. |
| A5 — Router | **GEÇER** | Faz hedefi kapısı `router.dart:37`; yığın temizleme senaryoları `router_scoped_test.dart:216`. |
| A6 — Tercihler | **GEÇER** | Tipli erişim `app_preferences.dart:48`; açılıştan önce yükleme `bootstrap.dart:32`. Dil şimdilik yalnız `tr`. |
| A7 — Pilot | **KALIR** | Bulgular 1, 2, 4, 5; gerçek backend akış testi mevcut: `test_integration/pilot_flow_test.dart:59`. |
| 2 — CLAUDE güvenlik kuralları | **KALIR** | HTTPS/TLS ve kapsam kontrolleri mevcut; yenileme ve güncelleme ekranı açıkları var. |
| 3 — ADR-0001/0002/0003, UI API ve veri kalıbı | **KALIR** | Bileşim/retry ve temel UI imzaları uyumlu; sınır garantileri, karar 14 ve başlık eşlemesi eksik. |
| 4 — Atlatılabilirlik | **KALIR** | Aşağıdaki kural matrisi; bulgular 6–8. |
| 5 — Q1 | **GEÇER** | Eşikler 80/80/80/60/70; eksik dosya fail-closed: `check_coverage.dart:9`, `:116`. |
| 5 — Q2/Q3 | **KALIR** | Bulgu 9. |
| 5 — CI tanımı | **GEÇER** | Zorunlu adımlar `ci.yml:85`; SHA pinleri `:37`; golden Linux `:106`. |
| Derin bağlantı/bilinmeyen yol/katalog | **GEÇER** | Prod katalog tanımlamaz; scoped dışı yollar hedefe döner: `router.dart:42`, `:73`. Dev katalog muafiyeti açıkça tanımlı. |
| Scoped’dan çıkışta yığın | **GEÇER** | Kabuk dışı hedefe redirect; geri tuşu ve yeniden scoped testleri `router_scoped_test.dart:223`. |
| Auth/token/tek uçuş/nesil | **KALIR** | Tek uçuş `session_controller.dart:158`, yazma sırası `:236`; bulgular 1–2. |
| Parola durumu/log/toString | **KALIR** | Controller maskeli (`nz_password_field.dart:18`), DTO çıktısı değil; bulgu 4. |
| Parola değişimi sonrası belirteçler | **KALIR** | Normal akışta çift korunuyor (`identity_service.dart:118`); eşzamanlı yenileme açık, bulgu 2. |
| S2 kapsam başlığı | **GEÇER** | `interceptors.dart:114`; gerçek backend kanıt senaryosu `pilot_flow_test.dart:115`. |
| Sunucu `message` gösterilmemesi | **GEÇER** | `error_text.dart:6`, `nz_field_errors.dart:42`: metin yalnız koddan. |
| Riverpod otomatik retry | **GEÇER** | Üretim kabı `composition.dart:56`; bootstrap aynı kabı kullanıyor (`bootstrap.dart:37`). |
| `NzErrorState.retryAfter` | **GEÇER** | Sayaç yalnız düğmeyi etkinleştiriyor: `nz_error_state.dart:55`, `:78`. |
| `NzPagedList` tek istek/otomatik deneme | **KALIR** | Hata sonrası otomatik tekrar engelli; yenileme yarışı var, bulgu 3. |
| `ConnectivityMonitor` | **GEÇER** | Yalnız durum güncelliyor: `connectivity_monitor.dart:42`, `:56`. |
| Golden altyapısı/opaklık | **GEÇER** | Linux koşulu ve font yükleme `test/support/golden.dart:15`, `:53`; 27 PNG’nin tamamında alfa min/max **255/255**. |

**Her sınır kuralı için zihinsel atlatma denemesi:**

| Kural | Deneme ve statik sonuç |
|---|---|
| B1/B2/B3/B4 | Yasak hedefe mutlak `file:` import → **KALIR**, bulgu 7; `boundaries.dart:326`. |
| B5 | Feature içine beşinci katman açma → **GEÇER**, `boundaries.dart:208`. |
| B6 | Başka dizine `part` tüneli → **GEÇER**, `boundaries.dart:221`. |
| B7 | Yasak bağımlılığı koşullu import dalına koyma → **GEÇER**, `boundaries.dart:240`. |
| B8 | `%65` veya paket URI’sinde `..` → **GEÇER**, `boundaries.dart:315`; `file:` açığı bulgu 7’de. |
| D1 | Extension içinde `toJson` metodu → **GEÇER**, `boundaries.dart:508`, `:528`. |
| D2 | Çıkarımlı Map literal → **KALIR**, bulgu 8. |
| S1 | Güvenli depo SDK’sını izinli dosyadan export → **KALIR**, bulgu 7. |
| S2 | `HttpOverrides` için typedef → **KALIR**, bulgu 8. |
| S3 | Önekli `debugPrint` tear-off → **GEÇER**, `boundaries.dart:680`. |
| S4 | Flutter/dio’yu core barrel üzerinden alma → **KALIR**, bulgu 7. |
| S5/S6 | SDK’yı izinli dosyadan yeniden export → **GEÇER**, `boundaries.dart:356`. |
| S7 | Ham tercih deposuna `file:` import → **KALIR**, bulgu 7. |
| A0 | Çözümlenemeyen tip veya sahipsiz part → **GEÇER**, `api_surface.dart:115`, `:211`. |
| A1 | Üretilmiş DTO’ya `file:` import → **KALIR**, bulgu 7. |
| A2/A3 | DTO’yu typedef, callback veya record içinde açık API’ye koyma → **GEÇER**, `api_surface.dart:638`. |
| A4 | Hassas tipi getter/typedef ile dışarı çıkarma → **GEÇER**, `api_surface.dart:199`, `:530`. |
| A5 | Genel `T` üzerinden geri çağrı çıkarma → **KALIR**, bulgu 8. |
| G1 | `get_it` paket dosyasını `package:` yerine mutlak `file:` URI’siyle alma → **KALIR**, `boundaries.dart:412`; bulgu 7’nin URI sorunu. |
| G2 | Modül dosyasına `file:` import → **KALIR**, bulgu 7. |
| G3 | Farklı adlı alt sınıfın `super(...)` çağrısı → **KALIR**, bulgu 6. |
| U1 | Yerel `SizedBox` sınıfı + önekli Flutter `SizedBox` → **KALIR**, bulgu 6. |
| U2/U3/U6 | İzinli dosyadan dışa aktarılan typedef ile yapıcı çağrısı → **KALIR**, bulgu 6. |
| U4 | Önekli `MediaQuery.of` tear-off → **GEÇER**, `boundaries.dart:795`, `:804`. |
| U5 | Extension içinde örtük `extensions` erişimi → **KALIR**, bulgu 6. |
| N1 | Core helper üzerinden dolaylı dize gezinmesi → **KALIR**, bulgu 6. |

## Denetlenemeyenler

- Testler, analyzer, sınır araçları, kapsama ve golden karşılaştırmaları çalıştırılmadı. Atlatma örnekleri kaynak üzerinden izlendi; çalıştırılmış mutasyon kanıtı değildir.
- Eşzamanlılık bulguları statik akış analizidir; cihazda/test düzeneğinde yeniden üretilmedi.
- Güncel uzak CI sonuçları, PR içerikleri ve dal korumasının zorunlu kontrolleri ağ yasağı nedeniyle doğrulanmadı.
- Golden dosyalarının opaklığı doğrulandı; Linux’ta yeniden üretim eşitliği ve tüm ekranların taşma/görsel doğruluğu doğrulanmadı.
- Keychain/Keystore, gerçek TLS bağlantısı ve cihaz yaşam döngüsü davranışı çalıştırılarak sınanmadı.
- Worktree’nin izlenmeyen dosyalar dahil tam temizliği doğrulanmadı; yalnız staged/unstaged izlenen farkların boş olduğu görüldü.

---

## Düzeltme kanıtları (koordinatör eki)

Codex ikinci kez koşulmadı (oturum-5-pilot.md). Bulgular üç paralel Sonnet uygulayıcısına verildi;
her bulgu **önce kırmızı testle yeniden üretildi**, sonra düzeltildi; koordinatör (Opus) diff'leri
okudu, kapıları kendisi koştu ve mutasyonla doğruladı. Son durum: main `60dde43`.

| # | Önem | Sonuç | Kanıt |
|---|---|---|---|
| 1 | Önemli | Düzeltildi — yenileme + tekrar yalnız `platform.unauthenticated` 401'inde; gövdesiz/bozuk/farklı kodlu 401'de 0 yenileme, istek bir kez | #49 `195a526`; kırmızı testler `api_stack_test` (gövdesiz/bozuk 401, parola değiştirme iki kez gitmez) |
| 2 | Önemli | Düzeltildi — çift yazımları + çıkış/yeniden giriş silmesi tek yazım kuyruğunda; `_ensureCurrent` belirteç dizgeleriyle; bayrak en güncel çiftten. **Koordinatör denetimi ek açık buldu:** süren bayrak yazımı çıkış silmesinden sonra eski çifti depoya yazabiliyordu (çıkış yapılmış oturumun geri yüklenmesi) — kırmızı testle gösterildi, silme kuyruğa alındı | #49 `b867490`, `bd9377c`; `session_controller_test` "CX-W51-2" (iki tamamlanma sırası, çıkış → depoda çift yok) |
| 3 | Önemli | Düzeltildi — `NzPagedList` tek istek kilidi (`_firstInFlight`), yenilemede imleç sıfırlanır; ters yanıt sırası zaten nesille korunuyordu (regresyon testi) | #48 `3128c53`; "yenileme beklerken liste sonu çizilse de ek sayfa istenmez" |
| 4 | Önemli | Düzeltildi — üretici `password/token/secret` adlı `String` alanlı 6 DTO'da `@Freezed(toStringOverride: false)` | #49 `f7c5ca7`; `gen_test` (kural, gerçek DTO `toString`, model sayısı kilidi) |
| 5 | Önemli | Düzeltildi — API sürümü uyumsuzluğu (keşif/profil) → `AppPhase.updateRequired`; ekran iki gerekçeyi ayırır, giriş başlamaz | #49 `1215937`; app_phase + ekran testleri |
| 6 | Önemli | Düzeltildi — U1–U6 tip çözümlemeli `checkUiResolved` (typedef, tear-off, statik üye, örtük `this`); G3 `extends`/`super`/fabrika; N1 kapsamına `lib/core/**` | #50 `8b0d43d`; koordinatör mutasyonu: `checkUiResolved` kapatılınca 15 test kırmızı |
| 7 | Önemli | Düzeltildi — yeni **B9** (`file:`/mutlak URI yasak), B8 büyük harf/ters eğik çizgi, S1/S4 `export` yasağı | #50 `53366d6`; koordinatör mutasyonu: B9 kapatılınca B9 negatif matrisi kırmızı |
| 8 | Önemli | Düzeltildi — D2 Map literal, S2 `HttpOverrides` tip yolları, A5 tip parametresi | #50 `5f05109` |
| 9 | Önemli | Düzeltildi — Q2 `application/*_controller.dart` de zorunlu; Q3 port envanteri ve override katılımı AST ile | #50 `53780f3`; bugünkü ağaçta 10 port, Q2 eksik 0 |
| 10 | Küçük | **Devredildi (A8)** — üretilmiş istemci yanıt başlığını vermiyor; `X-Result-Truncated` için üretici değişikliği gerekir | `ilerleme.md` O5 devri |
| 11 | Küçük | Kısmen — `NzErrorState` alt widget'lara bölündü (#48 `57891c0`, golden değişmedi); PR şablonuna §5 kontrol listesi ve O5 kaydı (kapanış PR'ı). Opaklık/süre sabitlerinin tek noktada toplanması token işiyle **A8'e devredildi** (`TOKEN-BEKLİYOR` 2) | kapanış PR'ı |

Bütün sınır kurallarında bugünkü `lib/` ihlali 0. Son main kapıları: test 993 (+27 golden), kapsama
core %95,47 · application %100 · data %100 · presentation %98,95 · widgets %99,54.
Kilitli yerel entegrasyon (`verify-sirasi.sh … integration`, main `3e39551`): 9/9 (pilot akışı dahil);
her PR'da CI entegrasyon işi yeşil.

**Kapanış hükmü (koordinatör):** Önemli bulguların tamamı kapatıldı; iki Küçük madde gerekçesiyle A8'e
devredildi. MOB-UI-0 kabul ölçütleri sağlandı.
