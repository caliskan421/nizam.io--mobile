Tarih aralığı seçen ay takvimi; seçili aralık daireleri saran tek bir haptır.

- Günler 30px daire, satır 34px. Uç günler `ink` dolgu, arası `bg-overlay` hap. Hap konumu: `left: calc((a + .5) / 7 * 100% - 17px)`, `width: calc((b - a) / 7 * 100% + 34px)`; `a`, `b` haftadaki ilk ve son sütun.
- Bugün ince halka; ay dışı günler `ink-faint`. İlk dokunuş başlangıç, ikinci bitiş; önceki güne dokunmak seçimi yeniler.

Yapma: takvim altına açıklama yazısı, günlere kutu çizgisi.
