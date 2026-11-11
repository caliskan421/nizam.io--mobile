# Mobil mesajlaşma altyapısı — kalite kaydı

2026-11-11. Kapsam: UI dışındaki messages domain/data/application ve testleri; API pini `v0.12.0-api`. Çalışma planı ve UI devri: [mesajlaşma altyapısı](../mesajlasma-altyapisi.md).

## Kanıt durumu

- Gerçek backend HTTP + doğrudan SSE senaryosu: **GEÇTİ**, tek birleşik test. Grup ve mesaj replay, farklı gövdeyle 409, program/departman/none kaynak değişimi, koordinatörlük referansı ve bahsetme, geçmiş metin araması, referans tür filtresi, anket son tarihi/oy/kapatma, açıklamalı/yanıtlı ek, dosya byte indirme, okunmamış özeti, SSE kimlik sinyali ve HTTP içerik uzlaştırması.
- Test yalnız kendi oluşturduğu benzersiz program ve koordinatörlüğü temizledi; paylaşılan backend durdurulmadı veya yeniden tohumlanmadı.
- Son ağaçta bütün messages testleri: **144/144 GEÇTİ** (application/domain/data ve mevcut ekran testleri). Bunların içindeki yeni application mekanizma regresyonları 17/17; yeni domain/data testleri de yeşil.
- Üretim: messages Riverpod kaynakları build_runner ile üretildi. Başlangıçtaki diğer feature generated hash farkları kapsam dışına çıkarıldı; elle generated değişikliği yapılmadı.
- İlk gerçek test denemesi eksik Riverpod extension importundan derlenemedi; import düzeltildi. Standart test yöneticisi paylaşılan dev tohumuna uymadığı için ilk giriş 401 aldı; depodaki belgeli sentetik dev hesabı env ile seçilince geçti. Parola veya belirteç bu kayda alınmadı.

## Bağımsız denetim

Tanık uygulayıcıların yazdığı dosyaları değiştirmeden backend ↔ repository/controller akışını okudu; gerçek test senaryosunu ayrı dosyalarda hazırladı. Saptanan eski arama yanıtı, sayfalama tekrarları, kapsam değişiminde gecikmiş yanıt ve eylem zamanlayıcıları düzeltildi.

Ek nihai kapı, Codex CLI ile salt okunur ve araç izli yürütüldü (ilk işlem HEAD/status, ondan fazla hedefli dosya okuması). İlk hüküm **DÜZELTME GEREKİR** idi:

1. İptal edilen birleştirme zamanlayıcısı null yapılmadığı için yeniden kurulum sonrası SSE güncellemeleri durabiliyordu. İptal sonrası alan sıfırlanır; yeni olayın tek `after=88` okumasıyla mesaj 89'u getirmesi testlidir.
2. Çok sayfalı gelen kutusu, oturum/program değişince eski imleçle yeni kapsamda devam edebiliyordu. Repository `isCurrent` kontrolünü her HTTP öncesi/sonrası yapar; çağıranlar yakalanmış oturum/program ve istek neslini karşılaştırır. Test ilk uçuş sonrası toplam 1, imleçli 0; başlangıçta geçersizse 0 HTTP çağrısı ölçer.
3. Tepki regression'ı fake'in gerçek çağrı önekinden farklı bir önek arıyordu. Gerçek `react`/`unreact` önekleri ve mutlak 0 sayımıyla düzeltildi.

Ayrıca eski `markAllRead` başarısının yeni program/oturum sayaçlarını sıfırlaması önlendi; iki gated regression yeni unread değerinin 7 kalmasını ve tek yazma çağrısını doğrular. Bağımsız tanık bu düzeltmeleri tekrar okuyup **kalan kritik bulgu yok; ilk kapı bulguları kapandı** hükmü verdi. CLI ilk raporu yeşil olarak yeniden adlandırılmadı; düzeltme sonrası kapanış ayrı tanık okumasıdır.

## Depo genelindeki kalite engelleri

Tam `make verify`, sıra kilidinden çalıştırıldı fakat başlangıçtan değişmeyen iki dosyanın formatında durdu: administration/application/admin_user_task_panel_controller.dart ve tables/presentation/table_page.dart. Temiz taban worktree'sinde aynı iki format hatası yeniden üretildi.

- Genel analyzer: **26 bulgu**. Temiz tabanda da aynı 26 bulgu; değişen mesajlaşma altyapısı ve yeni testlerin hedefli analizi temiz.
- Genel mimari/UI kural denetimi: **12 ihlal**; core UI, administration, tables ve timeline dosyaları. Bu çalışma bu dosyaları değiştirmedi. Kural kapısı zayıflatılmadı.
- Test-presence: administration/application/user_account_draft_controller_test.dart eksik; mesajlaşma testleri eksik değil.
- Geniş birim koşumu: **2391 geçti, 14 başarısız**. Kullanıcı profil akışı, tablet değişmezleri ve genel kural testlerinde başarısızlıklar var; messages tek başına ayrıca son ağaçta 144/144 geçti. Kapsama komutu test hatasıyla durdu; oluşan lcov için eşik denetimi ayrıca çalıştırıldı.
- Temiz tabanda users_profile_flow, tablet_measurements, file_size, boundaries ve api_surface test dosyaları yeniden koşuldu: **209 geçti, 9 başarısız**; profil/tablet ve kural hataları tabanda da var. Bu beş dosyalık koşum, tüm depodaki 14 başarısızlığın tamamını bire bir sınıflandırmış sayılmaz. Genel kapı ve kapsam dışı testler açık kalır.
- Kapsama: core %95,94, application %86,46, data %98,23, ortak widget %97,02 eşiklerini geçiyor. Presentation **%55,25 < %60**; genel kapı kırmızı. Eşik düşürülmedi ve UI dosyası değiştirilmedi.
- Üretim filtresi denemesi diğer generated çıktıları geçici kaldırdığı için bir genel analiz koşumu geçersizdir; tam build_runner ile tüm çıktılar geri üretildi. Son analiz ve testler geri yüklenmiş ağaçta yapıldı. Üretilmiş API dosyalarında teslim farkı yok.

Bu nedenle teslim **mesajlaşma altyapısı yerel doğrulandı; genel depo kapısı/CI bekliyor** düzeyindedir; tam depo doğrulaması veya main birleşmesi yeşil gösterilmez.

Temiz taban kontrolü için oluşturulan managed worktree'nin arşivlenmesi denendi; uygulama aracı "The task's primary checkout cannot be removed" cevabıyla reddetti. Salt okunur taban kopyası korunur; gerçek uygulama ve sonraki UI işi orijinal Projects/NIZAM.IO/nizam.io--mobile checkout'undaki `ozellik/f64-mesajlasma-altyapisi` dalındadır. Kaynak checkout managed olmadığı için onu tekrar attach etme aracı da kabul etmedi; dosyalar taşınmadı.

## Teslim sınırı

Mobil CI, uzak PR/merge ve cihaz doğrulaması bu yerel koşumun parçası değildir. KR-27 mobil CI tetiklemeyi yasakladığı için uzak yeşil iddiası yapılmaz. macOS'ta Linux golden hedefi çalıştırılmaz; görsel değişiklik yoktur. Program panosunda bu iş CI tamamlanmadan Kapandı sayılmaz.
