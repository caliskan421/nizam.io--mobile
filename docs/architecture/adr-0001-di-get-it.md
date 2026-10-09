# ADR-0001 — Bağımlılık enjeksiyonu: get_it bileşim kökü + Riverpod reaktif yüz

- **Durum:** Kabul edildi (2026-10-09)
- **Karar dayanağı:** D-0182 (ürün sahibi talebi; koordinatör kaydı), F14 MOB-0 r1
- **İlgili:** platform.md §6 ("Durum / DI: Riverpod 3"), K-11, Codex MOB-0 bulguları
  CX-Ö-03 (açılış sırası), CX-r1-Ö-01 (oturum nesli)

## Bağlam

MOB-0'da Riverpod hem reaktif durum hem tek DI aracıydı: altyapı tekilleri (güvenli depo,
belirteç deposu, sunucu bağı, oturum denetleyicisi, kapsam) ve aralarındaki **kablolar**
(yeniden bağlanma → oturum/kapsam temizliği, oturum → kapsam temizliği, kuruluma bağlı
yenileme çağrısı) `lib/core/providers.dart` içindeki sağlayıcı gövdelerine dağılmıştı.
Sonuçları: kablolama sağlayıcının ilk okunma anına bağlıydı (CX-Ö-03: oturum denetleyicisi
bağ doğrulamasından önce okunmazsa yeniden bağlanma dinleyicisi kayıtlı değildi); core,
somut uygulamaları (FlutterSecureStore) kendisi seçiyordu; nesne grafiğinin ömrü
(oluşturma/kapatma) tek bir yerde görünmüyordu.

## Karar

1. **get_it = bileşim kökü / nesne grafiği.** Bütün altyapı tekilleri ve kabloları yalnız
   `lib/app/di/dependencies.dart` (`configureDependencies`) içinde tembel tekil olarak
   kaydedilir; ömür get_it'tedir (`Composition.dispose()` → `reset`). Feature modülleri
   `features/<f>/<f>_module.dart` içindeki kayıt fonksiyonuyla bağımlılıklarını tanımlar ve
   bu fonksiyon yalnız `lib/app/di/composition.dart`'tan çağrılır.
2. **Global `GetIt.instance` kullanılmaz.** Her `Composition.create()` kendi
   `GetIt.asNewInstance()` örneğini kurar; testler birbirinden yalıtıktır (global durum ve
   `reset` disiplini gerekmez).
3. **Riverpod = reaktif durum ve sunuma açılan yüz.** `bindingState`, `sessionState`,
   `scopeState`, `appPhase`, `apiDio` gibi türetilmiş/izlenen durum Riverpod'da kalır.
   Altyapı sağlayıcıları (`flavor`, `httpAdapter`, `scopeController`, `serverBinding`,
   `sessionController`, `identityService`) **port**tur: varsayılanları `UnimplementedError`
   atar ve bileşim kökü onları get_it örnekleriyle geçersiz kılar. Core get_it'i import etmez.
4. **Servis bulucu yok.** `presentation` / `application` / `domain` / `data` ve core
   get_it'i import etmez; bağımlılıklar yapıcıdan gelir. Sınır kuralı
   (`tool/boundaries.dart`): **G1** get_it yalnız `lib/app/**` ve `<f>_module.dart`; **G2**
   modül dosyası yalnız `lib/app/di/**` tarafından import edilir (negatif testler
   `test/tool/boundaries_test.dart`).
5. `injectable` (kod üretimi) eklenmez; kayıt elle ve tek dosyada okunur.

## Sonuçlar

- Kablolar tek dosyada ve oluşturma anında kurulur; oturum denetleyicisi `Composition.create`
  sırasında (bağ doğrulamasından ÖNCE) oluşturulduğundan yeniden bağlanma dinleyicisi her
  zaman kayıtlıdır. `startup` sırası (önce oturum denetleyicisi, sonra bağ, sonra kuruluma
  bağlı geri yükleme) korunur.
- Testler gerçek bileşim kökünü kullanır (`Composition.create(secureStore:, httpAdapter:)`;
  `test/support/harness.dart`, `test_integration/backend_test.dart`); davranışı sabitleyen
  test taşımadan önce yazıldı (`test/app/composition_test.dart`).
- Güvenlik değişmezleri değişmedi: K-05, oturum nesli, kuruluma bağlı Bearer, yazma-öncesi
  işaret, startup sırası.
- Bedel: iki mekanizma birlikte yaşar; hangi nesnenin nerede olduğu bu ADR ve sınır
  kuralıyla sabitlenir.

## Reddedilen seçenekler

- **Yalnız Riverpod (önceki durum):** kablolama sağlayıcıların okunma sırasına bağlı kalır;
  nesne grafiği ve ömrü dağınık; somut altyapı seçimi core'da.
- **Yalnız get_it:** reaktif durum (bağ/oturum/kapsam fazı, router yönlendirmesi, türetilmiş
  `apiDio`) için ayrı bir bildirim mekanizması gerekir; sunum katmanında servis bulucu
  anti-desenine kapı açar. Riverpod'un test edilebilir reaktif yüzü korunmak istendi.
- **get_it + injectable:** kod üretimi istenmedi; küçük grafik için elle kayıt daha okunur.
