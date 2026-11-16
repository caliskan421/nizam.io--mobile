# iPad notları — Codex kalite kontrolü (gpt-6-astra, salt okunur, tek koşum)

Kapsam: `e641d2e..` iPad notları paketleri (A–N) + v0.19.0-api pin ve D/F/I bağlantısı. Tarih: 2026-11-14.

## Hüküm

Salt okunur inceleme tamamlandı; kod değiştirilmedi. Flutter testleri ve CI çalıştırılmadı.

1. **yüksek | `lib/features/activity/activity_module.dart:14` |** Gerçek işlem geçmişi, oturum değişimini izlemeyen `keepAlive` `ActivityLogController` üzerinden sunuluyor. Yönetici çıkıp başka hesap girdiğinde önceki yöneticinin kayıtları bellekte kalıyor ve yeni hesaba gösterilebiliyor; yeni yetki kontrolü yapılmıyor. **Önerilen düzeltme:** Controller’ı oturum nesline bağlayın; sahip değiştiğinde önceki veriyi ve geç gelen yanıtları dışlayın.

2. **yüksek | `lib/features/tasks/presentation/detail/subtask_create_sheet.dart:18` |** Başarısız alt görev oluşturma tekrar açıldığında başlık korunuyor fakat kanıt zorunluluğu daima `false` oluyor. İlk istek `true` ile sunucuda işlenip yanıt kaybolmuşsa, tekrar gönderim farklı gövde imzasıyla yeni idempotency anahtarı üretip ikinci alt görev oluşturabiliyor. **Önerilen düzeltme:** Bekleyen taslağın başlığıyla birlikte `evidenceRequired` değerini de geri yükleyin; aynı işlemin tekrarında gövde ve anahtarı koruyun.

3. **orta | `lib/features/activity/data/audit_api_repository.dart:37` |** Yalnız ilk 200 kayıt alınıyor; sözleşmedeki `next_cursor` atılıyor. “Daha fazla göster” yalnız bu yerel kümeyi genişlettiğinden eski kayıtlara erişilemiyor; filtreler de eksik kümede çalışıyor. **Önerilen düzeltme:** İmleci domain/controller katmanına taşıyıp sonraki sayfaları yükleyin.

4. **orta | `lib/features/activity/domain/activity_query.dart:130` |** Hedef metni `t.code` ile oluşturuluyor; gerçek API eşlemesinde bu değer görev UUID’si. `taskCodeOf` ise yalnız `ALT-16` biçimini kabul ediyor. Dolayısıyla gerçek görev geçmişi satırları görevi açmıyor ve kullanıcıya kısa kod yerine UUID gösteriliyor. **Önerilen düzeltme:** Görünen metinde `displayCode`, gezinmede doğrudan `subjectId` kullanın; kimliği metinden ayrıştırmayın.

5. **orta | `lib/features/notifications/domain/notification_groups.dart:10` |** Bu paketin eklediği hatırlatma ucu backend’de `work.task.reminder` bildirimi üretiyor; istemcinin `NotificationType` eşlemesinde bu tür yok. Hatırlatma “Görevler” yerine “Diğer” grubuna düşüyor ve hatırlatma başlığı gösterilmiyor. **Önerilen düzeltme:** Tür eşlemesini, Türkçe başlığını ve görev grubuna yönlendirmesini ekleyin.

6. **orta | `lib/features/notifications/presentation/notifications_sheet.dart:141` |** `error ??= await ctl.markRead(id)` ilk hata sonrasında sağ tarafı çalıştırmıyor. Birleşmiş bildirimlerden biri başarısız olduğunda kalanların hiçbirine okundu isteği gönderilmiyor; ardından hedef ekran yine açılıyor. **Önerilen düzeltme:** Her `markRead` çağrısını koşulsuz çalıştırın, yalnız dönen ilk hatayı saklayın.

7. **orta | `lib/features/timeline/domain/horizontal_timeline.dart:419` |** Ortak arama fonksiyonuna geçiş, tablette mevcut koordinatörlük adı/kodu aramasını kaldırmış. Yeni fonksiyon yalnız görev başlığı, görev kodları ve atananları tarıyor; önceden sonuç veren koordinatörlük sorguları artık boş dönüyor. **Önerilen düzeltme:** Ortak eşleşmeye koordinatörlük adı ve etiketini de dahil edin.

8. **orta | `lib/core/ui/page/nz_page.dart:231` |** Çevrimdışı değişikliği yalnız şerit ekliyor; son verideki yazma eylemlerini kapatmıyor. Görev durum değiştirme, silme ve yükleme gibi işlemler bağlantı yokken hâlâ tetiklenebiliyor. İPad #47’deki “son veri salt okunur” maddesi tamamlanmamış. **Önerilen düzeltme:** Bağlantı kesikken yazma eylemlerini hem sunumda hem komut girişlerinde engelleyin; okuma ve gezinmeyi açık tutun.

**GEÇMEZ**
## Uygulanan düzeltmeler

Sekiz bulgunun hepsi tek commit'te uygulandı ("duzeltme: Codex kalite kontrolü bulguları (mobil)"): oturum nesline bağlı işlem geçmişi, imleçli sayfalama, görev kimliğiyle gezinme, bekleyen alt görevin kanıt seçimiyle geri yüklenmesi, `work.task.reminder` türü, birleşik bildirimlerde koşulsuz okundu, koordinatörlük adıyla arama, çevrimdışıyken yazma isteklerinin gönderilmeden reddi. İlgili testler eklendi/güncellendi ve geçti.
