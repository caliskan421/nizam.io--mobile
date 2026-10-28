RoketPortal'ın telefon arayüzü için kurallar. Masaüstü sistemi (RoketPortal) ile aynı renkleri paylaşır; bu sistem bunların üstüne mobilin cam yüzeylerini, dokunma ölçülerini, alt sayfa ve sohbet kalıplarını ekler. Ekranlar 390×844 için çizilir.

## Kullanım

- Ekranın kökü `m-screen` sınıfını alır; sınıflar `components/bundle.css` içindedir ve `m-` ile başlar. Değerler `tokens.css`'teki değişkenlerden gelir, ham hex yazma.
- Varsayılan tema koyu (`dark`). Açık tema aynı değişken adlarıyla çalışır.
- Yan boşluk `m-gutter` (16px). Bölümler arası `m-gap-xl`, kart listeleri `m-gap-md`.

## İçerik dili

- Türkçe, "sen" diliyle: "Kanıt yükle", "Seni bekleyen 3 onay var".
- Ünlem işareti ve emoji kullanma. Tepkiler bile SVG ikondur (beğen, kalp, tamam, yıldız).
- Düğme ne yapacağını söyler: "Oluştur", "Onayla", "Atanana hatırlat". Tost olanı söyler: "Görev oluşturuldu".
- Küçük harfli mono etiketler (`m-kicker`): "tüm görevler · 76", "işlem geçmişi". Kodlar büyük harf: `ALT-5`, `ELE`.
- Sayfa başlığının altına açıklama satırı yazma; boşluk sadelik içindir.

## Renk

- Zemin `bg-base`, kart ve sayfa yüzeyi `bg-surface`, form satırları ve sekme rayı `bg-raised`, seçili parça `bg-overlay`.
- Metin `ink`, ikincil `ink-muted`, üçüncül (kod, sayaç) `ink-faint`.
- `accent` (lime) yalnızca dolgudur: ekrandaki tek ana eylem, açık anahtar, gönder, okunmamış rozeti. Vurgulu yazı ve tik için `accent-text`.
- Durum: devam `violet`, onayda `gold`, gecikme `danger`, tamam `accent-text`. Durumu her zaman bir kelimeyle de yaz.
- Cam: üst çubuk ve sohbet şeritleri `glass-bar`, yüzen kontroller `glass-float`, flyout `glass-menu`, kenarlar `glass-edge`, cam üstü yazı `glass-ink`.
- Kişi avatarları `avatar-1…5` sırasıyla döner, baş harfler `on-avatar`.

## Yazı

- Başlıklar Poppins (`--font-display`): `m-greet` 30, `m-h1` 28, `m-h1-detail` 24, `m-sheet-title` 20.
- Gövde Inter (`--font-sans`): mesaj `m-message` 15/21, form `m-body` 14/20, alt yazı `m-caption` 12/16.
- Kod, tarih ve sayaç Geist Mono (`--font-mono`), `tabular-nums`.
- Girişler 16px'tir (`m-input`); daha küçüğü iOS'ta ekranı yakınlaştırır.

## Yüzeyler ve derinlik

- Üst çubuk 56px, yapışkan, `blur(var(--m-blur-bar)) saturate(1.4)`; içerik altından bulanıklaşarak geçer. Detay sayfasında sekme şeridi de üst çubuğun altına (64px) yapışır.
- Alt menü ekranın üstünde yüzer: 16px yanlardan, 24px alttan; `m-sh-float`.
- Kart ve KPI: `surface-top → bg-surface` geçiş, 1px `border-subtle`, üst iç ışık `edge-light`, köşe `m-r-card`.
- Form satırları tek `bg-raised` kartta toplanır (`m-r-row`), aralarında 1px çizgi.
- Alt sayfa `m-r-sheet` üst köşe, `m-sh-sheet`; çekmece sağdan, `m-sh-drawer`.

## Hareket

Hareket akıcı ve fiziksel olmalı; hızlı açılır, daha hızlı kapanır.

- Alt sayfa, akordeon, arama açılışı: `--m-ease-sheet` (`cubic-bezier(.32,.72,0,1)`), .42s.
- Sekme başparmağı, alt menü genişlemesi, anahtar: `--m-ease-spring` (`cubic-bezier(.34,1.42,.5,1)`), .42–.62s; hafif taşma bilinçlidir.
- Kapanış: `--m-ease-exit`, .24s. Her açılan katmanın bir kapanış animasyonu vardır; örtü de söner.
- Ekran geçişi: ileri `m-push` (36px sağdan), geri `m-pop`, sekme değişimi `m-tab` (10px aşağıdan). .38s `--m-ease-out`.
- Basma: düğmeler `scale(.96)`, kartlar `scale(.985)`, .16s.
- Yükseklik değişen kaplar `grid-template-rows: 0fr → 1fr` ile açılır; `height: auto` animasyonu kullanma.
- `prefers-reduced-motion` açıksa tüm süreler 1ms olur.

## Gezinme

- Alt menü üç öğedir: Ana sayfa, Görevler ve son girilen modül (Koordinatörlükler, Arşiv, Mesajlar). Etkin öğeye tekrar dokunmak o sayfanın kısayol menüsünü açar.
- Sağ üstteki cam menü dairesi sağdan çekmeceyi açar; tüm modüller oradadır.
- Detay sayfalarında sol üstte Geri ve soluk kod. Aynı türde bir detaydan diğerine geçmek sayfayı yerinde değiştirir, geri yığınına eklemez.
- Sohbet ve zaman çizelgesinde alt menü gizlenir.

## Dokunma

- En küçük hedef `m-tap` (44px). Satırlar 52px, çekmece satırı 48px, flyout satırı 46px.
- Mesajlara dokunmak bir şey yapmaz; basılı tutmak (480 ms) işlemleri açar.
- Odak halkası 2px `focus-ring`, 2px boşlukla. Kırpılan kaplarda 6px iç boşluk / -6px dış boşluk ile halkaya yer aç.

## İkonlar

- Satır içi çizgi SVG, 24 görüş kutusu, `stroke-width: 1.75`, yuvarlak uç; boyut 20px (`m-icon`), küçük 16px (`m-icon--sm`). Renk `currentColor`.
- Logo `assets/Logos/roketportal-mark.svg`: üst çubukta 32×32, ürün adının solunda. Yeniden çizme veya renklendirme.
- Emoji ve ikon yazı tipi yok.
