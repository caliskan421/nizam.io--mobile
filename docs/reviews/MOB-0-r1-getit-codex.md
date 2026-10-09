# MOB-0 r1 (get_it, D-0182) — Codex hükmü

**Hüküm: UYGUN** @ `2c60910` (diff `97a491e..2c60910`, CI run `37900381460` success). Denetçi: Codex `gpt-5.6-sol` (medium), `codex exec -s read-only`, tek koşum.
Küçük bulgu CX-g-K-01 bu belgeyi ekleyen PR ile düzeltildi.

---

# MOB-0 r1 (get_it) Codex hükmü

- Hüküm: **UYGUN**
- Denetlenen: main @ `2c6091092504aa4d8f770e2eb7ca29713d7a5109` (diff `97a491e..2c60910`)
- Gerekçe: Engelleyici veya Önemli bulgu yoktur. K-05, oturum nesli, kuruluma bağlı Bearer/refresh, açılış sırası, kapsam temizliği ve yol tabanlı operasyon kapısı korunmuştur.
  GetIt örnekleri yalıtık, portlar fail-closed ve üretim yolunda test deposu yoktur. Kullanıcının verdiği başarılı CI kanıtı kabul edilmiş, test çalıştırılmamıştır.
  Dispose sırasında rebind dinleyicisinin sökülmemesi küçük bir yaşam döngüsü açığıdır.

## Bulgular

| Kimlik (CX-g-E/Ö/K-nn) | Dosya:satır | Açıklama | Önerilen düzeltme |
|---|---|---|---|
| **CX-g-K-01** | `lib/app/di/dependencies.dart:79-90`; `lib/core/server/server_binding.dart:103-106` | `SessionController` dispose işlevi oturum→kapsam dinleyicisini kaldırıyor; ancak binding’e eklenen anonim rebind dinleyicisi için kaldırma mekanizması yok. `locator.reset()` kayıtları temizlese de eski binding nesnesi tutulursa veya doğrulaması sürüyorsa callback eski session/scope grafiğini çalıştırabilir. Mevcut test yalnız GetIt kaydının silindiğini doğruluyor. | `addRebindListener` bir kaldırma işlevi döndürsün ve session disposer bunu çağırsın. Bekleyen doğrulama sırasında dispose, iki kez dispose ve eski binding’in sonradan tetiklenmesi için regresyon testi ekleyin. |