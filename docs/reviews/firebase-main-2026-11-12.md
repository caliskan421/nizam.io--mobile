# Firebase dalının main ile birleştirilmesi

2026-11-12. Ürün sahibi isteğiyle `main` (`110b71b`) ile tamamlanan Firebase dalı
`ozellik/firebase-hata-takibi-ve-surum-yonetimi` (`0f97790`) birleştirildi.
İnceleme ve birleştirme tek ajanla yapıldı; backend veya Firebase Console değiştirilmedi.

## Kapsam

- Native sürüm/build okuma, Remote Config politikası, kalıcı son geçerli politika,
  zorunlu/isteğe bağlı güncelleme ekranı ve mağaza yönlendirme adaptörü.
- Kullanıcı onaylı merkezi hata raporlama, güvenli sınıflandırma, sağlayıcı/global
  hata kancaları ve uygulama genelindeki hata yollarının statik denetimi.
- Main'deki telefon Gantt tasarımı, tam ekran üst güvenli alanı, geri kaydırma,
  mesaj bestecisi ve koordinatörlük iyileştirmeleri korundu.
- Zaman çizelgesi çakışmalarında hem hata raporlama hem ekran/oturum sahiplik
  denetimleri korundu. Üye ekleme ve tablet Gantt kartındaki yeni catch'ler de
  ortak raporlamaya bağlandı.
- Koordinatörlük takvimindeki AsyncError, sağlayıcı gözlemcisinin gördüğü aynı
  hata/yığın nesnesini yeniden sarar; gerekçeli statik istisna ve envanter güncellendi.
- Üretilmiş kod kaynaklarından yenilendi; üretilmiş API sözleşmesinde fark yok.

## Doğrulama ve sınırlar

- `make gen`: başarılı; backend `v0.15.0-api` pini korunuyor.
- Birleşmede ele alınan app/config, telemetry ve timeline/member dosyalarının
  `dart analyze` sonucu: sorun yok.
- `check_error_paths`: 1519 dosya, ihlal yok.
- `git diff --check`: temiz.
- App config/telemetry/router/composition, core config/telemetry/preferences/HTTP/
  network/session/server/scope, timeline/coordinatorships/calendar/messages ve
  hata yolu/sembol betiği testlerinde **925 geçti, 1 başarısız** (çıkış 1).
- `release_policy_host_test.dart` içindeki “optional dismissal never dismisses a
  later mandatory policy” testi `Kapat` semantics düğmesini bulamıyor. Aynı test,
  Firebase dalının kendi çalışma ağacında da aynı biçimde başarısız oldu; test ve
  ilgili ekran/düğme dosyaları kaynak dalla aynı. Ürün sahibinin mevcut testlere
  dokunmama talimatıyla değiştirilmedi.

Prod Firebase hâlâ kapalıdır; prod istemci dosyaları, gerçek mağaza/imzalı dağıtım,
native crash'in konsolda görünmesi ve sembol tesliminin yayın kabulü bu birleşmenin
kapsamında değildir. Kaynak çalışma ağacındaki commit edilmemiş native probe
değişikliği alınmadı. Uzak CI mevcut kota kuralıyla tetiklenmez (`[skip ci]`);
tam verify veya yeşil CI kabulü verilmez.
