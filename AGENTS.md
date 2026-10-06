# AGENTS.md — nizam.io--mobile

Her ajan önce bu depodaki `CLAUDE.md`'yi okur; okuma sırası ve kurallar oradadır.

Özet:
1. Aktif iş `../program/DURUM.md` ve aktif faz dosyasından okunur.
2. API sözleşmesi yalnız backend `docs/api/` (etiketli sürüm); yerel kopya düzenlenmez.
3. Sunucu bağı fail-closed, belirteç yalnız güvenli depoda, kapsam başlıkları açık.
4. Her değişiklik PR + CI; PR şablonu doldurulur.
5. Paylaşılan makinede yalnız bu depoya ve adıyla belirtilen NIZAM.IO kaynaklarına
   (Compose projeleri, `nizamio_*` test veritabanları) dokunulur; toplu `docker` /
   `pkill` müdahalesi yasaktır.
