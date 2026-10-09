# MOB-0 (F14) — Codex faz kapısı hükmü

**Son hüküm: UYGUN** — 4. koşum, `main` @ `32223b9` (CI run `37895196553` success).
Denetçi: Codex `gpt-5.6-sol` (medium), `codex exec -s read-only`, her koşum tek ve salt okunur.
Kayıt: program F14 (`../program/fazlar/F14-mob-1-kimlik-kabuk-can.md`); bu depoda `project-control` yoktur.

| Koşum | Denetlenen `main` | Hüküm | Açılan bulgular | Düzeltme |
|---|---|---|---|---|
| 1 | `ec8b479` | UYGUN DEĞİL | CX-Ö-01…04 | PR #6 → `fca053a` |
| 2 (r1) | `fca053a` | UYGUN DEĞİL | CX-r1-Ö-01 (yeni) | PR #7 → `efb39f9` |
| 3 (r2) | `efb39f9` | UYGUN DEĞİL | CX-r2-Ö-01, CX-r2-K-01 (yeni) | PR #8 → `32223b9` |
| 4 (r3) | `32223b9` | **UYGUN** | yok | — |

Koordinatörce kabul edilen ve denetçiye bildirilen sapmalar:
- Entegrasyon testleri `integration_test/` yerine `test_integration/` altında, host VM'de gerçek HTTP/TLS ile; güvenli depo testte bellek içi.
- İlk yönetici F06'daki gibi geçici bootstrap aracıyla kurulur; araç backend imajına ve APK'ya girmez (`check-isolation.sh` + öz-test).
- Uygulama kimliği yer tutucu, imzasız (KR-13 varsayılanı); KR-03 24 h; KR-02 PARITY.
- Ekran yok (D-0174); `main_*.dart` minimal kabuk.

Aşağıda dört koşumun tam metni sırayla yer alır.

---

# MOB-0 Codex hükmü

- Hüküm: **UYGUN DEĞİL**
- Denetlenen: main @ `ec8b479f946d0ede1cef903b93b511a034dbb3dc`
- Gerekçe: Kullanıcı tarafından verilen CI run `37885156298` başarı kanıtı kabul edildi. Ancak K-05’in bozuk başarılı yanıt dalı, operasyon–yol bağının doğrulanmaması, açılışta yeniden bağlama sırası ve güvenli depo yazma hatası davranışında dört önemli doğruluk/güvenlik açığı bulundu.
- Salt-okunur denetim yapıldı; dosya değiştirilmedi ve test çalıştırılmadı.

## Bulgular

