# Tablolar backend bağlama ve canlı ortak çalışma — kalite kapısı (2026-11-13)

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
| 6 | **KOŞULLU UYGUN** | hepsi kapandı, yeni bulgu yok; koşul güncel test kanıtı → tanık son tur ile sağlandı |

Her düzeltme önce-kırmızı testle geldi; korumalar M1–M8 mutasyonlarıyla (patch + komut + assertion) kırmızı gösterildi, tanık M1/M4–M7'yi bağımsız tekrarladı.

## Son tanık koşumu (HEAD = bu belgenin bir önceki commit'i)

| Kontrol | Sonuç |
|---|---|
| `flutter analyze --fatal-infos` | temiz |
| `test/features/tables` | 80/80, tam koşumla eşzamanlı 3 koşu |
| `test/features/messages` | 170/170 |
| `flutter test test/ --exclude-tags golden` | 2866 geçti / 12 düştü; 12'si tabanda da düşen aynı adlar |
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

Belirteç yenilemesi sonrası akış normal kopma yoluyla (≤27 sn) yeniden açılır; kendi `number` yazımının sunucu normalizasyonu sonraki okumada görünür; belirsiz komut kaydı ekran denetleyicisi ömrü boyunca tutulur; çağıranın rolü yanıtta yok (ilk 403'te salt okunur); yankı ayrımı sözleşme alanlarından türetilmiştir. Kapsam dışı: paylaşım/ekip rolü/şablon/proje/ek ekranları, referans hücre yazımı (seçiciler) ve referanstan hedef tabloya gezinme, yorum düzenleme ekranı.
