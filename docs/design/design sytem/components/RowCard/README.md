`bg-raised` üzerinde tek kart içinde form satırları; her satır dokununca yerinde açılır.

- Satır 52px: 20px ikon, etiket, sağa yaslı değer (seçilmemişse `ink-muted` "Seç"), dönen ok. Açılan içerik `m-acc` ile `0fr → 1fr`.
- Seçenek satırı `m-opt` (`role="radio"`), seçili olan kalın ve `accent-text` tik taşır; kod veya sayı sağa yaslı mono.
- Satır içi segment `m-seg` (Düşük / Orta / Yüksek, bu sırayla); öncelik çubukları boy değiştirmez, yalnızca renklenir.
- Anahtar satırı: etiket `label` ile anahtara bağlıdır.

Yapma: satırları ayrı kartlara bölmek; açılır listeyi sayfa dışına (modal) taşımak.