| Kimlik (CX-E-nn Engelleyici / CX-Ö-nn Önemli / CX-K-nn Küçük) | Dosya:satır | Açıklama | Önerilen düzeltme |
|---|---|---|---|
| **CX-Ö-01 Önemli** | `lib/core/session/session_controller.dart:98-120`; `lib/core/errors/api_error.dart:99-105`; `lib/core/api/generated/clients/identity_client.g.dart:78-85` | Refresh’in HTTP 200 yanıtında zorunlu alan yanlış/eksikse `RefreshResponse.fromJson` bir `TypeError` fırlatır. `apiCall` yalnız `DioException`, `_rotate` yalnız `ApiError` yakaladığı için K-05 belirsiz dalı çalışmaz; eski çift ve etkin oturum korunur ve aynı refresh belirteci sonraki çağrıda yeniden gönderilebilir. Mevcut “geçersiz yanıt” testi yalnız önceden oluşturulmuş `ApiError` ve nullable token eksikliğini kapsıyor. | Refresh DTO ayrıştırma hatalarını `client.invalid_response` olarak normalleştirin veya `_rotate` içinde güvenli biçimde belirsiz sonuç sayın. Bozuk 200 gövdesinden sonra oturumun `refreshAmbiguous` olması ve ikinci ağ isteğinin çıkmaması için test ekleyin. |
| **CX-Ö-02 Önemli** | `lib/core/http/interceptors.dart:55-87`; `lib/core/api/api_meta.dart:14-25` | Kapı operationId ve HTTP yöntemini doğruluyor fakat üretilen `ApiOperation.path` hiç kullanılmıyor. Üretilmiş istemcilerin dışarıdan değiştirilebilen `extras` parametresine aynı yöntemli başka bir operationId verilerek S2/S3 yolu S0/S1 metaverisiyle gönderilebilir; böylece eksik kapsamlı isteğin hiç gönderilmemesi güvencesi aşılır. | Gerçek URI yolunu üretilmiş operasyon yol şablonuyla doğrulayın ve uyuşmazlığı ağdan önce reddedin; mümkünse korumalı operationId metaverisinin çağıranca değiştirilememesini sağlayın. S2 yoluna S1 operationId verilmesini kapsayan negatif test ekleyin. |
| **CX-Ö-03 Önemli** | `lib/app/bootstrap.dart:24-28`; `lib/core/providers.dart:46-73`; `lib/core/server/server_binding.dart:175-189` | Taze `ProviderContainer` açılışında `binding.restore()` oturum sağlayıcısı oluşturulmadan çağrılır. Yeniden bağlama dinleyicisi yalnız `sessionControllerProvider` oluşturulunca kaydedildiğinden, kayıtlı origin’in `instance_id` değeri değişmişse dinleyici bulunmadan bağ kaydı yenilenir; ardından eski kuruluma ait belirteçler depodan etkin oturum olarak geri yüklenir. Mevcut yeniden bağlama testi oturumu önce oluşturduğu için bu açılış yolunu kanıtlamıyor. | `startup` içinde önce `SessionController`ı oluşturup dinleyiciyi kaydedin, sonra bağı doğrulayın ve yalnız doğrulama/temizlik tamamlandıktan sonra oturumu geri yükleyin. Taze container + eski bağ/token + değişmiş instance kimliği testi ekleyin. |
| **CX-Ö-04 Önemli** | `lib/core/session/session_controller.dart:140-151,160-165`; `test/core/session/session_controller_test.dart:194-203` | Yenileme sunucuda başarılı olup yeni çift güvenli depoya yazılamadığında eski kayıt siliniyor, fakat yeni çift yalnız bellekte etkinleştirilip refresh başarılı döndürülüyor. Bu, “yeni belirteç kaydedilmeden eski silinmez” kuralını bilinçli olarak ihlal ediyor. Ayrıca silme de başarısız olursa `_safeClear` hatayı yutuyor; iptal edilmiş eski refresh diskte kalırken oturum etkin görünür ve sonraki açılışta eski belirteç yeniden kullanılabilir. Test yalnız yazma hatasını benzetiyor, silme hatasını kapsamıyor. | Ağ yenilemesini tekrarlamadan güvenli-depo yazmasını yerel olarak yeniden deneyin; yeni çift kalıcılaşmadan veya eski kayıt kesin temizlenmeden oturumu başarılı/etkin saymayın. Temizlik başarısızlığını görünür bir güvenli-depo/yeniden-giriş durumuna taşıyın ve yazma+silme hatası testi ekleyin. |
---

# MOB-0 Codex hükmü

- Hüküm: **UYGUN DEĞİL**
- Denetlenen: main @ `fca053af605e685214c0a0c961b1d4240beee104`
- Gerekçe: Kullanıcı tarafından verilen CI run `37888440935` başarı kanıtı kabul edildi. Önceki **CX-Ö-01, CX-Ö-02, CX-Ö-03 ve CX-Ö-04 kapandı**; düzeltmeler ilgili regresyon testleriyle örtüşüyor.
  CX-Ö-04’te eski kaydın silinmesi kabul edilebilir fail-secure davranıştır: yeni çift etkinleştirilmiyor, yeniden giriş isteniyor ve silme başarısızsa kalıcı inflight işareti eski refresh’in yeniden kullanımını engelliyor.
  Ancak bekleyen giriş/refresh işlemi, çıkış veya yeniden bağlama sonrasında eski oturumu yeniden etkinleştirebildiğinden bir yeni Önemli bulgu vardır. Salt-okunur denetim yapıldı; test çalıştırılmadı.

## Bulgular

| Kimlik (CX-E-nn Engelleyici / CX-Ö-nn Önemli / CX-K-nn Küçük) | Dosya:satır | Açıklama | Önerilen düzeltme |
|---|---|---|---|
| **CX-r1-Ö-01 Önemli** | `lib/core/session/session_controller.dart:104-108,123-190`; `lib/features/identity/application/identity_service.dart:29-56`; `lib/core/server/server_binding.dart:175-190` | `clear()` bekleyen `_inflight` işlemini geçersizleştirmiyor. Eski çiftle başlamış `_rotate`, ağ yanıtı çıkış veya yeniden bağlama temizliğinden sonra gelirse yeni çifti kaydedip koşulsuz `SessionActive` durumuna geçiyor. Giriş de başlangıçtaki `BindingVerified` nesnesini yakalayıp yanıt sonrası bağın hâlâ aynı olduğunu denetlemeden `establish` çağırıyor. Böylece eski sunucudan geciken giriş/refresh yanıtı yeni bağ altında oturumu diriltebilir; sonraki kimlikli istek eski sunucunun Bearer belirtecini yeni sunucuya gönderebilir. Mevcut testlerde refresh/login beklerken `clear`, logout veya rebind senaryosu yoktur. | Oturuma artan bir nesil/epoch ekleyin; `clear` ve yeniden bağlama bunu artırıp bekleyen sonucu geçersiz kılsın. Refresh sonucu kaydedilmeden önce neslin, kaynak çiftin ve `instance_id`’nin değişmediğini; giriş sonucu için de güncel bağın yakalanan bağla aynı olduğunu doğrulayın. Kontrollü `Completer` testleriyle “bekleyen refresh/login → clear veya rebind → eski yanıt tamamlanır” durumunda oturumun kapalı, deponun boş ve yeni sunucuya eski Bearer gönderilmemiş olduğunu kanıtlayın. |
---

