Kök sayfa başlığı, sağında 44px daire eylemler ve aşağı kayarak açılan arama alanı.

- Başlık `m-h1` (28/34 Poppins). Eylem sırası: Ara, Filtre, Yeni (lime). Filtre etkinse sağ üstte 8px `accent-text` nokta.
- Arama `m-reveal`: `data-open="true"` olunca satır `0fr → 1fr` açılır, alan 8px yukarıdan solarak gelir (`--m-ease-sheet`, .42s). Odak halkası kesilmesin diye klip 6px dolgu, -6px kenar boşluğu taşır.
- Ana sayfada başlık yerine karşılama: `m-kicker` tarih + `m-greet` iki satır.

Yapma: arama alanını anında göstermek; başlık altına açıklama satırı eklemek.
