Alttan açılan form ve seçim sayfası; tüm hızlı işlemler (yeni görev, toplantı, davet) bunu kullanır.

- Üst köşe `m-r-sheet` (28px), tutamaç 36×4. Başlık `m-sheet-title`, altında tek cümle açıklama, sağda Kapat.
- Açılış `m-sheet-up` .42s `--m-ease-sheet`; kapanış `.m-closing` .24s. Örtü `scrim` solarak gelir/gider.
- Bir satır açılınca (tarih, kişi seçimi) sayfa yüksekliği yumuşakça artar ve satır kapanınca eski yüksekliğine döner.
- İlk alan büyük başlık girişi (`m-title-input`).

Sağlaman gerekenler: `role="dialog" aria-modal="true"`, başlığa bağlı `aria-labelledby`, alt eylemler (Vazgeç + ana eylem).