# MOB-0 Codex hükmü

- Hüküm: **UYGUN DEĞİL**
- Denetlenen: main @ `efb39f9ee1ec8443025c53185510f8b2e2bf281f`
- Gerekçe: CI run `37890583496` başarı kanıtı kabul edildi; talimat gereği testler yeniden çalıştırılmadı.
  **CX-r1-Ö-01’in** geciken giriş/refresh sonucu, yeniden bağlama, kurulum bağı, kapsam temizliği ve son doğrulamanın kazanması yolları kod ve regresyon testlerinde kapalıdır.
  Ancak geciken bir 401, oturum nesli denetlenmeden yeni oturumun Bearer belirteciyle yeniden oynatılabildiğinden yeni bir Önemli bulgu vardır.

## Bulgular

| Kimlik (CX-E-nn Engelleyici / CX-Ö-nn Önemli / CX-K-nn Küçük) | Dosya:satır | Açıklama | Önerilen düzeltme |
|---|---|---|---|
| **CX-r2-Ö-01 Önemli** | `lib/core/http/interceptors.dart:133-170`; `lib/core/session/session_controller.dart:145-153`; `test/core/session/stale_response_test.dart:193-215` | İstek başlangıcındaki oturum nesli kaydedilmiyor. A hesabının bekleyen isteği sırasında çıkış yapılıp aynı kurulumda B hesabıyla giriş yapılır ve eski istek 401 dönerse, `refresh(failedAccessToken: A)` belirteçlerin farklı olduğunu görerek doğrudan B belirtecini döndürür; ardından `dio.fetch` eski yöntem, gövde ve yolu B Bearer’ıyla tekrarlar. Böylece eski bir S1 yazma isteği yeni hesap adına uygulanabilir veya eski çağıran yeni hesabın yanıtını alabilir. Eklenen test yalnız geciken 403’ün parola bayrağını sınar; geciken 401 tekrar yolunu sınamaz. | İlk istekte `session.generation` değerini `extra` içine kaydedin ve 401 işlenirken hem refresh öncesinde hem tekrar öncesinde neslin değişmediğini doğrulayın. Değişmişse isteği `client.session_ended` ile sonlandırın. Kontrollü testte “A isteği bekler → çıkış → B girişi → A isteği 401” akışının refresh veya tekrar isteği göndermediğini kanıtlayın. |
| **CX-r2-K-01 Küçük** | `test_integration/backend/check-isolation.sh:20,31` | Betik `set -o pipefail` altında `docker export/unzip -p \| grep -q` kullanıyor. `grep -q` erken eşleşmede kapanınca üretici SIGPIPE ile 141 dönebilir ve bütün pipeline başarısız sayılarak `if` eşleşme yokmuş gibi ilerler. Mevcut APK üzerinde bilinen metinlerle yapılan salt-okunur yoklama bu davranışı (`141`) doğruladı; dolayısıyla APK izolasyon kapısı yasak izi kaçırabilir. | `grep`in tüm girdiyi tüketmesini sağlayın veya yalnız `grep` çıkış durumunu güvenilir biçimde değerlendirin. Yasak işaret içeren sentetik arşivin kapıyı kırmızıya çevirdiği negatif regresyon testi ekleyin. |
---

# MOB-0 Codex hükmü

- Hüküm: **UYGUN**
- Denetlenen: main @ `32223b98b5fcc14a744e7f496abf9aae9eb2e318`
- Gerekçe: CI run `37895196553` başarı kanıtı kabul edildi; talimat gereği testler yeniden çalıştırılmadı.
  **CX-r2-Ö-01**, istek nesli/Bearer/kapsam bağlamı, 401’de çift nesil denetimi ve A→çıkış→B regresyon testiyle kapanmıştır.
  **CX-r2-K-01**, boru hattının dosyaya alınması ve CI’daki kötü/temiz sentetik APK öz-testiyle kapanmıştır. Yeni güvenlik veya doğruluk bulgusu saptanmadı.

## Bulgular

yok