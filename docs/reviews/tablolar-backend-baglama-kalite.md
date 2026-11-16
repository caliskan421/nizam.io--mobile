# Tablolar backend bağlama ve canlı ortak çalışma — kalite kapısı (2026-11-13)

> **Durum (2026-11-17, main birleşmesi):** Bu dalın tablo uygulaması (`table_controller`,
> `table_sync_controller`, `table_write_queue`, `table_reference_controller` vb.) main'in
> `TableDetailController` + workspace uygulamasıyla birleşmede yer değiştirdi; güncel mobil
> tasarım `docs/yurutme/tablo-workspace-calisma.md`'dir. Bölüm 1–7 (backend sözleşme özeti)
> geçerli başvurudur; bölüm 8–9 dal geçmişindeki (etiket `yedek/tablolar-birlesme-oncesi-20261117`)
> tasarımı anlatır ve main uygulamasına taşınacak davranışların listesi olarak okunur.

**Dal:** `ozellik/tablolar-backend-baglama` (taban `origin/main`). **Tasarım belgesi:** [`../architecture/tablolar-backend-ve-canli-calisma.md`](../architecture/tablolar-backend-ve-canli-calisma.md).

**Kapsam:** statik tablolar prototipi backend tablolar API'sine bağlandı: liste/detay/oluşturma/silme, hücre ve satır/sütun komutları, geri alma, canlı senkron (SSE `stream` + `changes` + snapshot), presence, satır yorumları. Akış yeniden bağlanma kuralları `lib/core/domain/stream_reconnect.dart`'a ortaklandı (sohbet davranışı aynı).

**Roller:** araştırma ve kod Opus 5.5; test tanığı Sonnet 5.5 (bağımsız koşum, taban karşılaştırması, mutasyon tekrarı); nihai kapı Codex `gpt-6.1-sol` medium, `-s read-only`.

## Kapı turları

| Tur | Hüküm | Özet |
|---|---|---|
| 1 | UYGUN DEĞİL | 5 YÜKSEK: çakışmada yabancı değerin ezilmesi, imlecin görünümden önce ilerlemesi, eski makbuz/snapshot geri alması, yan okuma hatasında ikinci kayıt, çözüm okuması düşünce yazım kaybı; 6 ORTA |
| 2 | UYGUN DEĞİL | 7 kapandı; eşit sürümlü kendi makbuzu, imzaya bağlı işlem anahtarı, eski neslin `ready` talebini tüketmesi |
| 3 | UYGUN DEĞİL | YÜKSEK yok; geciken metadata makbuzu, silme tekrarının başarı işleyicisi (2 ORTA) |
| 4 | UYGUN DEĞİL | ters sırada dönen kendi metadata makbuzları (1 ORTA) |
| 5 | KOŞULLU UYGUN | 4 DÜŞÜK + tanığın bulduğu D2 sınır ihlali |
| 6 | KOŞULLU UYGUN | hepsi kapandı, yeni bulgu yok; koşul güncel test kanıtı → tanık son tur ile sağlandı |

**Ek kapsam (2026-11-14): referans hücreleri.** Pin `v0.18.0-api`; 5 referans tipi (tablo/kişi/departman/görev/dosya) tekli ve çoklu yazım, aday seçicileri (mevcut görünürlük uçları), `tables.reference_unavailable` geri alma, redakte hücrede onaylı tam değiştirme, tablo ve görev referansından gezinme; görev ayrıntısında katalog dışı kimlik araması (görünür departmanlarda en çok 20 `getWorkItem`, geçici hata/429/`work.not_assigned` ayrımı).

| Tur | Hüküm | Özet |
|---|---|---|
| 7 | UYGUN DEĞİL | 2 ORTA: 409→snapshot 429'da bekletilen yazımın kilitlenmesi; bayat katalogda görev referansının açılmaması |
| 8 | UYGUN DEĞİL | kuyruk kilidi kapandı; çözüm okumasında nesil koruması eksik, kesik katalog yolu açık (2 ORTA) |
| 9 | UYGUN DEĞİL | nesil koruması kapandı; geçici arama hatasının kalıcı "bulunamadı" bırakması (1 ORTA) + 20 sınırı açıklaması (DÜŞÜK) |
| 10 | KOŞULLU UYGUN | uçuştaki aramanın sahip değişiminde paylaşılması (DÜŞÜK) |
| 11 | **UYGUN** | kapandı; 403 yalnız `work.not_assigned` kesin. Not: dar fark incelemesi, 7 exec (KAPI §13 ~10 eşiğinin altında; önceki turlar eşiği geçti) |

Her düzeltme önce-kırmızı testle geldi; korumalar M1–M8, R1–R4 ve tur 9–12 mutasyonlarıyla (patch + komut + assertion) kırmızı gösterildi, tanık M1/M4–M7 ve R1/R4'ü bağımsız tekrarladı. Tek istisna: referans testlerinin önce-kırmızı commit'i kendi başına derlenmez (bisect'te atlanmalı); sonraki önce-kırmızı kanıtları yalnız yerel kayıtta.

## Son tanık koşumu (HEAD = bu belgenin bir önceki commit'i)

| Kontrol | Sonuç |
|---|---|
| `flutter analyze --fatal-infos` | temiz |
| `test/features/tables` | 102/102, tam koşumla eşzamanlı 2 koşu |
| `test/features/tasks`, `messages` | 282/282, 170/170 |
| `flutter test test/ --exclude-tags golden` | 2897 geçti / 12 düştü; 12 ad tabanla tek tek eşleşti |
| `file_size` | tabanla aynı 5 dosya |
| `check_boundaries` | 8 ihlal, tabanla aynı küme; tablolarda yok |
| `check_error_paths`, envanter | ihlal yok, güncel |
| `make gen` | tekrar üretimde fark yok |

## Birleşmeden önce (kırmızı)

1. **Pin — kapandı (2026-11-14):** `api-pin.json` `backendTag` = `v0.18.0-api` (yayımlı backend etiketi, tablolar Faz3 dahil). `make gen` koşuldu; fark yalnız asistan açıklamaları ve hata kataloğu başlığı, tablolar üretilmiş kodu değişmedi. Önizleme etiketi ve yerel klon talimatı artık gereksiz.
2. **CI koşulmadı:** mobil CI kota kuralı nedeniyle; commitler `[skip ci]`.
3. **Gerçek sunucuyla iki istemcili uçtan uca koşum yapılmadı;** doğrulama sahte backend ve backend sözleşmesi üzerinden.
4. `tables.*` TR hata metinleri web pininde yok; geçici olarak `i18n/server_errors_ek.tr.json`'da.

## Bilinen sınırlar (tasarım belgesinde ayrıntılı)

Belirteç yenilemesi sonrası akış normal kopma yoluyla (≤27 sn) yeniden açılır; kendi `number` yazımının sunucu normalizasyonu sonraki okumada görünür; belirsiz komut kaydı ekran denetleyicisi ömrü boyunca tutulur; çağıranın rolü yanıtta yok (ilk 403'te salt okunur); yankı ayrımı sözleşme alanlarından türetilmiştir. Referans sınırları: kişi seçicisi uç yetkisi nedeniyle yalnız yönetici/koordinatöre açık; görevsiz arşiv dosyası seçilemez; kişi/departman/dosya referansı yalnız gösterilir; mobilde referans sütunu oluşturulmaz. Kapsam dışı: paylaşım/ekip rolü/şablon/proje/ek ekranları, yorum düzenleme ekranı.
