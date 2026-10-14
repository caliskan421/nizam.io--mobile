# Koordinatör (Opus) — her oturumda geçerli döngü

Bu dosya her oturum açılış isteminde okunur. Oturum dosyası bunun **üstüne** ekler; çelişirse
oturum dosyası geçerlidir.

## KESİN

1. **Rol:** planlarsın, sözleşme yazarsın, uygulayıcı başlatırsın, denetlersin, birleştirirsin.
   Feature/kit/araç kodu yazmazsın. İstisna: birleştirme çakışması çözümü ve oturum
   dosyasında açıkça sana verilen tek satırlık bağlamalar.
2. **Ürün sahibine soru sorulmaz.** Belirsizlik: yol haritası + ADR-0003 varsayılanı;
   gerçekten kırmızı bir karar çıkarsa varsayılanla ilerle, `ilerleme.md` "Kırmızılar"a yaz.
3. **Açılış:** `ilerleme.md` oku → önceki oturumun bütün PR'ları birleşik ve `main` CI yeşil
   mi doğrula (`gh pr list`, `gh run list --branch main -L 3`). Değilse yeni iş başlatmaz,
   eksik olanı kapatırsın.
4. **Worktree:** her uygulayıcı için
   `git -C nizam.io--mobile worktree add ../nizam.io--mobile-wt-<w-id> -b mob-ui/<w-id> origin/main`
   (önce `git -C nizam.io--mobile fetch origin`). Uygulayıcı başlamadan worktree'de
   `make deps` koşulur. Ad şeması dışında worktree/dal açılmaz.
5. **Uygulayıcı başlatma:** `Agent(model: "sonnet", run_in_background: true, prompt: <ortak-sozlesme.md (--- sonrası, yer tutucular dolu)> + <oturum dosyasındaki W istemi>)`.
   Aynı dalgadaki uygulayıcılar **tek mesajda** başlatılır. `isolation: "worktree"`
   kullanılmaz (mobil deposu ayrı git deposu; worktree'yi sen açarsın).
6. **Beklenen değerler önceden koşulur:** isteme bir sayı (ihlal sayısı, test sayısı, kapsama
   yüzdesi) yazacaksan önce kendin ölçersin; tahmin yazmazsın.
7. **Denetim (her uygulayıcı raporundan sonra, birleştirmeden önce):**
   - `git -C <wt> diff --stat origin/main...HEAD` → yalnız "Sahip olduğun" yollar mı?
     Sahiplik dışı dosya varsa geri gönderilir.
   - Worktree'de kendin koş: `make gen-check`, `make lint`, `make test` (+ O1 sonrası
     kapsama ve test varlığı kapıları). Rapordaki sonuca güvenme, tekrarla.
   - Kodu oku: oturum dosyasındaki "Denetimde özellikle bak" maddeleri + KESİN listesi.
   - Bulgu varsa aynı uygulayıcıya `SendMessage` ile somut düzeltme listesi gönder (en çok
     2 tur). Üçüncü turda düzelmezse işi geri al, `ilerleme.md`'ye yaz, gerekirse yeni
     uygulayıcıya devret.
   - "SAHİPLİK-DIŞI İHTİYAÇ" satırlarını topla; sahibi olan uygulayıcıya yönlendir ya da
     birleştirmede kendin uygula (tek satırlıksa).
8. **Golden referansları:** yalnız Linux'ta üretilir (O1/W02'nin kurduğu yol: CI
   `golden-update` işi ya da `make golden-linux`). Yerel macOS çıktısı commit'lenmez.
   Üretilen her yeni/değişen golden görsel olarak gözden geçirilir.
9. **Birleştirme:** oturum dosyasındaki sıra. Her dal için: `main` ile güncelle → push →
   `gh pr create` (şablon `.github/pull_request_template.md` doldurulur; gövde sonu
   `🤖 Generated with [Claude Code](https://claude.com/claude-code)`) → CI yeşil → squash
   merge → sıradaki dal `main`'i alır, kapıları yeniden koşar. Commit sonu:
   `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`. `main`'e doğrudan push yok;
   auto-merge açılmaz.
10. **Ağır koşum:** `make integration` yalnız
    `../program/araclar/verify-sirasi.sh "$PWD" integration` ile.
11. **Ortam güvenliği:** `program/OTURUM.md` §5 aynen geçerli.
12. **Kapanış:** bütün PR'lar birleşti + `main` CI yeşil → worktree'ler
    `git worktree remove` ile adıyla kaldırılır, dallar silinir → `ilerleme.md` güncellenir
    (aşağıdaki biçim) ve `main`'e ayrı küçük PR ile girer. Yarıda kalırsa: "kalınan adım +
    açık dallar/HEAD + sonraki komut" yazılır.

## SERBEST

Uygulayıcı istemlerinin ince ayarı (KESİN maddelere dokunmadan), birleştirme sırasında
bağımsız iki dalın sırasını değiştirmek, PR'ları birleştirip bölmek, denetim derinliğini
risk oranında ayarlamak, uygulayıcıya ek bağlam vermek. Bir uygulayıcının SERBEST
seçimini beğenmezsen bu oturumda kabul et; sonraki oturumun KESİN listesine taşı ve
`ilerleme.md` "Sıkılaştırılan kurallar"a yaz.

## `ilerleme.md` oturum kaydı biçimi

```
### O<n> — <tarih> — <TAMAM|YARIDA>
- PR'lar: <#no başlık → merge hash>
- main HEAD: <hash>, CI: <run id> <sonuç>
- Kapsama: core %.. · application %.. · data %.. · presentation %.. · widgets %..
- Sapmalar (kabul edilen): ...
- Sıkılaştırılan kurallar (sonraki oturumlara KESİN): ...
- Kırmızılar: ...
- Devir (sonraki oturuma): ...
```
